function d = NonMaxChannel(d, t)
    for i = 1:size(d, 3)
      d(:, :, i) = d(:, :, i) ./ max(max(d(:, :, i)));
      d(:, :, i) = nonmax(d(:, :, i), t(:, :, i));
      d(:, :, i) = max(0, min(1, d(:, :, i)));
    end
end