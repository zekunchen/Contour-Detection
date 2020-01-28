function [omaxs,dir]=V1_to_V4(img_input,nvalue)
    ndir = 12; 
    fac = [1 1 1 1];
    sigma_y = [1 2 3 4];% 
    WR = 8;%
    AR = [.7*WR 1.4*WR 2.15*WR 3*WR];
%     AR = [2*WR 2*WR 2*WR 2*WR];
    
    for i=1:length(sigma_y) 
      f(i) = struct('sigma_y', sigma_y(i), 'size', 4*sigma_y(i)+1, ...
        'sigma_x1', sigma_y(i)/AR(i), 'sigma_x2', WR*sigma_y(i)/AR(i), ...
        'pr', 1.5, 'x0', 0, 'y0', 0);
    end

    m = [9.4959; 8.7135; 6.8242; 28.734];
    mc = [123.1804; 82.6394; 58.4508; 45.2915];

    rgb = img_input;
    mysize=size(rgb);
    if numel(mysize)>2   
      img=rgb2gray(rgb); 
    else
    img=rgb;             
    end
    [hh,ww]=size(img);

    %% V1
    t='Gabor';
%     t='DOG';
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

    %th:  0° 15° 30° 
    %     45° 60° 75° 
    %     90° 105° 120° 
    %    135° 150° 165°
    for th=0:coeff:pi-coeff %θ：Theta
      if(th<=pi/2)
        theta = abs(th-pi/2);
      else
        theta = 3*pi/2-th;
      end

      for j=1:length(f) 
        if strcmp(t,'Gabor') 
          [fe fo] = GaborD(f(j).size,f(j).sigma_y,f(j).sigma_x1,theta,f(j).pr,f(j).x0,f(j).y0);
        else
          [fe fo] = DOG(f(j).size,f(j).sigma_y,f(j).sigma_x1,f(j).sigma_x2,theta,f(j).x0,f(j).y0);
        end

        V1.simple_e(i,j,:,:) = conv2(double(img),fe,'same');        
        V1.simple_o(i,j,:,:) = conv2(double(img),fo,'same');
