% This extractes the non zero points with value acd calculates the center
% of mass. 
% distribution - any sparse matrox
% center - The center of mass for the distribution in the matrix
% points - The set of nonzero points with value fot the distrobution
function [center,points] = centerOfMass(distribution)

totalsum = sum(distribution(:));
center = zeros(1:2);
points = zeros(totalsum,3);
[points(:,1),points(:,2),points(:,3)] = find(distribution);
for i=1:totalsum
   center(1) = center(1) + points(i,1);
   center(2) = center(2) + points(i,2);
end
center = round(center/totalsum);

end