function noarmalisedx = NormaliseChannel(x, a, b, mins, maxs)
    if nargin < 2
      a = [];
      b = [];
      mins = [];
      maxs = [];
    end

    [rows, cols, chns] = size(x);

    OriginalMin = min(x(:));
    OriginalMax = max(x(:));

    if isempty(a)
      if OriginalMin >= 0
        a = 0.0;
      else
        a = -1.0;
      end
    end
    if isempty(b)
      if OriginalMax >= 0
        b = 1.0;
      else
        b = 0.0;
      end
    end
    if length(a) == 1
      a(2:chns) = a(1);
    end
    if length(b) == 1
      b(2:chns) = b(1);
    end

    if chns == 1 && cols == 3
      x = reshape(x, rows, cols / 3, 3);
    end

    x = double(x);
    a = double(a);
    b = double(b);

    noarmalisedx = zeros(size(x));

    if isempty(mins)
      mins = min(x(:));
    end
    if isempty(maxs)
      maxs = max(x(:));
    end
    if length(mins) == 1
      mins(2:chns) = mins(1);
    end
    if length(maxs) == 1
      maxs(2:chns) = maxs(1);
    end

    for i = 1:chns
      minv = mins(i);
      maxv = maxs(i);
      if a(i) == b(i)
        noarmalisedx(:, :, i) = a(i);
      else
        noarmalisedx(:, :, i) = a(i) + (x(:, :, i) - minv) * (b(i) - a(i)) / (maxv - minv);
      end
    end

    if chns == 1
      noarmalisedx = reshape(noarmalisedx, rows, cols);
    end

end
