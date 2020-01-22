function [TT, Tt] =Process_V1SS(outm,nThetas)

    sigmax = 3.645;
    sigmay = sigmax / 8;
    Surroundsize = 3;
    
    [Rest, Ort] = max(outm, [], 1);
    Rests(:,:,:)=Rest(1,1,:,:,:);
    Orts(:,:,:)=Ort(1,1,:,:,:);
    
    for c = 1:size(Rests, 3)
      P_Channel = Rests(:, :, c);
      P_Orientation = Orts(:, :, c);

      ss = LocalStd(P_Channel, 45 / 2);
      ss = ss ./ max(ss(:));
      ss = max(ss(:)) - ss;
      ss = NormaliseChannel(ss, 0.7, 1.0, [], []);

      for t = 1:nThetas
        theta = (t - 1) * pi / nThetas;
        theta = theta + (pi / 2);

        responsec = imfilter(Rests(:, :, c), GaussianFilter2(sigmax, sigmay, 0, 0, theta), 'symmetric');
        responses = imfilter(Rests(:, :, c), GaussianFilter2(sigmax * Surroundsize, sigmay * Surroundsize, 0, 0, theta), 'symmetric');

        response = max(responsec - ss .* responses, 0);
        P_Channel(P_Orientation == t) = response(P_Orientation == t);
      end
      Rests(:, :, c) = P_Channel;
    end
    
    [TT, Tt] = ChannelMax(Rests, Orts); 
end