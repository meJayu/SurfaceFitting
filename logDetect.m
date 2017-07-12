function [blobTable] = logDetect(colorImage,minR,maxR,threshold)
% function [xCor,yCor,R] = logDetect(colorImage,minR,maxR,threshold) It
% will use the scale normalized laplacian of gaussian filter to detect the
% blobs in an image.
%
%
% Input: colorImage : Bias corrected color image
%        minR       : minimum radius of the blob to be detected 
%        maxR       : maximum radius to be detected
%        threshold  : threshold of Laplacian of Gaussian response above
%        which LoG responses are considered for blob detection
%
% Output:blobTable contains the following fields
%        xCor       : x-coordinate of the center pixel location of each
%                     blob detected
%        yCor       : y-coordinate of the center pixel location of each
%                     blob detected
%        R          : radius of the corresponding blobs
%
% REFERENCES
% ==========
% Lindeberg, T. Feature Detection with Automatic Scale Selection
% IEEE Transactions Pattern Analysis Machine Intelligence, 1998, 30, 77-116kp_harris(im)
% Example:
%

%%

tic;
%colorImage = imresize(colorImage,0.25);
img = colorfrequency(adapthisteq(colorImage(:,:,1)));

% Laplacian of Gaussian parameters
radiusRange = minR:2.5:maxR;
% Relationship between the blob radius and standard deviation(scale) of laplacian of
% gaussian could be explained as follows
%
% If blob radius is R, it could be detected by the convolution of the Log
% filter having the standard deviation(scale) : (R/sqrt(2)).
sigma_array = radiusRange ./ sqrt(2);
sigma_nb    = numel(sigma_array);
        
% variable
img_height  = size(img,1);
img_width   = size(img,2);
        
% calcul scale-normalized laplacian operator
snlo = zeros(img_height,img_width,sigma_nb);
for i=1:sigma_nb
    sigma       = sigma_array(i);
    snlo(:,:,i) = sigma*sigma*imfilter(img,fspecial('log', floor(6*sigma+1), sigma),'replicate');
    snlo(:,:,i) = mat2gray(snlo(:,:,i));
end

% At every pixel whatever radius is giving maximum response of Log filter it 
% will be get the magitude of that pixel location in snlo_max image
%
% snlo_R will be used to determine the radius of corresponding response 
% value in snlo_max image. 
[snlo_max,snlo_R] = max(snlo,[],3); 
snlo_max = double(snlo_max > (threshold .* max(snlo_max(:)))) .* snlo_max;
disp(max(snlo_max(:))); disp(min(snlo_max(:))); 

snlo_R = snlo_R + (minR-1);

%load('matlab.mat');
%snlo_dil= imdilate(snlo_max,SE);
snlo_maxima = imregionalmax(snlo_max,8);
snlo_blobR = double(snlo_maxima) .* snlo_R;

[xCor,yCor,magnitude] = find(double(snlo_maxima).* snlo_max); % finding the radius

[xCor,yCor,R] = find(snlo_blobR); % finding the radius

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