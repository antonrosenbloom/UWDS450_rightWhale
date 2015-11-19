% rows = zeros(height(train));
load('trainstuff.mat');
for index=1:height(train)
    
filename=train.Image(index);

ipath = strcat('Whale Images\imgs\', filename);

k = imread(char(ipath));

hsv = rgb2hsv(k);

h = hsv(:,:,1);
s = hsv(:,:,2);
v = hsv(:,:,3);
vl = v;
vl(vl>=0.8)=NaN;
vh = v;
vh(vh<0.8)=NaN;
sl = s;
sl(sl>=0.2)=NaN;
sh = s;
sh(sh<0.2)=NaN;

train.hsum(index) = sum(h(:));
train.hmean(index) = mean(h(:));
train.hvar(index) = var(h(:));

train.vlsum(index) = sum(vl(:),'omitnan');
train.vlmean(index) = mean(vl(:),'omitnan');
train.vlvar(index) = var(vl(:),'omitnan');

train.vhsum(index) = sum(vh(:),'omitnan');
train.vhmean(index) = mean(vh(:),'omitnan');
train.vhvar(index) = var(vh(:),'omitnan');

train.slsum(index) = sum(sl(:),'omitnan');
train.slmean(index) = mean(sl(:),'omitnan');
train.slvar(index) = var(sl(:),'omitnan');

train.shsum(index) = sum(sh(:),'omitnan');
train.shmean(index) = mean(sh(:),'omitnan');
train.shvar(index) = var(sh(:),'omitnan');

%  histogram(vh);
if mod(index,10)==0
    display(index);
end

clear hsv h s v; 
end
