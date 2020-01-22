function SMat = CentreZero(SMat, CRadius)
    [h, w] = size(SMat);
    if CRadius == 0 || CRadius > min(h, w)
      return;
    end
    x = max(h, w);
    if mod(x, 2) == 0
      x = x + 1;
    end
    [hh, ww] = meshgrid(1:x);
    centre = ceil(x / 2);
    ch = sqrt((hh - centre) .^ 2 + (ww - centre) .^ 2) <= CRadius;
    SMat(ch) = 0;
end
