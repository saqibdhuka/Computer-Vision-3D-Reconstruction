I1 = imread('../data/im1.png');
I2 = imread('../data/im2.png');

S = load('../data/someCorresp.mat');

F = eightpoint(S.pts1, S.pts2, S.M);

S2 = load('../data/intrinsics.mat');

E = essentialMatrix(F, S2.K1, S2.K2);

disp("Esssential Matrix");
disp(E);

%checking if E is correct
% p = [S.pts1(1,:)'; 1];
% p2 = [S.pts2(1,:)'; 1];
% disp(p);
% 
% mul = p2' * E * p;
% disp("Checking if E*p is about equal to l'");
% disp(mul);