S=load('../data/PnP.mat');
% disp(S);
%     X: [3×30 double]
%       cad: [1×1 struct]
%             vertices: [27392×3 double]
%             faces: [29806×3 double]
%     image: [333×500×3 uint8]
%         x: [2×30 double]
x = S.x;
X = S.X;
cad = S.cad;
img = S.image;
% imshow(img);
% disp(cad);
P = estimate_pose(x, X);
[K, R, t] = estimate_params(P);
X = [X; ones(1,size(X,2))];
% disp(size(R)); % 3 x 3
% disp(size(t)); % 3 x 1
proj_pts = X' * P'; % 30x4 * 4x3 --> 30x3 
proj_pts = proj_pts';
proj_pts = proj_pts ./proj_pts(3,:);
% disp(proj_pts);
proj_pts(3,:) = [];

figure;
imshow(img);
hold on;
plot(x(1,:), x(2,:),'LineStyle', 'none', 'Marker', 'o', 'MarkerSize', 10, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'none');
plot(proj_pts(1,:), proj_pts(2,:), 'LineStyle', 'none', 'Marker', 'o', 'MarkerEdgeColor', 'none', 'MarkerFaceColor', 'r');
hold off;

% disp(cad);
cad_v_t = cad.vertices*R; % 27392×3 * 3x3 --> 27392×3 
cad_f_t = cad.faces*R;
t_mat = eye(4);
t_mat(4,:) = [t' 1];
% disp(t_mat);
cad_v_t = [cad_v_t ones(size(cad_v_t,1), 1)];
cad_f_t = [cad_f_t ones(size(cad_f_t,1), 1)];
cad_v_t = cad_v_t * t_mat; % 27392×4 * x 4x4 
cad_f_t = cad_f_t * t_mat;

cad_v_t = cad_v_t';
cad_v_t = cad_v_t ./ cad_v_t(4,:);
cad_v_t(4,:) = [];
cad_v_t = cad_v_t';


cad_f_t = cad_f_t';
cad_f_t = cad_f_t ./ cad_f_t(4,:);
cad_f_t(4,:) = [];
cad_f_t = cad_f_t';

% disp(size(cad_v_t)); 


cad_x = cad_v_t(:,1);
cad_y = cad_v_t(:,2);
cad_z = cad_v_t(:,3);
tri = delaunay(cad_x, cad_y);

figure;
trimesh(cad.faces, cad_x, cad_y, cad_z, 'edgeColor' , 'black');

figure;
trimesh(cad.faces, cad_x, cad_y, cad_z);


vert = cad.vertices;
vert = [vert ones(size(vert,1), 1)];
% disp(size(vert));
proj_vert = vert * P';
proj_vert = proj_vert';
proj_vert = proj_vert ./proj_vert(3,:);
% disp(proj_pts);
proj_vert(3,:) = []; % proj_vert is now 2x27392

fac = cad.faces;
fac = [fac ones(size(fac,1), 1)];
% disp(size(fac));
proje_fac = fac * P';
proje_fac = proje_fac';
proje_fac = proje_fac ./proje_fac(3,:);
proje_fac(3,:) = []; % proj_vert is now 2x29806
% disp(size(proje_fac));

figure;
imshow(img);
hold on;
patch('Faces', cad.faces, 'Vertices', proj_vert', 'FaceColor', 'green', 'LineStyle', 'none', 'FaceAlpha', 0.25);
% patch(proj_vert(1,:), proj_vert(2,:), 'g', 'LineStyle', 'none');
% patch(cad_x, cad_y, 'g', 'LineStyle', 'none');
hold off;

