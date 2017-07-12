function [xCor,yCor,R] = dogDetect(colorImage,minR,maxR,threshold)
% BlobFinder It will sequentially implement the Difference of Gaussian(DoG)
% filters to the images and find radius/locations of the blob which gives
% the maximum responce at the given radius
%
% Arguments(input):
%
%   GrayImage       : Any 2D image, for good results background subtracted image
%                     would redice the false positives.
%   maxR            : Maximum radius of object to look for.
%   minR            : Minimum radius to look for.
%   S               : Constant that decides the separation between any two
%                     subsequent radius search
%   min_separation  : Minimum distance between any two blob location(In terms of pixel location)
%   thresh          : Threshold to look for potentially well responses
%
% Arguments(outputs): 
%
%  xCor             : x Coordinates of the blobs 
%  yCor             : y Coordinates of the blobs
%  R                : Radius of the blob we get
%  
% Note: for good results keep the radius range up to 20. (maxR-minR) <= 15.
%   tic;[a,b,R] = dogDetect(raw_image,20,30,0.5);toc
%   tic;[a,b,R] = logDetect(raw_image,20,30,0.5);toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

img = colorfrequency(colorImage(:,:,1));

% Difference of Gaussian parameters
radiusRange = minR:2:maxR;
radius_nb    = numel(radiusRange);

% we have already derived the sigma and radius calculations 
load('sigmaTable.mat');
        
% variable
img_height  = size(img,1);
img_width   = size(img,2);
        
% calcul scale-normalized laplacian operator
sndog = zeros(img_height,img_width,radius_nb);
for i=1:radius_nb
    a = find(sigmaTable.radius == radiusRange(i));
    sigma1       = sigmaTable.sigma1(a(1));
    sigma2       = sigmaTable.sigma2(a(1));
    dog1 = fspecial('gaussian', floor(6*sigma2+1), sigma1);
    dog2 = fspecial('gaussian', floor(6*sigma2+1), sigma2);
    filter = dog2-dog1;
    
    sndog(:,:,i) = imfilter(img,filter,'replicate');
    %sndog(:,:,i) = mat2gray(sndog(:,:,i));
end


[sndog_max,sndog_R] = max(sndog,[],3); 

sndog_max = double(sndog_max > (threshold .* max(sndog_max(:)))) .* sndog_max;
disp(max(sndog_max(:))); disp(min(sndog_max(:))); 

sndog_R = sndog_R + (minR-1);

%load('matlab.mat');
%snlo_dil= imdilate(snlo_max,SE);
sndog_maxima = imregionalmax(sndog_max,8);
sndog_blobR = double(sndog_maxima) .* sndog_R;

[xCor,yCor,magnitude] = find(double(sndog_maxima).* sndog_max); % finding the radius

[xCor,yCor,R] = find(sndog_blobR); % finding the radius

% sorting according to the magnitude of the Log response
blobTable = table(xCor,yCor,magnitude,R);
blobTable = sortrows(blobTable,{'magnitude'},{'descend'});

disp(blobTable);

% hows the blobs are looking like
figure,imshow(colorImage,[]);
hold on;
plot(blobTable.yCor,blobTable.xCor,'g+');
viscircles([blobTable.yCor blobTable.xCor],round(R));
hold off;
toc;

end

