Encoder.encode('image.png', 'secret.txt');
disp('-Veri Gizlendi-');


decodedMessage = Decoder.decode('modified.png');
disp('Gizli Mesaj:');
disp(decodedMessage);

