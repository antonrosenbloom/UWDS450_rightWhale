% Whale Eigenfaces

% from the paper "Eigenfaces for Recognition" by Mathew Turk and Alex Pentland
%
% Reads in train and test images, and outputs the weights for each image,
% which represents the contribution of each eigenface in representing the
% input (train or test) image.

% The training and test weights can be compared (e.g., euclidean dist) to
% determine whale ids of the test images (done here).

% OR

% The training weights can be used to build a more advanced classifier, and
% the model can be used to determine whale ids of the test images.
%

clear all
close all
% Specify the proportion of cumulative variance that is acceptable!
threshold=input('what amount of cumulative variance should be explained: e.g., 90%, 95%, 99%? ');

tic
% --------------------------------------------------------------------------------------------------------
% reading the 'M' images (e.g., N x N dim per image) and storing image data
% as a matrix of vectors (N^2 x M)
% these are the cropped images of whales, where each image is assumed to be of the same size!

fileID = fopen('train.csv');
C = textscan(fileID,'%s %s','Delimiter',',');
fclose(fileID);
M=size(C{1},1)-1;
% M=50 % for testing code
S=[];
% figure(1);
for i=1:M
    %     str=strcat('junk_imgs/cropped',int2str(i-1),'.jpg');%reading image
    %     %     that were previously cropped
    %     img=imread(str);
    fname=C{1}{i+1};
    img=imread(strcat('/Users/sundars/Github/UWDS450_rightWhale/cropped training/',fname));% reading image of whale
    
    % NOTE, converting to gray scale - may need to retain color image at
    % some point.
    img=rgb2gray(img);
    
    % NOTE - The resizing done next, is needed at this point because the S matrix for
    % 4544 images in the training set is way bigger than Matlab array size maxima!
    % Might be able to relax this, IFF the images can be further cropped to
    % just the head of the whale!  Problem is that resolution is lower!!!
    if (i == 1)
        img=imresize(img,0.25);%25% the original size
        ht=size(img,1);
        wt=size(img,2);
    else % TO MAKE SURE THE RESIZING OF REMAINING IMAGES is Consistent with the 1st resizing!
        img=imresize(img,[ht wt]);
    end
    %     subplot(ceil(sqrt(M)),ceil(sqrt(M)),i)
    %     imshow(img)
    %     drawnow;
    [irow icol, idepth]=size(img);    % get the number of rows (N1) and columns (N2), and idepth (RGB or BW)
    S=[S reshape(img,irow*icol*idepth,1)]; %S is a N1*N2xM matrix after finishing the for loop
    
    if (mod(i,200)==0)% just to keep track of where the process is at.
        disp(i);
    end
    %this is our S
end
%
% --------------------------------------------------------------------------------------------------------
% % Linear Normalization of the images to a standard range of pixels (0 -> 255).

S=double(S);
max_im=max(S);
min_im=min(S);
new_max=255;
new_min=0;
for i=1:size(S,2)
    S(:,i)=(new_max-new_min)*(S(:,i)-min(S(:,i)))/(max(S(:,i))-min(S(:,i)));
end

%show normalized images
% figure(2);
% for i=1:M
%     img=reshape(S(:,i),irow,icol);
%     % img=img';
%     subplot(ceil(sqrt(M)),ceil(sqrt(M)),i)
%     imshow(uint8(img))
%     drawnow;
%     if i==1
%         title('Normalized Training Set','fontsize',18)
%     end
% end

% --------------------------------------------------------------------------------------------------------
% calculating phi - the mean of all the training images!
psi_mat=mean(S,2);% this is the mean image!
mean_img=reshape(uint8(psi_mat),irow,icol);
% mean_img=mean_img';
figure(3);
subplot(1,1,1);
title('average whale face','fontsize',18)
imshow(mean_img)

