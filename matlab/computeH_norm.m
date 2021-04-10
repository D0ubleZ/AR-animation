function [H2to1] = computeH_norm(x1, x2)

%% Compute centroids of the points
centroid1 = mean(x1);
centroid2 = mean(x2);

len1 = length(x1);
len2 = length(x2);
%% Shift the origin of the points to the centroid
average1 = 0;
average2 = 0;
for i = 1:len1
    average1 = average1 + (norm(x1(i,:) - centroid1) / len1);
end
for i = 1:len2
    average2 = average2 + (norm(x2(i,:) - centroid2) / len2);
end

%% Normalize the points so that the average distance from the origin is equal to sqrt(2).
x1_norm = sqrt(2)/average1;
x2_norm = sqrt(2)/average2;

%% similarity transform 1
T1 = [x1_norm, 0, -x1_norm*centroid1(1);
      0, x1_norm, -x1_norm*centroid1(2);
      0,       0, 1];

%% similarity transform 2
T2 = [x2_norm, 0, -x2_norm*centroid2(1);
      0, x2_norm, -x2_norm*centroid2(2);
      0,       0, 1];

%% Compute Homography
for i = 1:size(x1,1)
    x1(i,:) = (x1(i,:)-centroid1) .* x1_norm;
end
for i = 1:size(x2,1)
    x2(i,:) = (x2(i,:)-centroid2) .* x2_norm;
end
H2to1_norm = computeH(x1,x2);

%% Denormalization
H2to1 = (T1 \ H2to1_norm * T2);
