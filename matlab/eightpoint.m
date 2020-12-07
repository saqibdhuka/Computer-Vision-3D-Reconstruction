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

% A = [x2.*x1, x2.*y1, x2, y2.*x1, y2.*y1, y2, x1, y1, ones(n, 1)];
A = [x1.*x2, x1.*y2, x1, y1.*x2, y1.*y2, y1, x2, y2, ones(n, 1)];
% A = ones(n,0);
% 
% for i = 1:3
%    c =  1 + ((i-1)*3) : i*3; 
%    A(:,c) = p1 .* repmat(p2(:,i), 1, 3);
% end

[~, ~, V] = svd(A);
F = reshape(V(:,9), 3,3);
[U, S, V] = svd(F);
S(3,3) = 0;
F = U * S * V';
F = refineF(F, p1, p2);
F = T' * F * T;

% T = [1/M 0 0; 
%     0 1/M 0; 
%     0 0 1];
% pt1 = p1 * T';
% pt2 = p2 * T';
% 
% A = ones(n,0);
% 
% for i = 1:3
%    c =  1 + ((i-1)*3) : i*3; 
%    A(:,c) = pt1 .* repmat(pt2(:,i), 1, 3);
% end
% [~, ~, V] = svd(A);
% F = reshape(V(:,9), 3,3);
% [U, S, V] = svd(F);
% S(:, end) = 0;
% F = U * S * V';
% F = refineF(F, p1, p2);
% F = T' * F * T;
% 
% 
% 
% % [U, S, V] = svd(A);
% % 
% % S(:,end) = 0;
% % 
% % A = U * S * V';
% % 
% % [~, ~, V] = svd(A);
% % F = V(:,9);
% % F = reshape(F, [3,3]);
% % F = refineF(F, pt1, pt2);
% % F = T' * F * T;
%  