function Spar=Sparse(map,Ws)
    [r,c] = size(map);
    Tmap1 = [map;zeros((Ws-mod(r,Ws)),c)];
    Tmap = [Tmap1 zeros(size(Tmap1,1),(Ws-mod(c,Ws)))];
    [rr,cc] = size(Tmap);

    ki = 1; 
    for i = 1:Ws:rr-Ws-1 
        kj=1;
        for j = 1:Ws:cc-Ws-1
            tR = Tmap(i:i+Ws-1,j:j+Ws-1);
            TemRe(ki,kj) = mean2(tR); 
            kj = kj+1;
        end
        ki = ki+1;
    end

    Mi = Ws; Mj = Ws;
    Emap = padarray(TemRe,[floor(Mi/2) floor(Mj/2) 0],'replicate','both');
    Num = Mi * Mj ;
    [Ex,Ey] = size(Emap);

    Tspar = zeros(Ex,Ey);

    for i = floor(Mi/2)+1 : Ex-ceil(Mi/2)
        for j = floor(Mj/2)+1 : Ey-ceil(Mj/2)

           tres = Emap(i-floor(Mi/2):i+floor(Mi/2),j-floor(Mj/2):j+ floor(Mj/2));
           Hr = tres(:);       
           cof = min(1,Emap(i,j)/mean(Hr));
           Tspar(i,j) = cof*(sqrt(Num)-sum(Hr)/sqrt(sum(Hr.^2)))/(sqrt(Num)-1);

        end
    end

    Spar1 = Tspar(floor(Mi/2)+1:Ex-floor(Mi/2),floor(Mj/2)+1:Ey-floor(Mj/2));
    Spar2 = imresize(Spar1,[rr cc],'bilinear'); 
    Spar = Spar2(1:r,1:c);
end
    
