% Q3.3.1
cv_cover = imread('../data/cv_cover.jpg');

book = loadVid('../data/book.mov');
source = loadVid('../data/ar_source.mov');
hp_img = imread('../data/hp_cover.jpg');

result = VideoWriter('ar.avi');

mkdir images;
open(result);

if length(book) >= length(source)
    len = length(source);
else
    len = length(book);
end

for i=1:len
    if i == 438
        continue
    end
    book_img = book(i).cdata;
    source_img = source(i).cdata;
    corp_img = source_img(50:size(source_img,1)-50, 215:425,:);
    
    [locs1, locs2] = matchPics(cv_cover, book_img);
    [bestH2to1,~] = computeH_ransac(locs1, locs2);
    
    scaled_source = imresize(corp_img, [size(cv_cover,1) size(cv_cover,2)]);
    result_img = compositeH(inv(bestH2to1), scaled_source, book_img);
    
    
    imwrite(result_img,'images/'+string(i)+'_image.jpg');

    writeVideo(result,result_img);

end

close(result);
