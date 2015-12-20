function sampInfo = imgSampleInfo(imgPath)

%imgSampleInfo Creates a cell array of JPEG file names and their pixel
%dimensions

    imDir=dir(fullfile(imgPath,'*.jpg'));
    nFiles=length(imDir);  
    imDimList=cell(nFiles,3);
    for idx=1:nFiles
       idx_imageFileName = fullfile(imgPath,imDir(idx).name);
       fInfo = imfinfo(idx_imageFileName);
       imDimList(idx,:)={fInfo.Filename, fInfo.Width, fInfo.Height};  
    end
    
    sampInfo=imDimList;

end

