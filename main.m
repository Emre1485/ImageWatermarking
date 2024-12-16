Encoder.encode('image.png', 'secret.txt');
disp('-Data has been hidden-');


decodedMessage = Decoder.decode('modified.png');
disp('Secret Message:');
disp(decodedMessage);

