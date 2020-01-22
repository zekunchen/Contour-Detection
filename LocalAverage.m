function ch = LocalAverage(Radius)
    x = Radius * 2;
    if mod(x, 2) == 0
      x = x + 1;
    end
    [h, w] = meshgrid(1:x);
    centre = ceil(x / 2);
    ch = sqrt((h - centre) .^ 2 + (w - centre) .^ 2) <= Radius;
    ch = ch ./ sum(ch(:));
end
