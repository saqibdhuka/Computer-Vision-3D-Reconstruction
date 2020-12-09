function F = eightpoint(pts1, pts2, M)
% eightpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.1 - Todo:
%     Implement the eightpoint algorithm
%     Generate a matrix F from correspondence '../data/some_corresp.mat'
% % 
n = size(pts1, 1);

p1 = [pts1 ones(n,1)];
p2 = [pts2 ones(n,1)];

T = [2/M, 0, 0;
    0, 2/M, 0;
    0, 0, 1];

p1 = p1 * T;
p2 = p2 * T;

x1 = p1(:,1);
y1 = p1(:,2);
x2 = p2(:,1);
y2 = p2(:,2);


A = [x1.*x2, x1.*y2, x1, y1.*x2, y1.*y2, y1, x2, y2, ones(n, 1)];

[~, ~, V] = svd(A);
F = reshape(V(:,9), 3,3);
[U, S, V] = svd(F);
S(3,3) = 0;
F = U * S * V';
F = refineF(F, p1, p2);
F = T' * F * T;

