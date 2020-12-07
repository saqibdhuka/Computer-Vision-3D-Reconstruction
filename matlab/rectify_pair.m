function [M1, M2, K1n, K2n, R1n, R2n, t1n, t2n] = ...
                        rectify_pair(K1, K2, R1, R2, t1, t2)
% RECTIFY_PAIR takes left and right camera paramters (K, R, T) and returns left
%   and right rectification matrices (M1, M2) and updated camera parameters. You
%   can test your function using the provided script q4rectify.m

%getting optical camera centres
c1 = -inv((K1*R1)) * (K1 * t1);
c2 = -inv((K2*R2)) * (K2 * t2);

% % camera 1
% % x1 = (c2-c1) / (norm(c2-c1)); % new x-axis for camera 1
% x1 = (c1-c2)/((sum((c1-c2).*(c1-c2)))^0.5);
% y1 = (cross(R1(3,:), x1))'; % new y-axis for camera 1
% %may need to normalize
% % y1 = y1 / (norm(y1));
% z1 = cross(y1,x1); % new z-axis for camera 1
% 
% % camera 2
% x2 = (c1 - c2) / (norm(c1-c2));
% y2 = (cross(R2(3,:), x2))';
% %may need to normalize
% % y2 = y2 / (norm(y2));
% z2 = cross(y2, x2);

% camera 1
% x1 = (c2-c1) / (norm(c2-c1)); % new x-axis for camera 1
r1 = (c1-c2)/norm(c1-c2);
r2 = (cross(R1(3,:), r1))'; % new y-axis for camera 1
r3 = cross(r2,r1); % new z-axis for camera 1


R = [r1 r2 r3]';
R1n = R;
R2n = R;

Kn = K2;
K1n = Kn;
K2n = Kn;

t1n = -R*c1;
t2n = -R*c2;

M1 = (Kn * R) * inv(K1 * R1);
M2 = (Kn * R) * inv(K2 * R2);

