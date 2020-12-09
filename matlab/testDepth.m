clear all ;
% Load image and paramters
im1 = imread('../data/im1.png');
im2 = imread('../data/im2.png');
im1 = rgb2gray(im1);
im2 = rgb2gray(im2);
load('rectify.mat', 'M1', 'M2', 'K1n', 'K2n', 'R1n', 'R2n', 't1n', 't2n');


maxDisp = 20; 
windowSize = 5;
dispM = get_disparity(im1, im2, maxDisp, windowSize);

% --------------------  get depth map

depthM = get_depth(dispM, K1n, K2n, R1n, R2n, t1n, t2n);


% --------------------  Display

figure; imagesc(dispM.*(im1>40)); colormap(gray); axis image;
title("Disparity before Rectification");
figure; imagesc(depthM.*(im1>40)); colormap(gray); axis image;
title("Depth before Rectification");

% rectify
testRectify;
[rectIL, rectIR, bbL, bbR] = warp_stereo(im1, im2, M1, M2) ;

rectIL = rectIL(1:end, 400:end);
rectIR = rectIR(1:end, 1:end-400);

rectIL = imresize(rectIL, [640, 480]);
rectIR = imresize(rectIR, [640, 480]);

maxDisp = 20; 
windowSize = 5;

dispM2 = get_disparity(rectIL, rectIR, maxDisp, windowSize);

% --------------------  get depth map

depthM2 = get_depth(dispM2, K1n, K2n, R1n, R2n, t1n, t2n);

% --------------------  Display

figure; imagesc(dispM2.*(im1>40)); colormap(gray); axis image;
title("Disparity After Rectification");
figure; imagesc(depthM2.*(im1>40)); colormap(gray); axis image;
title("Depth After Rectification");