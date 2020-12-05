function F = eightpoint(pts1, pts2, M)
% eightpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.1 - Todo:
%     Implement the eightpoint algorithm
%     Generate a matrix F from correspondence '../data/some_corresp.mat'

[num1, col1] = size(pts1);
[num2, col2] = size(pts2);

if((col1 ~= 2) || (col2 ~= 2))
    error('Points are not formated with correct number of coordinates.');
end
if((num1 < 8) || (num2 < 8))
    error('There are not enough points to carry out the operation.');
end
T = [1/M, 0, 0;
     0, 1/M, 0;
     0, 0, 1];
% disp(size(pts1)); % 110 x 2
p1 = [pts1(1:8, :), ones(8,1)]';
% disp(size(p1)); % 3 x 8
p2 = [pts2(1:8, :), ones(8,1)]';

p1 = T * p1;
p2 = T * p2;
p1 = transpose(p1 ./ repmat(p1(3,:), [3 1]));
p2 = transpose(p2 ./ repmat(p2(3,:), [3 1]));

x1 = p1(:, 1);
y1 = p1(:, 2);
x2 = p2(:, 1);
y2 = p2(:, 2);
% Craft matrix A
A = [x2 .* x1, x2 .* y1, x2, y2 .* x1, y2 .* y1, y2, x1, y1, ones(8, 1)];
% A = [x2 * x1, x2 * y1, x2, y2 * x1, y2 * y1, y2, x1, y1, ones(8, 1)];

[~, S, V] = svd(A);
[~,j] = min(diag(S));
F =reshape(V(:,j), [3,3])';
[U, S, V] = svd(F);
[~,j] = min(diag(S));
S(j,j) = 0;
F = U * S * V';
F = refineF(F, p1, p2);
% F = U(:, 1) * S(1,1) * transpose(V(:, 1)) + U(:, 2) * S(2,2) * transpose(V(:, 2));
F = T' * F * T;

% F = T'*F*T ;