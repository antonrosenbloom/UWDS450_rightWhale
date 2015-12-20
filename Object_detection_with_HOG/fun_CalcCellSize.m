function CellSize = fun_CalcCellSize( Img, lengthN )
% Given an Image and the desired feature-vector length lengthN calculate
% CellSize parameter to be used in the call to the extractHOGFeatures() funciton

% HOG feature length, N, is based on the image size and the function parameter values.
% N=prod([BlocksPerImage, BlockSize, NumBins]);  % (Eq1)
% BlocksPerImage = floor((size(I)./CellSize-BlockSize)./(BlockSize-BlockOverlap) + 1); %(Eq2)

NumBins=9; %Default value
BlockSize=[2 2]; %Default value
BlockOverlap=ceil(BlockSize/2); %Default value
% CellSize=[4 4]; %I will be solving for it
N=lengthN; %Seems like a reasonable length of the feature vector at the moment
%I=rgb2gray(Img); the image submitted to this funciton is already
%gray-scale
I=Img;
xI=size(I,1);
yI=size(I,2);
nB=NumBins;
xB=BlockSize(1);
yB=BlockSize(2);
xBO=BlockOverlap(1);
yBO=BlockOverlap(2);

% From Eq2 is follows that BPI (Block per image) in vector form can be written as:
%[((xI/Z-xB)/(xB-xBO))+1, ((yI/Z-yB)/(yB-yBO))+1]
% From Eq1 it follows that
% xBPI*yBPI*xB*yB*nB=N 

% xBPI=yBPI*xI/yI % keeping BPI according to the given image aspect ratio

%Arriving at quadratic equation:
% yBPI^2*xI*xB*yB*nB-N*yI=0

% Create matrix of coefficients of the quadratic equation to use in roots()
% funciton:
  MtxCo=[xI*xB*yB*nB, 0, N*yI];

%Solve quadratic equation
result=roots(MtxCo);

%Absolute value of the first root is BPI along the y axis of the image:
yBPI=ceil(abs(result(1)));

%Calculate BPI along the x axis of teh image:
xBPI=ceil(yBPI*xI/yI);

%Compbine results into the BlocksPerImage vector:
BlocksPerImage=[xBPI, yBPI];

% Now. According to Eq2 we can write BPI as a vector in this form:
%BPI=[((xI/Z-xB)/(xB-xBO))+1       ((yI/Z-yB)/(yB-yBO))+1]   Eq6

% Z in Eq6 are the cell dimension that we are looking for (since we want
% the cell to be square, the dimensions are equal.  We can use either of
% the equations for BPI dimensions to solve for Z.  Let's use the first
% dimension:

%((xI/Z-xB)/(xB-xBO))+1 =xBPI
% xI/Z-xB=(xBPI-1)*(xB-xBO)
% xI/Z=((xBPI-1)*(xB-xBO))+xB
% and finally:

Z=floor(xI/(((xBPI-1)*(xB-xBO))+xB));

% Owing to the fact that we decided to keep the cells scquare
CellSize=[Z, Z];


end

