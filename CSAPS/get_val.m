function AdjR = get_val(grayImage,modeledColorChannel)

SSE = sum(sum((grayImage-modeledColorChannel).^2));

SST = sum( sum (   (grayImage-mean(grayImage(:))).^2    ) );


R2 = 1 - (SSE/SST);

MN = size(grayImage,1)*size(grayImage,2);

AdjR = 1- ( (1-R2)*((MN-1)/(MN-2-1)));


end