function outm= Boundarynon(img,sigma_y,WR,AR,type)
    ndir = 12; 
    for i=1:length(sigma_y) 
      f(i) = struct('sigma_y', sigma_y(i), 'size', 4*sigma_y(i)+1, ...
        'sigma_x1', sigma_y(i)/AR(i), 'sigma_x2', WR*sigma_y(i)/AR(i), ...
        'pr', 1.5, 'x0', 0, 'y0', 0);
    end

    %% V1²ã²Ù×÷
    % 'DOG'or 'Gabor';
    t=type;
    coeff = pi/ndir;
    V1 = struct('max', zeros(size(img,1), size(img,2)), ...
        'angles', zeros(size(img,1), size(img,2)), ...
        'simple_e', zeros(ndir, length(f), size(img,1), size(img,2)), ...
        'simple_o', zeros(ndir, length(f), size(img,1), size(img,2)), ...
        'complex_e', zeros(ndir, length(f), size(img,1), size(img,2)), ...
        'complex_o', zeros(ndir, length(f), size(img,1), size(img,2)));

    i = 1;
    p = -2:2;
    w = 1./(sqrt(2*pi)).*exp(-(p).^2./2)*2.5;
    %th:  0¡ã 15¡ã 30¡ã 
    %     45¡ã 60¡ã 75¡ã 
    %     90¡ã 105¡ã 120¡ã 
    %    135¡ã 150¡ã 165¡ã
    for ii = 1:ndir
      thetas(ii) = (ii - 1) * pi / ndir;
    end

    for th=0:coeff:pi-coeff %¦È£ºTheta

      theta=thetas(i);
      for j=1:length(f) 
        if strcmp(t,'Gabor') 
    %       [fe fo] = GaborD(f(j).size,f(j).sigma_y,f(j).sigma_x1,theta,f(j).pr,f(j).x0,f(j).y0);
          [fo fe] = GaborD(f(j).size,f(j).sigma_y,f(j).sigma_x1,theta,f(j).pr,f(j).x0,f(j).y0);
        else
    %       [fe fo] = DOG(f(j).size,f(j).sigma_y,f(j).sigma_x1,f(j).sigma_x2,theta,f(j).x0,f(j).y0);
          [fo fe] = DOG(f(j).size,f(j).sigma_y,f(j).sigma_x1,f(j).sigma_x2,theta,f(j).x0,f(j).y0);
          [fe0 fo0] = GaborD(5,1,1,theta,0,0,0);

        end

    %     V1.simple_e(i,j,:,:) = abs(conv2(double(img),fe,'same'));        
    %     V1.simple_o(i,j,:,:) = conv2(double(img),fo,'same');
        simple =abs(imfilter(double(img),fe, 'symmetric'));
        V1.simple_e(i,j,:,:) =abs(imfilter(simple,fe0, 'symmetric')); 

        se = 2*(f(j).sigma_y/f(j).sigma_x1);
        a = int16((f(j).x0+floor(f(j).size/se))*sin(mod(th+pi/2,pi)));
        b = int16((f(j).y0+floor(f(j).size/se))*cos(mod(th+pi/2,pi)));

        auxe = V1.simple_e(i,j,:,:); 
        auxo = V1.simple_o(i,j,:,:);

        auxe(auxe<0) = 0; 
        auxo(auxo<0) = 0; 

        if(b<0)
          b = abs(b);
          V1.complex_e(i,j,:,:) = auxe(1,1,:,:)*w(3);
          V1.complex_e(i,j,1:size(auxe,3)-a,1:size(auxe,4)-b)         = V1.complex_e(i,j,1:size(auxe,3)-a,1:size(auxe,4)-b)         + auxe(1,1,a+1:size(auxe,3),b+1:size(auxe,4))        * w(2);      
          V1.complex_e(i,j,1:size(auxe,3)-2*a,1:size(auxe,4)-2*b)     = V1.complex_e(i,j,1:size(auxe,3)-2*a,1:size(auxe,4)-2*b)     + auxe(1,1,2*a+1:size(auxe,3),2*b+1:size(auxe,4))    * w(1);       
          V1.complex_e(i,j,a+1:size(auxe,3),b+1:size(auxe,4))         = V1.complex_e(i,j,a+1:size(auxe,3),b+1:size(auxe,4))         + auxe(1,1,1:size(auxe,3)-a,1:size(auxe,4)-b)        * w(4);      
          V1.complex_e(i,j,2*a+1:size(auxe,3),2*b+1:size(auxe,4))     = V1.complex_e(i,j,2*a+1:size(auxe,3),2*b+1:size(auxe,4))     + auxe(1,1,1:size(auxe,3)-2*a,1:size(auxe,4)-2*b)    * w(5);
        else

          V1.complex_e(i,j,:,:) = auxe(1,1,:,:)*w(3);     
          V1.complex_e(i,j,1:size(auxe,3)-a,4*b+1:size(auxe,4))       = V1.complex_e(i,j,1:size(auxe,3)-a,4*b+1:size(auxe,4))       + auxe(1,1,a+1:size(auxe,3),3*b+1:size(auxe,4)-b)    * w(2);
          V1.complex_e(i,j,1:size(auxe,3)-2*a,4*b+1:size(auxe,4))     = V1.complex_e(i,j,1:size(auxe,3)-2*a,4*b+1:size(auxe,4))     + auxe(1,1,2*a+1:size(auxe,3),2*b+1:size(auxe,4)-2*b)* w(1); 
          V1.complex_e(i,j,a+1:size(auxe,3),3*b+1:size(auxe,4)-b)     = V1.complex_e(i,j,a+1:size(auxe,3),3*b+1:size(auxe,4)-b)     + auxe(1,1,1:size(auxe,3)-a,4*b+1:size(auxe,4))      * w(4);
          V1.complex_e(i,j,2*a+1:size(auxe,3),2*b+1:size(auxe,4)-2*b) = V1.complex_e(i,j,2*a+1:size(auxe,3),2*b+1:size(auxe,4)-2*b) + auxe(1,1,1:size(auxe,3)-2*a,4*b+1:size(auxe,4))    * w(5);      
        end  
      end
      i = i+1;  
    end
    %     outm=V1.complex_e;
         outm=V1.simple_e;
    %     outm=V1.simple_e.*V1.complex_e;
end