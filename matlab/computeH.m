function [ H2to1 ] = computeH( x1, x2 )
%COMPUTEH Computes the homography between two sets of points
len = size(x1,1);

A = zeros(2*len,9);
for i = 1:len
    % [-xi, -yi, -1, 0, 0, 0, xixi', yixi', xi']    
    % [0, 0, 0, -xi, -yi, -1, xiyi', yiyi', yi']
    A(2*i-1,:) = [-x2(i,1), -x2(i,2), -1,0,0,0, x2(i,1)*x1(i,1), x2(i,2)*x1(i,1), x1(i,1)];
    A(2*i,:)   = [0,0,0, -x2(i,1), -x2(i,2),-1, x2(i,1)*x1(i,2), x2(i,2)*x1(i,2), x1(i,2)];
end

[~,~,V] = svd(A);

H2to1 = reshape(V(:,9),3,3);
H2to1 = H2to1';

