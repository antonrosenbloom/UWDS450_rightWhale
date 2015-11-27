
imgSource_path='playbox\'
HOpositive_path='nn_training\headOrnament_positive\';


lImages=dir(strcat(imgSource_path,'*.jpg'));
nfiles=length(lImages);  %dir includes and coounts . and .. at the head of each directory
for idx=141:nfiles
   idx_imageFileName = strcat(imgSource_path,lImages(idx).name);
   I=imread(idx_imageFileName);
   [iCropped, rect]=imcrop(I);
   croppedImFileName=strcat(HOpositive_path, 'HO_', num2str(idx), '.jpg')
   imwrite(iCropped, croppedImFileName);
end









