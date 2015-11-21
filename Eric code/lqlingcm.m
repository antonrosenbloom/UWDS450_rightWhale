% This calculates a least square line for a given set of points going
% through a given point. 
% points - The points to fit the line through
% point - The point that anchores the line
% p - the slope and intersept for the line
% yhat - the caculated line points. 
function [p,yhat] = lqlingcm(points,point)

V(:,2) = ones(length(points(:,1)),1,class(points(:,1)));
V(:,1) = points(:,1);
C=V;
d=points(:,2);
A=[];
b=[];
Aeq = [point(1),1];
beq = point(2);

if length(d) ~= 0
    p = lsqlin(C,d,A,b,Aeq,beq);
    yhat = polyval(p,points(:,1));
else
    p =NaN;
    yhat = NaN;
end

end