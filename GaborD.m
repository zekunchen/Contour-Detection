function [G_even,G_odd] = GaborD(n, sigma_y, sigma_x, theta, pr, x0, y0)
    if length(n)>1,
      incx = 2*n/(n(1)-1);
      incy = 2*n/(n(2)-1);
    else
      incx = 2*n/(n-1);
      incy = 2*n/(n-1);
    end
    [X,Y] = meshgrid(-n:incx:n,-n:incy:n);
    xp = (X-x0)*cos(theta)+(Y-y0)*sin(theta);
    yp = -(X-x0)*sin(theta)+(Y-y0)*cos(theta);

    G_even = 1./(2*pi*sigma_x*sigma_y).*exp(-.5*(xp.^2./sigma_x^2+yp.^2./sigma_y^2)).* ...
      cos(2*pi/(4*sigma_x)*pr.*xp);

    G_odd = 1./(2*pi*sigma_x*sigma_y).*exp(-.5*((xp-x0).^2./sigma_x^2+(yp-y0).^2./sigma_y^2)).* ...
      sin(2*pi/(4*sigma_x)*pr.*xp);
end
