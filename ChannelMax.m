function [Resout, Orout] = ChannelMax(Resinput, Orinput)

    [h, w, ~] = size(Resinput);
    Orout = zeros(h, w);
    SumResponse = sum(Resinput, 3);
    [~, MaxInds] = max(Resinput, [], 3);
    Resout = SumResponse;

    if ~isempty(Orinput)
      for c = 1:max(MaxInds(:))
        corien = Orinput(:, :, c);
        Orout(MaxInds == c) = corien(MaxInds == c);
      end
    end
end