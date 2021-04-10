% Your solution to Q2.1.5 goes here!

%% Read the image and convert to grayscale, if necessary
cv_cover = imread('../data/cv_cover.jpg');
img1 = cv_cover;
if ndims(cv_cover) == 3
    img1 = rgb2gray(cv_cover);
end

%% Compute the features and descriptors
hist_brief = zeros(1, 36);
hist_surf = zeros(1, 36);

angle = 10;
for i = 0:36
    %% Rotate image
    cv_cover_rotate = imrotate(img1, angle * i);
    
    %% Compute features and descriptors
    features1 = detectFASTFeatures(img1);
    features1_rotate = detectFASTFeatures(cv_cover_rotate);
    [desc1, locations1] = computeBrief(img1, features1.Location);
    [desc1_rotate, locations1_rotate] = computeBrief(cv_cover_rotate, features1_rotate.Location);
    
    features2 = detectSURFFeatures(img1);
    features2_rotate = detectSURFFeatures(cv_cover_rotate);
    [desc2, locations2] = extractFeatures(img1, features2, 'Method', 'SURF');
    [desc2_rotate, locations2_rotate] = extractFeatures(cv_cover_rotate, features2_rotate, 'Method', 'SURF');
    
    %% Match features
    threshold = 10.0;
    ratio = 0.7;
    indexPairs1 = matchFeatures(desc1,desc1_rotate,'MatchThreshold', threshold, 'MaxRatio', ratio);
    indexPairs2 = matchFeatures(desc2,desc2_rotate,'MatchThreshold', threshold, 'MaxRatio', ratio);
    
    if i == 9 || i == 18 || i == 27
        locs1 = locations1(indexPairs1(:,1),:);
        locs2 = locations1_rotate(indexPairs1(:,2),:);
        
        figure;
        showMatchedFeatures(img1, cv_cover_rotate, locs1, locs2, 'montage');
        
        locs1 = locations2(indexPairs2(:,1),:);
        locs2 = locations2_rotate(indexPairs2(:,2),:);
        
        figure;
        showMatchedFeatures(img1, cv_cover_rotate, locs1, locs2, 'montage');
    end

    %% Update histogram
    hist_brief(i+1) = length(indexPairs1);
    hist_surf(i+1) = length(indexPairs2);
end

%% Display histogram
x = (0:10:360);
figure;
plot(x,hist_brief);
xlabel('Angel');
ylabel('Matchs features');
title('BRIEF')

figure;
plot(x,hist_surf);
xlabel('Angel');
ylabel('Matchs features');
title('SURF')