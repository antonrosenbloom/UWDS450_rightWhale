% This funtion cropsc down an image given a disribution and returns it to
% a resolution of 1024x1536
% original - the original image 
% distribution - the distibution to crop to 
% showImagev - to show the cropped image
function cropped = croppingDown(original,distribution,showImage)
ksize = size(distribution);

rinc = uint32(ksize(1)/16);
cinc = uint32(ksize(2)/16);

for i=1:16
    for j=1:16
        if i==16
            if j==16
                block = distribution((1 + (i -1)*rinc):end,(1 + (j-1)*cinc):end);
            else
                block = distribution((1 + (i -1)*rinc):end,(1 + (j-1)*cinc):(j*cinc));
            end
        else 
            if j==16
                 block = distribution((1 + (i -1)*rinc):(i*rinc),(1 + (j-1)*cinc):end);
            else
                 block = distribution((1 + (i -1)*rinc):(i*rinc),(1 + (j-1)*cinc):(j*cinc));
            end
        end      
        a(i,j) = sum(block(:));
    end
end

rsum = max(a,[],2);
csum = max(a);
threshold = max(a(:))*0.10;

rmin = 0;
cmin = 0;
rmax = 16;
cmax = 16;
for i=1:16
    if rsum(i) <= threshold & rmin == (i - 1)
        rmin = i;     
    end
    if csum(i) <= threshold & cmin == (i - 1)
        cmin = i;     
    end
    if rsum(17-i) <= threshold & rmax == (17-i)
        rmax= 16-i;     
    end
    if csum(17-i) <= threshold & cmax == (17-i)
        cmax = 16-i;     
    end
end

cutnumber = max(cmax-cmin,rmax-rmin);
overc = round((cutnumber - (cmax - cmin))/2);
overr = round((cutnumber - (rmax - rmin))/2);

cropped = imcrop(original,[cinc*(cmin - overc - 1),rinc*(rmin - overr - 1),cinc*(cutnumber + 2),rinc*(cutnumber + 2)]);
cropped = imresize(cropped,[1024,1536]);

if showImage == 1
   image(cropped);
end;

end