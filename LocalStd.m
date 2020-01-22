function ImageStd = LocalStd(InputImage, SRadius, CRadius)
    InputImage = double(InputImage);

    if nargin < 2
      SRadius = 2.5;
    end
    if nargin < 3
      CRadius = 0;
    end
    Temf = LocalAverage(SRadius);
    Temf = CentreZero(Temf, CRadius);
    Temf = Temf ./ sum(Temf(:));
    MeanCentre = imfilter(InputImage, Temf, 'symmetric');
    stdv = (InputImage - MeanCentre) .^ 2;
    ImageStd = sqrt(imfilter(stdv, Temf, 'symmetric'));
end
