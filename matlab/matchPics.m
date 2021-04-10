function [ locs1, locs2] = matchPics( I1, I2 )
%MATCHPICS Extract features, obtain their descriptors, and match them!

%% Convert images to grayscale, if necessary
img1 = I1;
if ndims(I1) == 3
    img1 = rgb2gray(I1);
end
img2 = I2;
if ndims(I2) == 3
    img2 = rgb2gray(I2);
end
%% Detect features in both images
features1 = detectFASTFeatures(img1);
features2 = detectFASTFeatures(img2);
%% Obtain descriptors for the computed feature locations
[desc1, locations1] = computeBrief(img1, features1.Location);
[desc2, locations2] = computeBrief(img2, features2.Location);
%% Match features using the descriptors
threshold = 10.0;
ratio = 0.7;
indexPairs = matchFeatures(desc1,desc2,'MatchThreshold', threshold, 'MaxRatio', ratio);

locs1 = locations1(indexPairs(:,1),:);
locs2 = locations2(indexPairs(:,2),:);

% showMatchedFeatures(img1, img2, locs1, locs2, 'montage');

end

