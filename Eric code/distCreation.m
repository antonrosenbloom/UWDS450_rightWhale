% Creates the whale and splash disribution from am RGB image of the whale
% RGBImage - The RGB Image of the Whale 
% showImage - Switch to see an image of the whale distribution in green and
% the slash in red
% whaleDist - Is the whale distribution in the photo
% sprayDist - Is the spray in the photo
function [whaleDist,sprayDist] = distCreation(RGBImage,index,train,showImage)
  
    % Separate out the hsv parts.
    hsv = rgb2hsv(RGBImage);
    
    h = hsv(:,:,1);
    s = hsv(:,:,2);
    v = hsv(:,:,3);

    whaleDist = (v < (train.vlmean(index) + (train.vlvar(index) * 20))).*(s < 0.3).*(h > 0.66);

    sprayDist = v > 0.8;
    
    if showImage == 1
        w = zeros(size(hsv));
        w(:,:,2) = whaleDist;
        w(:,:,1) = sprayDist;
        image(w);  
    end       
end