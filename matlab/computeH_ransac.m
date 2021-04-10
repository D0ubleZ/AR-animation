function [ bestH2to1, inliers, pairs1, pairs2] = computeH_ransac( locs1, locs2)
%COMPUTEH_RANSAC A method to compute the best fitting homography given a
%list of matching points.

len1 = length(locs1);
len2 = length(locs2);
inliers = zeros(len1,1);
max = 0;

threshold = 0.7;

for i = 1:10000
    inliers_temp = zeros(len2,1);
    p1 = zeros(4,2);
    p2 = zeros(4,2);
    
%   Get four point correspondences (randomly)
    random_point = randperm(len1,4);
    for j = 1:4
        p1(j,1) = locs1(random_point(j),1);
        p1(j,2) = locs1(random_point(j),2);
        p2(j,1) = locs2(random_point(j),1);
        p2(j,2) = locs2(random_point(j),2);
    end
%   Compute H using DLT
    H = computeH_norm(p1,p2);
    
%   Count inliers
    count_inliers = 0;
    for j = 1:len1
        temp =  H *[locs2(j,1);locs2(j,2);1];
        
        H_trans = temp/temp(3);
        distance = sqrt((H_trans(1) - locs1(j,1))^2 + (H_trans(2) - locs1(j,2))^2);
        
        if distance < threshold
            inliers_temp(j) = 1;
            count_inliers = count_inliers + 1;
        end 
    end
%   Keep H if largest number of inliers  
    if count_inliers > max
        max = count_inliers;
        inliers = inliers_temp;
        bestH2to1 = H;
        pairs1 = p1;
        pairs2 = p2;
    end
    
end

%Q2.2.3
end

