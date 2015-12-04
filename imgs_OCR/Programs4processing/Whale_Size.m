clear all
close all
% reading train.csv files


tic
% fileID = fopen('train.csv');
% C = textscan(fileID,'%s %s','Delimiter',',');
% fclose(fileID);
% n_images=size(C{1},1)-1;
fileID = fopen('AnilThomas/bonnet_blowhole.csv');
C = textscan(fileID,'%s %f %f %f %f','Delimiter',',');
fclose(fileID);
n_images=length(C{1});

% n_images=1; % just for testing purposes
noImg=[];
% n_images=50;
sz=zeros(n_images,2);
for i=1:n_images
%     fname=C{1}{i+1};
    fname=C{1}{i};
    %     Whale_Img=imread(strcat('/Users/sundars/Github/UWDS450_rightWhale/cropped training/',fname));% reading image of whale
    Whale_Img=imread(strcat('imgs_OCR/',fname(1:length(fname)-4),'_OCR.jpg'));% reading image of whale
    a=size(Whale_Img);
    sz(i,1)=a(1);
    sz(i,2)=a(2);
    if (mod(i,100)==0)
        i% just to verify that the processing is on going
    end
end

ind_outlier=[];
aa=sz(:,1).*sz(:,2);
mean_aa=mean(aa);
sd_aa=std(aa);
for i=1:n_images
    if (aa(i)>mean_aa+2*sd_aa || aa(i) < mean_aa -2*sd_aa)
        ind_outlier=[ind_outlier;i];
    end
end
toc
% dlmwrite('junk.txt',strcat(C{1}{ind_outlier+1}))
fid = fopen('Image_Outliers.csv','w');
for i=1:length(ind_outlier)
%     fprintf(fid,'%s\n',C{1}{ind_outlier(i)});
    fprintf(fid,'%s\n',C{1}{ind_outlier(i)});

end
fclose(fid);
dlmwrite('Image_Outliers2.csv',ind_outlier)
