function [normImage] = colorfrequency(originalImage)
%read the image 
fontSize = 20;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Determine it's size and turn it into color if it's not already color.
[rows,columns,numberOfColorBands] = size(originalImage);
if numberOfColorBands < 3
	% It's not a color image - it's a monochrome image.  Turn it into a color image.
	uiwait(msgbox('Note: this is a monochrome image, not a color image.'));
	originalImage = cat(3, originalImage, originalImage, originalImage);
end

tic;
% Construct the 3D gamut.
%lutSize = 256;  % Use 256 to get maximum resolution possible out of a 24 bit RGB image.
lutSize = 32;  % Use a smaller LUT size to get colors grouped into fewer, larger groups in the gamut.
reductionFactor = double(256) / double(lutSize);
gamut3D = zeros(lutSize, lutSize, lutSize);
for row = 1 : rows
	for col = 1: columns
		redValue = floor(double(originalImage(row, col, 1)) / reductionFactor) + 1;	% Convert from 0-255 to 1-256
		greenValue = floor(double(originalImage(row, col, 2)) / reductionFactor) + 1;	% Convert from 0-255 to 1-256
		blueValue = floor(double(originalImage(row, col, 3)) / reductionFactor) + 1;	% Convert from 0-255 to 1-256
		gamut3D(redValue, greenValue, blueValue) = gamut3D(redValue, greenValue, blueValue) + 1;
	end
end
toc;
%%
% Displaying the each layer of the 3D histogram
%figure;
%for ii = 1:64
 %   subplot(8,8,ii);
 %   x = gamut3D(:,:,ii);
 %   y = max(x(:));
 %   p =uint8(255*( x ./ y));
 %  imshow(p,[]);
 
%end
%%
%tic;
% 3D scatter Plot of the gamut

%r = zeros(lutSize, 1);
%g = zeros(lutSize, 1);
%b = zeros(lutSize, 1);
%nonZeroPixel = 1;
%for red = 1 : lutSize
%	for green = 1: lutSize
%		for blue = 1: lutSize
%			if (gamut3D(red, green, blue) > 1)
%				% Record the RGB position of the color.
%				r(nonZeroPixel) = red;
%				b(nonZeroPixel) = blue;
%				nonZeroPixel = nonZeroPixel + 1;
%            end
%	     end
%	end
%end
%figure;
%scatter3(r, g, b, 3,'o','fill','r');colormap('hot');
%xlabel('R', 'FontSize', fontSize);
%ylabel('G', 'FontSize', fontSize);
%zlabel('B', 'FontSize', fontSize);
%toc;

%%
%filtGamut = floor(imgaussfilt3(gamut3D,5)); % added
% Now construct the color frequency image.
% Make an image where we get the color of the original image, and have the output value of the color
% frequency image be the number of times that exact color occurred in the original image.
tic;
colorFrequencyImage = zeros(rows, columns);
for row = 1 : rows
	for col = 1: columns
		redValue = floor(double(originalImage(row, col, 1)) / reductionFactor) + 1;	% Convert from 0-255 to 1-256
		greenValue = floor(double(originalImage(row, col, 2)) / reductionFactor) + 1;	% Convert from 0-255 to 1-256
		blueValue = floor(double(originalImage(row, col, 3)) / reductionFactor) + 1;	% Convert from 0-255 to 1-256
		freq = gamut3D(redValue, greenValue, blueValue);
		colorFrequencyImage(row, col) =  freq;
	end
end
toc;
numberOfColors = double(rows) * double(columns);
disp(numberOfColors);
numberOfColors = sum(sum(sum(gamut3D)));
disp(numberOfColors);
sumr = sum(sum(colorFrequencyImage));
disp(sumr);
%figure;
%imshow(colorFrequencyImage,[]);
normImage = mat2gray(colorFrequencyImage);
%figure,imshow(normImage,[]);
%title('Color Frequency Image', 'FontSize', fontSize);
return;
%next three steps will display the certain range of an image
% all the other range pixels will set to 255
IndexesInRange = normImage(:) >= 0 & normImage(:) <= 100;
extractedValues = normImage(IndexesInRange);
normImage(~IndexesInRange) = 255;

%imwrite(normImage,'ColorFrequencyBack_1051.jpg');
%figure,imshow(normImage,[]);
%imwrite(normImage, 'ContrastFrequency_1051.tif');
%[lowThreshold highThreshold lastThresholdedBand] = threshold(1, 100, colorFrequencyImage);
end