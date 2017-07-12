clear;clc;
% performing correction in ntsc domain

I = imread('/home/shared/Clearwater/Georges/Original/013ST_1Q_CAN_GB_16_K1.jpg');

%convert the domain
J = rgb2ntsc(I);
%intensity channel
Y = J(:,:,1);

%perform the correction
tic;[a,b,c] = splineCorrect(Y,1e-5);toc;

figure,imshow(a,[])

meanfactor = mean(a(:))/mean(mean(J(:,:,1))); 

J(:,:,1) = a./meanfactor;
U = ntsc2rgb(J);
U = uint8((U - min(U(:)))*255);
imwrite(U,'final.png');
 
figure,imshow(U,[]);





























