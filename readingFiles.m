clear;clc;close all
%this script will correct the illuminaion of every image given in
% specified folder
% Changing the input folder : CHANGE 'C:\Users\Jay\Google...
% Drive\Clearwater\TestImages\'  for struct srcFiles and filename

% Changing the output folder : CHANGE 'C:\Users\Jay\Google...
% Drive\Clearwater\Corrected\' while writing the image

% a is the illuminatygion corrected image
% b is the bias profiles in 3 channel format
% c is the adjusted R square values for all three channels

srcFiles = dir('/home/jpatel/Clearwater/Georges/Original/*.jpg');  % the folder in which ur images exists
for i = 500 : length(srcFiles)
    filename = strcat('/home/jpatel/Clearwater/Georges/Original/',srcFiles(i).name);
    I = imread(filename);
    % compute 3 images
    [a,b,c] = trueImage(I,8);
        
    ConvertPNG = srcFiles(i).name; ConvertPNG(23:25) = 'png';
    imwrite(1.5*a,['/home/jpatel/Research/CorrectDataset/GeorgeCorrect/',ConvertPNG]);
        
    %imwrite(img2,['C:\Users\Jay\Google Drive\Clearwater\profile\',srcFiles(i).name]);
    %figure,imshow(a,[]);
        
    clear a;clear b;clear c;
    
end

