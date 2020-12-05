I1 = imread('../data/im1.png');
I2 = imread('../data/im2.png');

S = load('../data/someCorresp.mat');

F = eightpoint(S.pts1, S.pts2, S.M);

epipolarMatchGUI(I1, I2, F);