% --------------------------------------------------------------------------------------------------------
% Constructing the 'A' matrix (i.e., the collection of individual image
% matrices - the average image.
A_mat=bsxfun(@minus,S,psi_mat);
clear S;% freeing up memory as 'S' matrix is no longer needed!

% --------------------------------------------------------------------------------------------------------
% Constructing the 'small' MxM covariance matrix L.
L_mat=A_mat'*A_mat;

% --------------------------------------------------------------------------------------------------------
% Obtaining the eigenvectors and eigenvalues
% Note that the eigenvalues for the covariance matrix C=A*A' and for L=A'*A are the
% same, but the eigenvectors for C is Av, where v is the eigenvector for L.
[V_mat,D_mat]=eig(L_mat);

D_mat(D_mat<1e-4)=0;% zeroing small quants
D_EigVals=sort(diag(D_mat),'descend'); % eigenvalues sorted in descending order (so top 'xx' can be kept)
figure(4);
Explained_Var=D_EigVals/sum(D_EigVals)*100;
subplot(1,2,1)
plot(D_EigVals);
title('Eigenvalues','fontsize',18)
subplot(1,2,2)
cumVar=cumsum(Explained_Var);
plot(cumVar)
title('Cumulative Variance/eigenvalue','fontsize',18)
% since eigenvalues were sorted, have to do same for eigenvectors
V_mat=fliplr(V_mat);% now, top 'xx' eigenvectors are arranged left to right in V_mat, corresonding to the eigenvalues
% in descending order.

%Based upon the user specified threshold for
Mprime=find(cumVar>=threshold,1,'first');% this is the no of eigenvectors/eigenfaces that need to be considered

% in order to explain at least threshold% of the
% variance in the whale image data!
%Tossing out the remaining eigenvectors as they are no longer needed
V_mat=V_mat(:,1:Mprime);% in effect, the no of eigenfaces that are computed will be Mprime, not M.

% --------------------------------------------------------------------------------------------------------
% Now, determining the EIGENFACES
U_EigFace=A_mat*V_mat;
% U_EigFace=bsxfun(@plus,U_EigFace,phi_mat);% Not sure about this...
% displaying eigenfaces;
figure(5);
for i=1:10% display top ten eigenfaces
    img=reshape(U_EigFace(:,i),irow,icol);
    % img=img';
    subplot(ceil(sqrt(10)),ceil(sqrt(10)),i)
    imshow(uint8(img));
    str=strcat('E.Faces',int2str(i));
    title(str,'fontsize',18)
end

% if
% the rest of the ML based id of whales is to be done offline,
% then
% execute the statement below:
% (will save the variables needed to determine the weights of
% training images and the test images to be provided)

% save('Whale_EigenFace_Out.mat','U_EigFace','A_mat','phi_mat');


% --------------------------------------------------------------------------------------------------------
% Now, can det the weights (Omega) for each of the training images, for all
% M eigenfaces

% if want for only top M' eigenfaces, where M' < M, then set
% U_EigFace(:,M'+1:M)= 0;

Omega_train=U_EigFace'*A_mat;

Omega_train=Omega_train';% this is the feature set (of weights in each ROW) for the training images
% for use in ML based classification of whales by ID



% --------------------------------------------------------------------------------------------------------
% For the Test images,
% U_EigFace and phi_mat can be used to project a new test image onto the
% eigenface space, and to get the set of weights 'Omega_test' for the test
% images.  Those weights (or features) can be used to classify what the ID
% of the test images are (or the probability that it belongs to certain whale
% IDs).  For this:

% For a new input image, say 'test.img', read image, reshape into a N^2
% vector, normalize image, subtract psi_mat (average) from vector and
% project onto eigenfaces to get the weights:
% Omega_Test.  Then compare (either via Euclidean, or via the ML model)
% which train image the test image corresponds with to id the test image!
%
%
% test_id=zeros(M,1);
% Omega_test=zeros(M,M);% change 'M' once debugging is done! to something more appropriate n= no of test images
% for i=1:M
%     %     img=read(test_images,i);
%     str=strcat('junk_test/cropped',int2str(i-1),'.jpg');
%     img=imread(str);%reading test image
%     %img=(rgb2gray(img))';
%     img=rgb2gray(img);
%     Gamma=double(reshape(img,icol*irow*idepth,1));
%     Gamma=(new_max-new_min)*(Gamma-min(Gamma))/(max(Gamma)-min(Gamma));% test image normalization
%     A_test=Gamma-psi_mat;% subtracting out the average
%     wts_test=(U_EigFace'*A_test)';% getting the weights by projecting image onto eigenface basis
%     Omega_test(i,:)=wts_test;
%     % Now, can use Omega_test into a trained ML model to predict the ID of
%     % the test image!
%
%     % As first step, can do via euclidean distance:
%     dif=bsxfun(@minus,Omega_train,Omega_test(i,:));
%     euc_dist=sum(dif.^2,2);% not that actual eucledian distance is sqrt of this quantity!
%     % and the test image is closes to the train image (index):
%     [a,min_index]=min(euc_dist);
%     test_id(i)=min_index;
%
%     %one test is to to use the same test and train images, then this proc
%     %should be exact or 100% accurate.
%     % And this is true for M=10,
% end

% if the classification is going to be performed offline, ie. using the
% training and test set weights as features, then save the Omega_train and
% Omega_test variables! use the save command if ML is in matlab.  else, use
% the dlmwrite command
save('Whale_Omega_Train.mat','Omega_train');
% save('Whale_Omega_Test.mat','Omega_test');
dlmwrite('Whale_Omega_Train.csv',Omega_train,',')
% dlmwrite('Whale_Omega_Test.csv',Omega_test,',')

%
%

toc