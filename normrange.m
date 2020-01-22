function dblImageSX=normrange(grayImage,desiredMin,desiredMax)
%     desiredMin = 0;
%     desiredMax = 255;
    originalMinValue = double(min(min(grayImage)));
    originalMaxValue = double(max(max(grayImage)));
    originalRange = originalMaxValue - originalMinValue;

    desiredRange = desiredMax - desiredMin;
    dblImageSX = desiredRange * (double(grayImage) - originalMinValue) / originalRange + desiredMin;       
end