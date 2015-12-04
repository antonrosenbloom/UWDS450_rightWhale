% # Read the json files created by Anil Thomas, at the Kaggle Right Whale competition and posted on Github
% # https://github.com/anlthms/whale-2015
% # Points1 is the bonnet tip
% # Points2 is the blow hole coordinates

% Might need to do this before the loadjson function is enabled:
% addpath('/Users/Shared/matlabfiles/jsonlab')

bonnet=loadjson('points1.json');
blowhole=loadjson('points2.json');

nimgs=length(bonnet);

bonnet_out=cell(nimgs,3);
blowhole_out=cell(nimgs,3);
for i=1:nimgs
    bonnet_out{i,1}=bonnet{i}.filename;
    bonnet_out{i,2}=bonnet{i}.annotations{1}.x;
    bonnet_out{i,3}=bonnet{i}.annotations{1}.y;
    
    blowhole_out{i,1}=blowhole{i}.filename;
    blowhole_out{i,2}=blowhole{i}.annotations{1}.x;
    blowhole_out{i,3}=blowhole{i}.annotations{1}.y;
end

a=zeros(nimgs,1);
head_length=zeros(nimgs,1);
for i=1:nimgs
    if (bonnet_out{i,1} == blowhole_out{i,1})
        a(i)=1;
        %         head_length(i)=(bonnet_out{i,2}-blowhole{i,2}).^2;
    end
end

if sum(a)==nimgs % making sure that bonnet and blowhole data are from same whale
    fid = fopen('bonnet_blowhole.csv','w');
    for i=1:nimgs
        fprintf(fid,'%s, %f,%f,%f,%f\n',bonnet_out{i,1},bonnet_out{i,2},bonnet_out{i,3},...
            blowhole_out{i,2},blowhole_out{i,3});
    end
    fclose(fid);
end

