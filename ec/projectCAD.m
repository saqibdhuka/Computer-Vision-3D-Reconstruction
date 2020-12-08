S=load('../data/PnP.mat');
% disp(S);
%     X: [3×30 double]
%       cad: [1×1 struct]
%     image: [333×500×3 uint8]
%         x: [2×30 double]
x = S.x;
X = S.X;
cad = S.cad;
img = S.image;
% imshow(img);
disp(cad);
P = estimate_pose(x, X);
[K, R, t] = estimate_params(P);
proj_pts = X' * P;
disp(proj_pts);
figure;
imshow(img);
hold on;
plot(x(1,:), x(2,:), 'LineStyle', 'none', 'Marker', 'o', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'none');
% plot(x(1,:), x(2,:), 'LineStyle', 'none', 'Marker', 'o', 'MarkerEdgeColor', 'none', 'MarkerFaceColor', 'r');
hold off;