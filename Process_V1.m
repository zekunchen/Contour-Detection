function [TT, Tt] =Process_V1(outm)
    [Responset, Orientationst] = max(outm, [], 1);
    Response(:,:,:)=Responset(1,1,:,:,:);
    Orientations(:,:,:)=Orientationst(1,1,:,:,:);
    [TT, Tt] = ChannelMax(Response, Orientations);
end
