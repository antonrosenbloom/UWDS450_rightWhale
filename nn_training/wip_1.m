clear all;
%Problem 1: what is the range of x and y sizes of the training images?

    %get info on all files:
    imgPath='nn_training\headOrnament_positive\';
    imgDir=dir(strcat(imgPath,'*.jpg'));
    nFiles=length(imgDir);  
    imgDimList=cell(nFiles,3);
    for idx=1:nFiles
       idx_imageFileName = strcat(imgPath,imgDir(idx).name);
       fInfo = imfinfo(idx_imageFileName);
       imgDimList(idx,:)={fInfo.Filename, fInfo.Width, fInfo.Height};  
    end

     %get the range of values   
     xMin=[min([imgDimList{:,2}])]; 
     xMax=[max([imgDimList{:,2}])];
     yMin=[min([imgDimList{:,3}])]; 
     yMax=[max([imgDimList{:,3}])]; 
 
 %Problem 2: to avoid data loss, resize all images to xMax yMax. Convert to grey-scale 
 %Then %rehshape each image matrix into a horizontal vector.
 
 %Prepare the container matrix pInput
 pInput=zeros(nFiles,xMax*yMax);
 
 %Fill the container matrix pInput with positive image pixels, 1 per row:
 for idx=1:1%nFiles
     Image=imread(imgDimList{idx, 1});
     % imresize(Image,[numrows numcols])
     rImage=imresize(Image,[yMax xMax]);
     figure, imshow(Image);
     figure, imshow(rImage);
 end
 
 

