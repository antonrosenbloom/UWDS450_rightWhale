k = imread('Whale Images\imgs\w_2753.jpg');

images = imageSet('Whale Images\imgs'); % 'imgs': Folder of images

for index=1:500

k = read( images, index );

pathname = images.ImageLocation(index);

filestuff = strsplit(char(pathname),'\');


hsv = rgb2hsv(k);

[w(:,:,1), w(:,:,2),w(:,:,3)] = arrayfun(@(x,y,z) whaledist(x,y,z), hsv(:,:,1), hsv(:,:,2), hsv(:,:,3));

% image(w);

w1 = w(:,:,2);

ksize = size(w1)
sum(w1(:))/sum(size(w1(:)))

rinc = uint32(ksize(1)/16);
cinc = uint32(ksize(2)/16);

for i=1:16
    for j=1:16
        if i==16
            if j==16
                block = w1((1 + (i -1)*rinc):end,(1 + (j-1)*cinc):end);
            else
                block = w1((1 + (i -1)*rinc):end,(1 + (j-1)*cinc):(j*cinc));
            end
        else 
            if j==16
                 block = w1((1 + (i -1)*rinc):(i*rinc),(1 + (j-1)*cinc):end);
            else
                 block = w1((1 + (i -1)*rinc):(i*rinc),(1 + (j-1)*cinc):(j*cinc));
            end
        end      
        a(i,j) = sum(block(:));
    end
end
display(a);

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

c = imcrop(k,[cinc*cmin,rinc*rmin,cinc*(cmax-cmin),rinc*(rmax-rmin)]);

% image(c);
path=char(filestuff(length(filestuff)));
if ( length(c(:))~=0 )
imwrite(c,path);
end
clear w w1 block c hsv k a;
end
