function [dog doog] = DOG(size,sigma_y,sigma_x1,sigma_x2,theta,x0,y0)
    [X Y]=meshgrid(-fix(size/2):fix(size/2),fix(-size/2):fix(size/2));
    % Rotation 
    x_theta=(X-x0)*cos(theta)+(Y-y0)*sin(theta);
    y_theta=-(X-x0)*sin(theta)+(Y-y0)*cos(theta);

    dog1 = 1/(2*pi*sigma_x1*sigma_y).*exp(-.5*(x_theta.^2/sigma_x1^2+y_theta.^2/sigma_y^2));
    dog2 = 1/(2*pi*sigma_x2*sigma_y).*exp(-.5*(x_theta.^2/sigma_x2^2+y_theta.^2/sigma_y^2));

    dog = dog1-dog2;

    x1 = X .* cos( theta ) + Y .* sin( theta );
    y1 = -X .* sin( theta ) + Y .* cos( theta );

    doog=-x1.*exp(-((x1.^2)*sigma_x2+(y1.^2)*sigma_x1)/(2*(sigma_y^2)))/(pi*(sigma_y^2));
end
