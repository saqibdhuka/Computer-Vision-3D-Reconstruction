function P = estimate_pose(x, X)
% ESTIMATE_POSE computes the pose matrix (camera matrix) P given 2D and 3D
% points.
%   Args:
%       x: 2D points with shape [2, N]
%       X: 3D points with shape [3, N]

n = size(X,2);
X = [X; ones(1,n)];
A = [];
% disp(size(X));
for i = 1:n
    X1 = X(:,i)';
%     disp(X1);
    x1 = x(1,i);
    y1 = x(2,i);
    r1 = [X1 0 0 0 0 -x1*X1];
    r2 = [0 0 0 0 X1 -y1*X1];
    A = [A; [r1;r2]];
end
% disp("A size");
% disp(size(A));
[~, S, V] = svd(A);
[~,j] = min(diag(S));
V = V';
P = V(j,:);
P = reshape(P, 4,3);
P = P';
% disp("P size");
% disp(size(P));
