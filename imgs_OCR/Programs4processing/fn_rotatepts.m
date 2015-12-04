function [new_points] = fn_rotatepts(sz,points,rotang)
%given points 'inner' (x,y) on an image of size 'sz',
% the function outputs the coords of the points after the image has been
% rotated by an angle 'rotang' in degrees!
% http://stackoverflow.com/questions/28385349/finding-pixel-position-after-imrotate-matlab

S1=zeros(sz(1),sz(2));

S1(points(2),points(1))=255;

S1_O=imrotate(S1,rotang,'crop');

[x1,y1]=find(S1_O);
x1=mean(x1);
y1=mean(y1);

new_points=[y1 x1];

% if (sum(isnan(new_points))>0) % then there is a screwup with angles
%     rotang=rotang+10;
%     S1_O=imrotate(S1,rotang,'crop');
%     [x1,y1]=find(S1_O);
%     x1=mean(x1);
%     y1=mean(y1);
%     
%     new_points=[y1 x1];
% end


end

