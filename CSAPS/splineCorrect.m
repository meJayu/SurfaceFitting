function [uniformImage,profile,adjustedR2] = splineCorrect(raw_image,factor)
%
% [outImage,profile,er] = trueImage(raw_image,order) Performs the
% illumination correction and calculates the true intensity distributions
% 
% Arguments(input):
%       raw_image : original image with the non-uniform illumination
%
% Argements(output):
%       uniformImage : output image having uniform illumination
%       
%%
if nargin<1
   error('Not enough input arguments');
end

raw_image = im2double(raw_image);

for ii = 1
   
    I = raw_image(:,:,ii); % for the channelwise operations
    
    grayImage = log(I); % to process in log domain
    %% preparing the input for prediction step
    colorChannel = imresize(grayImage,1/6,'bicubic'); % estimation is done on 1/4th sized image
    rows = size(colorChannel, 1);
	columns = size(colorChannel, 2);
    x = {1:rows,1:columns};
    z = colorChannel;

	%% estimation step
    if factor
        [smooth,p] = csaps(x,z,factor,x);
    else
        [smooth,p] = csaps(x,z,[],x);
    end
    
    adjustedR2 = get_val(colorChannel,smooth);
    
    modeledColorChannel = imresize(smooth,6,'bicubic');
    
    % for the quantitative analysis purposes we have shown different plots
    analysePlots(grayImage,modeledColorChannel);   
    
    %% In case we come back to the image domain before performing subtraction
    %taking the exponential to come back to the double domain
    
    %grayImage = exp(grayImage)-1;
    %modeledBackgroundImage = exp(modeledColorChannel)-1;
    
    % In this case we need to add +1 while converting the image to log domain to avoid
    % infinite values
    
    %MATLAB implementation through division
    
    %maxValue = max(max(modeledBackgroundImage));
    
    % Comments by the Image Analyst
	% Divide by the max of the modeled image so that you can get a "percentage" image 
	% that you can later divide by to get the color corrected image.
	% Note: each color channel may have a different max value,
	% but you do not want to divide by the max of all three color channel
	% because if you do that you'll also be making all color channels have the same
	% range, in effect "whitening" the image in addition to correcting for non-uniform 
	% background intensity.  This is not what you want to do.
	% You want to correct for background non-uniformity WITHOUT changing the color.  
	% That can be done as a separate step if desired.
    % Although this will retain the colors, since our lighting conditions
    % on the ocean floors are different, it will cause the inconsistent hue
    % in the correlated images in the dataset.
	
    %modeledBackgroundImage = modeledBackgroundImage / maxValue; % This is a percentage image.

    % Correction step in this case.
    
    %correctedImage = (grayImage ./ modeledBackgroundImage);
   
    %% correction
    
	%since it is logarithmic image domain, image subtraction. 
    correctedImage = (grayImage - modeledColorChannel);
    
    %mean_factor = mean(correctedImage(:)) / mean(grayImage(:));
    % output
    % while performing the division approach remove the exp from the step
    % below
    uniformImage(:,:,ii) = exp(correctedImage);%./mean_factor; % contrast enhencement could be perform here 
    profile(:,:,ii) = modeledColorChannel;
end
% normalization at the end to get the range [0,255]
%profile = uint8(mat2gray(profile)*255);
%uniformImage = uint8(mat2gray(uniformImage)*255)*1.5;
end

