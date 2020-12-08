%script for 3.1.4

I1 = imread('../data/im1.png');
I2 = imread('../data/im2.png');

S = load('../data/someCorresp.mat');

pts1 = S.pts1;
pts2 = S.pts2;


F = eightpoint(S.pts1, S.pts2, S.M);

S3 = load('../data/intrinsics.mat');

K1 = S3.K1;
K2 = S3.K2;


E = essentialMatrix(F, S3.K1, S3.K2);


P1 = [eye(3), zeros(3,1)];



P2 = camera2(E);
most_zeros =0;
best_err1 = 0;
best_err2 = 0;
correct_P = P1;
best_pts3d = [];
for i = 1:4
    curr_p = P2(:,:,i);
   [pts3d, err1, err2] = triangulate(K1 * P1, pts1, K2 * curr_p, pts2);
%    disp(err);
   num_zeros = sum(pts3d(:,3));
   if num_zeros > most_zeros && curr_p(3,3) > 0
      most_zeros = num_zeros;
      correct_p = curr_p;
      best_err1 = err1;
      best_err2 = err2;
      best_pts3d = pts3d;
   end
end

% plot3(best_pts3d(:,1), best_pts3d(:,2), best_pts3d(:,3), '.');
% axis equal;


disp("seperate errors from correct Projection matrix");
disp("error 1:");
disp(best_err1);
disp("error 2:");
disp(best_err2);