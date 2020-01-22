function [Bcon,Bcoff,OPL,OUT]=Retina_no_temporal(originimg,alpha_ph,alpha_h)

    dblImageSX=normrange(originimg,0,1);
    %--------------------------------------------------------------------------
    %--------------------------------------------------------------------------
    hh=10;
    ww=10;
    a1=-0.5:1/hh:0.5-1/hh;
    b1=-0.5:1/ww:0.5-1/ww;
    fk1=repmat(a1',1,ww);   
    fk2=repmat(b1,hh,1);
    beta_ph=0;
%     alpha_ph=7;
    fph=1./(1+beta_ph+4*alpha_ph-2*alpha_ph*(cos(2*pi.*fk1))-2*alpha_ph*(cos(2*pi.*fk2)));
    
    beta_h=0;
%     alpha_h=0.57;
    fh=1./(1+beta_h+4*alpha_h-2*alpha_h*(cos(2*pi.*fk1))-2*alpha_h*(cos(2*pi.*fk2)));
    %--------------------------------------------------------------------------
    %LC
    Lp=conv2(dblImageSX,fh,'same');

    %Local adaptation model associated symbol
    V0=0.7;
    Vmax=1;
    % Lp=20;
    R0=Lp*V0+Vmax*(1-V0);
    % R0=0.1;%0-1
    Cp=(dblImageSX./(dblImageSX+R0)).*(Vmax+R0);

    BPph=conv2(Cp,fph,'same');
    BPph=normrange(BPph,0,1);
    %--------------------------------------------------------------------------
    % Honzonial Cell
    %--------------------------------------------------------------------------
    BPr=conv2(Cp,fh,'same');
    BPr=normrange(BPr,0,1);
    %--------------------------------------------------------------------------
    % Bipolar Cell
    %--------------------------------------------------------------------------
    Lp=BPr;
    V00=0.9;
    Bcon=BPph-BPr;
    Bcon=Bcon./(Bcon+Lp*V00+Vmax*(1-V00)).*(Vmax+Lp*V00+Vmax*(1-V00));

    Bcoff=-BPph+BPr;
    Bcoff=Bcoff./(Bcoff+Lp*V00+Vmax*(1-V00)).*(Vmax+Lp*V00+Vmax*(1-V00));
    %--------------------------------------------------------------------------
    % OPL 
    %--------------------------------------------------------------------------
    OPL=Bcon-Bcoff;
    OUT=OPL+Cp/1;
end