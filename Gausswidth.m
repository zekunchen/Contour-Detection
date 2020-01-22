function FilterWidth = Gausswidth(sigma, MaxWidth)
    if nargin < 2
      MaxWidth = 100;
    end
    threshold = 1e-4;
    n = 1:MaxWidth;
    FilterWidth = find(exp(-(n .^ 2) / (2 * sigma .^ 2)) > threshold, 1, 'last');
    if isempty(FilterWidth)
      FilterWidth = 1;
    end
    FilterWidth = FilterWidth .* 2 + 1;
end
