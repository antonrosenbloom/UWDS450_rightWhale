%  Prior to running this, run ReadingJson.m in dir where points1.json and
% points2.json files are

% reading the coords from Anil Thomas's bonnet and blowhole data, and
%  using this information to
% 1. Orient the whale heads (i.e., rotate images),
% 2. Rescale the whale heads so that they are all the same size
% 3. Crop the images down to include only whale heads centered about the
%       cropped image.
close all
clear all


fileID = fopen('AnilThomas/bonnet_blowhole.csv');
C = textscan(fileID,'%s %f %f %f %f','Delimiter',',');
fclose(fileID);
nwhales=length(C{1});
bonnet=zeros(nwhales,2);
blowhole=zeros(nwhales,2);
bonnet(:,1)=C{2};
bonnet(:,2)=C{3};
blowhole(:,1)=C{4};
blowhole(:,2)=C{5};

Head_Length=sqrt(sum((bonnet-blowhole).^2,2));
ave_Length=mean(Head_Length);

Head_Orient=atan2((bonnet(:,2)-blowhole(:,2)),(bonnet(:,1)-blowhole(:,1)));% 4 quad inverse tan!; angle in radians
polar(Head_Orient,Head_Length,'.')

% NOTE:  Appears that the whales read in by Anil and the coords he computes
% for the bonnet and blowhole are mirrored about the x-axis by matlab!
%
% rotangle=Head_Orient*180/pi+180;% angle in degrees
rotangle=Head_Orient*180/pi;% angle in degrees

% nwhales=10;
% figure(2);
tic
for i=1:nwhales
% for i=37
    fname=C{1}{i};
    img=imread(strcat('imgs/',fname));
    sz=size(img);
%     subplot(2,2,1)
%     imshow(img)
    
    % Orienting the whales so all headed EAST
    img_O=imrotate(img,rotangle(i),'crop'); % Orient image so whales headed due East.
%     subplot(2,2,2)
%     imshow(img_O)
    
    % Keeping track of Bonnet and Blowhole coordinates after image rotation
    % - this is needed to appropriate crop the image!
    % http://www.mathworks.com/matlabcentral/newsreader/view_thread/264960
    new_bonnet=fn_rotatepts(sz,round(bonnet(i,:)),rotangle(i));
    new_blowhole=fn_rotatepts(sz,round(blowhole(i,:)),rotangle(i));
    
    bump=1;
    if (sum(isnan(new_bonnet)) >0 || sum(isnan(new_blowhole)) > 0)% probleming identifying cropping landmarks
        new_bonnet=fn_rotatepts(sz,round(bonnet(i,:))+bump,rotangle(i));
        new_blowhole=fn_rotatepts(sz,round(blowhole(i,:))+bump,rotangle(i));
    end
    
    % CROPPING images, so only blowhole to bonnet is focused upon!
    buffer=100;% there is a 100 pixel 'buffer' - can increase if needed, or reduced if img size is too big!
    xmin=new_blowhole(1)-buffer/2;% there is a 50 pixel 'buffer' - can increase if needed!
    ymin=new_blowhole(2)-buffer/2-Head_Length(i)/2;
    img_OC=imcrop(img_O,[xmin ymin Head_Length(i)+buffer Head_Length(i)+buffer]);   
%     subplot(2,2,3)
%     imshow(img_OC)
    
    % FINALLY, REscaling, so heads of whales are all the same size!!!
    rescale=ave_Length/Head_Length(i);
    img_OCR=imresize(img_OC,rescale);% resized so the head of whale is the same as the ave head length!
%     subplot(2,2,4)
%     imshow(img_OCR)
    fname2=strcat('imgs_OCR/',fname(1:length(fname)-4),'_OCR.jpg');
    imwrite(img_OCR,fname2);
    if (mod(i,100)==0)
        disp(i);% check to see if processing is ongoing!
    end
end

toc

