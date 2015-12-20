function tMatrix  = createTrainingMatrixHOG( posSampPath, negSampPath )
% Creates ML binary classification training matrix of image features. First column -- 
% response variable.  1 -- for positive samples. 0 -- for negative sampels

    %% Get lists of negative and positive sample files
    negSampFiles=dir(fullfile(negSampPath, '*.jpg'));
    posSampFiles=dir(fullfile(posSampPath, '*.jpg'));

    %% Create empty 1-dimensional cell array to hold sample feature vectors (fv)
    %fvPos=cell(length(posSampFiles),1);
    %fvNeg=cell(length(negSampFiles),1);
    fvArray=cell(0,0);

    % Fill fvArray (feature-vector Array) with resp variable (1 or 0) plus HOG feagure vectors of the images
    for posIdx=1:length(posSampFiles)
        IMG=imread(fullfile(posSampPath,posSampFiles(posIdx).name));
        IMG=rgb2gray(IMG);
        fv = [1, extractHOGFeatures(IMG, 'CellSize', fun_CalcCellSize(IMG, 1000))];
        fvArray=[fvArray;fv];
    end
    
    for negIdx=1:length(negSampFiles)
        IMG=imread(fullfile(negSampPath,negSampFiles(negIdx).name));
        IMG=rgb2gray(IMG);
        fv = [0, extractHOGFeatures(IMG, 'CellSize', fun_CalcCellSize(IMG, 1000))];
        fvArray=[fvArray;fv];
    end
    
    %% Determine number of columns of the training matrix.  
    % It is equal to the maximum length of the vectors found in fvPos and fvNeg
    nCol=min(cellfun('length',fvArray));
    
    %% Create zero-matrix that will be our training matrix trMat
    trMat=zeros(length(fvArray), nCol);
    
    %% Pupulate training matrix trMat
    for Idx=1:length(fvArray)
        trMat(Idx,:) = fvArray{Idx}(1:nCol);
    end
    
    %% Return
    tMatrix=trMat;
    
    
    
    
    
    
    
    
   




end

