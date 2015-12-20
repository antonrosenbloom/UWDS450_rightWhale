%%Read-in an image and extract its HOG features and visualize
imgPath='Object_detection_with_HOG\positiveImages\';
imgDir=dir(fullfile(imgPath,'*.jpg'));
%I=imread(imgDir(1).name);
I=HO_158;
I=rgb2gray(I);
[featureVector, hogVisualization] = extractHOGFeatures(I, 'CellSize', [32 32]);
figure;
imshow(I); %hold on;
plot(hogVisualization);

%%
I2=imread(imgDir(2).name);
I2=rgb2gray(I2);
[featureVector2, hogVisualization] = extractHOGFeatures(I2);
l

%% What is the largest image between positive and negative samples?
posSampFiles=imgSampleInfo('Object_detection_with_HOG\positiveImages');
negSampFiles=imgSampleInfo('Object_detection_with_HOG\positiveImages');

%% Create training matrix
trMat=createTrainingMatrixHOG('Object_detection_with_HOG\positiveImages','Object_detection_with_HOG\negativeImages');
%save('hogTrMat.mat', 'trMat');
%dlmwrite('hogTrMat.csv',trMat,',');

