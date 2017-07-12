clc;close all;clear;

img = imread('/home/shared/Clearwater/Georges/Original/218ST_1Q_CAN_GB_16_K1.jpg');
figure,imshow(img(:,:,1),[]);
I = imresize(img,0.1);
for ii = 1
    J = log(im2double(I(:,:,ii)));

    x = {1:size(J,1),1:size(J,2)};


    [smooth,p] = csaps(x,J,[],x);
    surf(x{1},x{2},smooth.'), axis off

%Note the need to transpose the array smooth. For a somewhat smoother approximation, use a slightly smaller value of p than the one, .9998889, used above by csaps. The final plot is obtained by the following:

    smoother = csaps(x,J,.0001,x);
    figure, surf(x{1},x{2},smoother.'), axis on

    A = log(im2double(img(:,:,1))) ;
    B = imresize(smoother,[2736,3648]);
    D = mean(B(:))./mean(A(:));
    
    K = (A - B);

    cImage(:,:,ii) = exp(K);
end
c = mat2gray(cImage)./D;

d = uint8((c - min(c(:))).*255);
figure,imshow(d,[])