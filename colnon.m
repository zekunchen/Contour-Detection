function resp=colnon(EdgeImageResponse,FinalOrientations,dir,flag)
    EdgeImageResponse = EdgeImageResponse ./ max(EdgeImageResponse(:));
    if flag==1
        FinalOrientations = (FinalOrientations - 1) * pi / dir;%%
        FinalOrientations = mod(FinalOrientations + pi / 2, pi);%%
    end
    EdgeImageResponse = NonMaxChannel(EdgeImageResponse, FinalOrientations);
    EdgeImageResponse([1, end], :) = 0;
    EdgeImageResponse(:, [1, end]) = 0;
    resp = EdgeImageResponse ./ max(EdgeImageResponse(:));
end