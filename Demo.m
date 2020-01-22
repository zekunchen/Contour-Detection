% 
close all;
clear all;
tic
rgb = imread('image/100099.jpg');%
InputImage=imresize(rgb,1);
if max(InputImage(:)) > 1
  InputImage = double(InputImage);
  InputImage = InputImage ./ max(InputImage(:));
end
LgnSigma=1.1;
OpponentImage = SingleOpponent(InputImage,LgnSigma);
[h,w,s]=size(OpponentImage);

type='DOG';
sigma_y = [6];
WR = 8;
AR = [1*WR];

for i=1:s
    originimg=reshape(OpponentImage(:,:,i),[h,w]);
    maxs= Boundarynon(originimg,sigma_y,WR,AR,type);%
    maxs = maxs ./ max(maxs(:));
    outm(:,:,:,:,i)=maxs(:,:,:,:);
end

%%
% [TT, Tt] =Process_V1(outm);
% figure; imshow(TT, []);
% resp=colnon(TT,Tt,12,1)
% figure; imshow(resp);

[R_NCRF, Ori] =Process_V1SS(outm,12);
figure; imshow(R_NCRF, []);
resp1=colnon( R_NCRF,Ori,12,1);
figure; imshow(resp1);

%%
[R_kmax,dir]=V1_to_V4(R_NCRF,0.01);
R_kmax(R_NCRF==0)=0;
figure;imshow(R_kmax,[]);
R_kmax = R_kmax ./ max(R_kmax(:));
R_kmax=normrange(R_kmax,0,1);
respo=colnon(R_kmax,Ori,12,1);
figure; imshow(respo);

%%
V4R=1-R_kmax;
R_curve=R_kmax+R_NCRF.*(V4R+0.5);%R_curve
figure;imshow(R_curve,[]);

R_sparse = R_NCRF.*Sparse(R_NCRF,10);%R_sparse  
figure;imshow(R_sparse,[]);

R_contour = 1*R_sparse+1*R_curve;%R_contour   
figure;imshow(R_contour);

resp3=colnon(R_contour,Ori,12,1);
figure;imshow(resp3,[]);

toc

