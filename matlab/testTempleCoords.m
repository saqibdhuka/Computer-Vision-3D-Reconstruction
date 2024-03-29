% A test script using templeCoords.mat
%
% Write your code here
%
clear;
clc;

I1 = imread('../data/im1.png');
I2 = imread('../data/im2.png');

S = load('../data/someCorresp.mat');

F = eightpoint(S.pts1, S.pts2, S.M);
% F = estimateFundamentalMatrix(S.pts1, S.pts2);
S2 = load('../data/templeCoords.mat');
pts1 = S2.pts1;
pts2 = epipolarCorrespondence(I1, I2, F, pts1);

% disp(size(pts2));
S3 = load('../data/intrinsics.mat');

K1 = S3.K1;
K2 = S3.K2;


E = essentialMatrix(F, S3.K1, S3.K2);

P1 = [eye(3), zeros(3,1)];
P2 = camera2(E);
most_zeros = 0;
correct_P = P1;
best_pts3d = [];
for i = 1:4
   curr_p = P2(:,:,i);
   [pts3d, ~, ~] = triangulate(K1 * P1, pts1, K2 * curr_p, pts2);
   num_zeros = sum(pts3d(:,3));
   if num_zeros > most_zeros && curr_p(3,3) > 0
      most_zeros = num_zeros;
      correct_p = curr_p;
      best_pts3d = pts3d;
   end
end
R1 = P1(1:3, 1:3)';
t1 = P1(:,4);
R2 = correct_p(1:3, 1:3);
t2 = correct_p(:,4);
plot3(best_pts3d(:,1), best_pts3d(:,2), best_pts3d(:,3), '.');
axis equal;

% save extrinsic parameters for dense reconstruction
save('../data/extrinsics.mat', 'R1', 't1', 'R2', 't2');
