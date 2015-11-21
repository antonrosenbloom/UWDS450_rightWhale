% This function centers and rotates to hrozontal a line through a point on
% an image.
% original - The oiginal image
% slope - the slope of the line
% center - the point to center the rotation
% showImage - switch to show the original image
% rotated - the rotated image
function rotated = rotateImage(original, slope, center, showImage)
    
ksize = size(original);
delta = zeros(2);
delta(1) = center(1) - ksize(1)/2;
delta(2) = center(2) - ksize(2)/2;

H = (slope^2 + 1)^(1/2);
cosw = -slope/H;
sinw = 1/H;

rotated = imtranslate(original,[delta(2)*(-1),delta(1)*(-1)]);
tform = affine2d([cosw sinw 0;-sinw cosw 0; 0 0 1]);

rotated = imwarp(rotated,tform);

if showImage == 1
    image(rotated);
end

end