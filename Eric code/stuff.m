
clear;
load('trainstuff.mat');
for index=1:height(train)
    
filename=train.Image(index);

path=strcat('C:\Users\Eric\Documents\GitHub\UWDS450_rightwhale\cropped training\',filename);

% if exist(char(path), 'file') == 2
%     continue;
% end

ipath = strcat('Whale Images\imgs\', filename);

k = imread(char(ipath));
ksize = size(k);

[w1, w2] = distCreation(k,index,train,0);
[center, wpoints] = centerOfMass(w1);
[centers, spoints]= centerOfMass(w2);

% GM = cell(3,1);
% % Mu = cell(3,1);
% % sigma = cell(3,1);
% for z = 1:3
% GM{z}= fitgmdist(wpoints,z);
% % Mu(z) = GM{z}.mu
% % sigma(z) = GM(z).sigma;
% end

[p,yhat] = lqlingcm(wpoints,center);

if p == NaN
    clear w w1 w2  block c hsv k a V C d b p yhat t;
    continue;
end

% % scatter(spoinrs(:,1),spoints(:,2));
% scatter(spoints(:,1),spoints(:,2));
% % plot(V(:,1),d,'.b-');
% hold on
% plot(center(1),center(2),'gx','linewidth',4);
% plot(centers(1),centers(2),'kx','linewidth',4);
% plot(wpoints(:,1),yhat,'r','linewidth',2);
% hold off

t = rotateImage(k,p(1),center,0);

[t1, t2] = distCreation(t,index,train,1);

c = croppingDown(t,t1,0);

% if ( length(t(:))~=0 )
% imwrite(c,char(path));
% end

if mod(index,10)==0
    display(index);
end

clear w w1 w2  c k p yhat t;
end