%     V1.simple_e(i,j,:,:) =abs(imfilter(double(img),fe, 'symmetric'));%symmetric
%     V1.simple_o(i,j,:,:) =abs(imfilter(double(img),fo,'symmetric'));    
        

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

    %% V2
    cs=fac;
    s=[f(:).size];
    V2 = struct('max', zeros(size(V1.simple_e,3), size(V1.simple_e,4)), ...
        'endsc', zeros(size(V1.simple_e)), ...
        'corner', zeros(size(V1.simple_e,2),size(V1.simple_e,3),size(V1.simple_e,4)), ...
        'signp', zeros(size(V1.simple_e)), ...
        'signn', zeros(size(V1.simple_e)));

    V1.simple_e(V1.simple_e<=0) = 0.001;
    V1.complex_e(V1.complex_e<=0) = 0.001;
    ndir = size(V1.simple_e,1);

    for i=1:ndir 
      th = (i-1)*pi/ndir;

      % ---------------- endstopped ------------
      for j=size(V1.simple_e,2):-1:1
        auxe =  V1.complex_e(i,j,:,:);
        auxs1 = V1.complex_e(i,j,:,:); 
        auxs2 = V1.complex_e(i,j,:,:);

        temp1=mod(i-1+floor(ndir/4),ndir)+1;

        temp2=mod(i-1+floor(3*ndir/4),ndir)+1;
        auxs1 = auxs1+V1.complex_e(temp1,j,:,:);
        auxs2 = auxs2+V1.complex_e(temp2,j,:,:);

        a = int16(round(s(j)/2*sin(th))); 
        b = int16(round(s(j)/2*cos(th))); 
        as = a;
        bs = b;
        if j==4
          as = int16(round(s(j)/5*sin(th)));
          bs = int16(round(s(j)/5*cos(th)));
        end
        if j==3
          as = int16(1*round(s(j)/4*sin(th)));
          bs = int16(1*round(s(j)/4*cos(th)));
        end
        if j==2
          as = int16(1*round(s(j)/4*sin(th)));
          bs = int16(1*round(s(j)/4*cos(th)));
        end
        if j==1
          as = int16(2*round(s(j)/5*sin(th)));
          bs = int16(2*round(s(j)/5*cos(th)));
        end

        if(b<=0)
          b = abs(b); bs = abs(bs);
          V2.endsc(i,j,a+1:size(auxe,3)-a,b+1:size(auxe,4)-b)     = cs(j)*V1.simple_e(i,j,a+1:size(auxe,3)-a,b+1:size(auxe,4)-b)     - auxe(1,1,1:size(auxe,3)-2*a,1:size(auxe,4)-2*b)    - auxe(1,1,2*a+1:size(auxe,3),2*b+1:size(auxe,4));
          V2.signp(i,j,as+1:size(auxe,3)-as,bs+1:size(auxe,4)-bs) = cs(j)*V1.simple_e(i,j,as+1:size(auxe,3)-as,bs+1:size(auxe,4)-bs) - auxs2(1,1,1:size(auxe,3)-2*as,1:size(auxe,4)-2*bs) - auxs1(1,1,2*as+1:size(auxe,3),2*bs+1:size(auxe,4));      
          V2.signn(i,j,as+1:size(auxe,3)-as,bs+1:size(auxe,4)-bs) = cs(j)*V1.simple_e(i,j,as+1:size(auxe,3)-as,bs+1:size(auxe,4)-bs) - auxs1(1,1,1:size(auxe,3)-2*as,1:size(auxe,4)-2*bs) - auxs2(1,1,2*as+1:size(auxe,3),2*bs+1:size(auxe,4));      
        else
          V2.endsc(i,j,a+1:size(auxe,3)-a,b+1:size(auxe,4)-b)     = cs(j)*V1.simple_e(i,j,a+1:size(auxe,3)-a,b+1:size(auxe,4)-b)     - auxe(1,1,1:size(auxe,3)-2*a,2*b+1:size(auxe,4))    - auxe(1,1,2*a+1:size(auxe,3),1:size(auxe,4)-2*b);      
          V2.signp(i,j,as+1:size(auxe,3)-as,bs+1:size(auxe,4)-bs) = cs(j)*V1.simple_e(i,j,as+1:size(auxe,3)-as,bs+1:size(auxe,4)-bs) - auxs1(1,1,1:size(auxe,3)-2*as,2*bs+1:size(auxe,4)) - auxs2(1,1,2*as+1:size(auxe,3),1:size(auxe,4)-2*bs);
          V2.signn(i,j,as+1:size(auxe,3)-as,bs+1:size(auxe,4)-bs) = cs(j)*V1.simple_e(i,j,as+1:size(auxe,3)-as,bs+1:size(auxe,4)-bs) - auxs2(1,1,1:size(auxe,3)-2*as,2*bs+1:size(auxe,4)) - auxs1(1,1,2*as+1:size(auxe,3),1:size(auxe,4)-2*bs);
        end  
      end
    end

        V2.corner = sum(V1.simple_e,[]);
    %% V4
        laV1 = V1;
        laV2 = V2;

        ndir = size(laV2.endsc,1);
        ncurv = size(laV2.endsc,2)*2;
        n1 = size(laV2.endsc,3); 
        n2 = size(laV2.endsc,4); 
        rad = 0:10:(max(n1,n2)-100)/2*sqrt(2);
        or = -pi/45:pi/45:2*pi+pi/45;

        V4 = struct('act', zeros(ncurv,length(rad),length(or)), ...
            'curv', zeros(length(rad),length(or)), ...
            'resp', 0);

        x = repmat(1:n2,[length(1:n1) 1]);
        y = repmat(1:n1,[length(1:n2) 1]);
        y = y';
        %----------------------------------------------------------------------
        for j=1:length(m)
          laV2.endsc(:,j,:,:) = Rectify(laV2.endsc(:,j,:,:),0.01,m(j)/8.5);
          laV2.corner(:,j,:,:) = Rectify(laV2.corner(:,j,:,:),0.01,mc(j)/8.5);
          laV1.simple_e(:,j,:,:) = Rectify(laV1.simple_e(:,j,:,:),0.01,max(max(max(laV1.simple_e(:,j,:,:))))/8.5);
        end
        %---------------------------------------------------------------------------------------------------------
        sp = laV2.signp>laV2.signn; 
        sn = laV2.signn>laV2.signp;

        c_class = zeros(ndir,ncurv,n1,n2);
        corner = repmat(laV2.corner(1,:,:,:),[12 1]);

        c_class(:,1,:,:) = laV2.endsc(:,1,:,:);

        aux = zeros(size(laV2.endsc)); 
        aux(sp) = laV2.endsc(sp);
        c_class(:,2:4,:,:) = aux(:,2:4,:,:);
        aux = zeros(size(laV2.endsc)); 
        aux(sn) = laV2.endsc(sn);
        c_class(:,8:-1:6,:,:) = aux(:,2:4,:,:);
        r = all(laV2.endsc<0.25,2) & all(laV1.simple_e>corner,2);
        c_class(:,5,:,:) = max(laV1.simple_e,[],2).*r;
        prob = reshape(max(c_class,[],1),[ncurv n1 n2]);
        [maxs,inds] = max(prob,[],1);
        inds(maxs<nvalue) = 0;

        oinds=reshape(inds(1,:,:),hh,ww);
        omaxs=reshape(maxs(1,:,:),hh,ww);
        n0 = size(c_class,1); %400
        n1 = size(c_class,3); %400
        n2 = size(c_class,4); %400
         
        tdir= reshape(max(c_class,[],2),[n0 n1 n2]);
        [omaxs(:,:),dir(:,:)]= max(tdir,[],1); 
            
end
    
    
    
