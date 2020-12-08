clear all ;
% Load image and paramters
im1 = imread('../data/im1.png');
im2 = imread('../data/im2.png');
im1 = rgb2gray(im1);
im2 = rgb2gray(im2);
load('rectify.mat', 'M1', 'M2', 'K1n', 'K2n', 'R1n', 'R2n', 't1n', 't2n');


maxDisp = 20; 
windowSize = 6;
dispM = get_disparity(im1, im2, maxDisp, windowSize);
% disp(mean(mean(dispM)));
% --------------------  get depth map

depthM = get_depth(dispM, K1n, K2n, R1n, R2n, t1n, t2n);

% disp(mean(mean(depthM)));
% --------------------  Display

figure; imagesc(dispM.*(im1>40)); colormap(gray); axis image;
title("Disparity before Rectification");
figure; imagesc(depthM.*(im1>40)); colormap(gray); axis image;
title("Depth before Rectification");


load('../data/intrinsics.mat', 'K1', 'K2');

load('../data/extrinsics.mat', 'R1', 'R2', 't1', 't2');

[M1, M2, K1n, K2n, R1n, R2n, t1n, t2n] = rectify_pair(K1, K2, R1, R2, t1, t2);
% 
% [rectIL, rectIR, bbL, bbR] = warp_stereo(im1, im2, M1, M2) ;

% Save the rectification parameters
save('rectify.mat', 'M1', 'M2', 'K1n', 'K2n', 'R1n', 'R2n', 't1n', 't2n');

% Display
[rectIL, rectIR, bbL, bbR] = warp_stereo(im1, im2, M1, M2) ;

rectImg2 = rectIR(1:640, 1:size(im2,2));
rectImg1 = rectIL(1:640, size(im1,2)-40:end);


% rectImg1 = imcrop(rectIL, bbL);
% rectImg2 = imcrop(rectIR, bbR);

% figure;imshow(rectImg1); title("rectIL");
% figure;imshow(rectImg2); title("rectIR");
% disp(size(rectImg1));
% disp(size(rectImg2));
dispM2 = get_disparity(rectImg1, rectImg2, maxDisp, windowSize);
% disp(mean(mean(dispM)));
% --------------------  get depth map

depthM2 = get_depth(dispM2, K1n, K2n, R1n, R2n, t1n, t2n);

% disp(mean(mean(depthM)));
% --------------------  Display

figure; imagesc(dispM2.*(rectImg1>40)); colormap(gray); axis image;
title("Disparity After Rectification");
figure; imagesc(depthM2.*(rectImg1>40)); colormap(gray); axis image;
title("Depth After Rectification");