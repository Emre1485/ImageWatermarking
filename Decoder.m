classdef Decoder
    methods (Static)
        function decodedMessage = decode(imagePath)
            % Open the image file to decode the hidden message
            image = imread(imagePath);
            [height, width, channels] = size(image);
            
            % variable'lari ayarlama
            pixel_count = 1; % Her 3 pixelde kontrol bitini check et
            string = ''; % binary veriyi tutucak 
            endFlag = false; %  mesaj sonuna gelindiğini belirten işaret-flag
            controlBit = '1'; % Control bit (son pixel '1' ise control bit)

            % Her pixeli dönerek veriyi çıkarıyo
            for i = 1:width
                if endFlag
                    break;
                end
                for j = 1:height
                    if channels == 4
                        % RGBA image işleme
                        RGBA = image(j, i, :);
                        R = RGBA(1);
                        G = RGBA(2);
                        B = RGBA(3);
                        A = RGBA(4);
                    else
                        % RGB image processing
                        RGB = image(j, i, :);
                        R = RGB(1);
                        G = RGB(2);
                        B = RGB(3);
                    end
                    
                    % Append LSB of R and G channels to string
                    string = strcat(string, num2str(bitget(R, 8)));
                    string = strcat(string, num2str(bitget(G, 8)));
                    
                    % For the B channel, check if it has the control bit
                    if pixel_count < 3
                        string = strcat(string, num2str(bitget(B, 8)));
                        pixel_count = pixel_count + 1;
                    else
                        % Check if control bit in B is '1' to end the message
                        if bitget(B, 8) == 1
                            endFlag = true;
                            break;
                        else
                            pixel_count = 1; % Reset pixel count after checking control bit
                        end
                    end
                end
                if endFlag
                    break;
                end
            end

            % Split the binary string into 8-bit chunks and convert to characters
            binaryChunks = Decoder.split(string, 8);
            decodedMessage = '';
            for i = 1:length(binaryChunks)
                decodedMessage = strcat(decodedMessage, char(bin2dec(binaryChunks{i})));
            end
        end
        
        function result = split(input, size)
            % Helper function to split a string into chunks of specified size
            result = cell(1, ceil(length(input) / size));
            for i = 1:ceil(length(input) / size)
                startIdx = (i - 1) * size + 1;
                endIdx = min(i * size, length(input));
                result{i} = input(startIdx:endIdx);
            end
        end
    end
end
