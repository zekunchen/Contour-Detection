function SOImage = SingleOpponent(InputImage,LgnSigma)
    InputImage = imfilter(InputImage, gaus2D(LgnSigma),'conv','replicate');
    InputImage=sqrt(InputImage);
    if size(InputImage, 3) == 3
        [Bcon,Bcoff,OPL,OUT]=Retina_no_temporal(mean(InputImage(:, :, 1:3), 3),7,0.57);
        R = InputImage(:,:,1);   % Cone-L
        G = InputImage(:,:,2);   % Cone-M
        B = InputImage(:,:,3);   % Cone-S
        Y = (R+G)/2;
        SOImage(:, :, 1) = R - G;%RG 
        SOImage(:, :, 2) = B - Y;%BY
        SOImage(:, :, 3) = (mean(InputImage(:, :, 1:3), 3));%LU
        SOImage(:, :, 4) = OUT; 
        SOImage(:, :, 5) = B - 0.7 * Y;%BY
        SOImage(:, :, 6) = sqrt(LocalStd(rgb2gray(InputImage), 1));
    else %input gray
        [Bcon,Bcoff,OPL,OUT]=Retina_no_temporal(InputImage,7,0.57);
        SOImage(:, :, 1) = InputImage;
        SOImage(:, :, 2) = sqrt(LocalStd(InputImage));
        SOImage(:, :, 3) = OUT;
    end
end