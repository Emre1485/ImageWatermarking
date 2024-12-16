classdef Encoder
    methods (Static)
        function encode(imagePath, textFilePath)
            % Open the text file containing the message to hide
            fid = fopen(textFilePath, 'r');
            text = fscanf(fid, '%c');
            fclose(fid);
            
            % If message is empty, return
            if isempty(text)
                return;
            end
            
            % Convert the message to binary + control bits
            binary = '';
            for i = 1:length(text)
                binary = strcat(binary, dec2bin(double(text(i)), 8));
                if i == length(text)
                    binary = strcat(binary, '1'); % Last character control bit
                else
                    binary = strcat(binary, '0'); % Non-last character control bit
                end
            end
            
            % Open the image file
            image = imread(imagePath);
            [height, width, channels] = size(image);
            
            % Check if image has RGB or RGBA pixels
            if channels == 4
                rgba = true; % Image has RGBA pixels
            else
                rgba = false; % Image has RGB pixels
            end
            
            % Initialize variables for hiding the message
            count_letter = 1; % Track position in the binary string
            
            % Process each pixel to embed the message
            for i = 1:width
                for j = 1:height
                    if rgba
                        % RGBA image processing
                        pixel = image(j, i, :);
                        R = pixel(1);
                        G = pixel(2);
                        B = pixel(3);
                        A = pixel(4);
                    else
                        % RGB image processing
                        pixel = image(j, i, :);
                        R = pixel(1);
                        G = pixel(2);
                        B = pixel(3);
                    end
                    
                    % Modify RGB channels with the binary message
                    if bitget(R, 8) == 0
                        R = bitset(R, 8, str2double(binary(count_letter)));
                    else
                        if binary(count_letter) == '0'
                            R = bitand(R, 254);
                        else
                            R = bitset(R, 8);
                        end
                    end
                    count_letter = count_letter + 1;
                    
                    if bitget(G, 8) == 0
                        G = bitset(G, 8, str2double(binary(count_letter)));
                    else
                        if binary(count_letter) == '0'
                            G = bitand(G, 254);
                        else
                            G = bitset(G, 8);
                        end
                    end
                    count_letter = count_letter + 1;
                    
                    if bitget(B, 8) == 0
                        B = bitset(B, 8, str2double(binary(count_letter)));
                    else
                        if binary(count_letter) == '0'
                            B = bitand(B, 254);
                        else
                            B = bitset(B, 8);
                        end
                    end
                    count_letter = count_letter + 1;
                    
                    % Set the new pixel value
                    if rgba
                        image(j, i, :) = [R, G, B, A];
                    else
                        image(j, i, :) = [R, G, B];
                    end
                    
                    % Stop if the message is completely embedded
                    if count_letter > length(binary)
                        break;
                    end
                end
                if count_letter > length(binary)
                    break;
                end
            end
            
            % Save the modified image
            imwrite(image, 'modified.png');
        end
    end
end
