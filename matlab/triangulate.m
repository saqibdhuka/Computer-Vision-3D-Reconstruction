function [pts3d, err] = triangulate(P1, pts1, P2, pts2 )
% triangulate estimate the 3D positions of points from 2d correspondence
%   Args:
%       P1:     projection matrix with shape 3 x 4 for image 1
%       pts1:   coordinates of points with shape N x 2 on image 1
%       P2:     projection matrix with shape 3 x 4 for image 2
%       pts2:   coordinates of points with shape N x 2 on image 2
%
%   Returns:
%       Pts3d:  coordinates of 3D points with shape N x 3
%
[n1, ~] = size(pts1);
[n2, ~] = size(pts2);
pt1 = [pts1'; ones(1, n1)];
pt2 = [pts2'; ones(1, n2)];
% disp(size(pt1)); %3x288 when printed
pts3d = zeros(4, n1);
for i = 1:n1
    r1 = pt1(:, i);
    
    r2 = pt2(:, i);
    x = r1(1);
    y = r1(2);
    x2 = r2(1);
    y2 = r2(2);
    A = [P1(3,:) * y - P1(2,:); ...
         -P1(1,:)  + P1(3,:) * x; ...
         P2(3,:) * y2 - P2(2,:); ...
         -P2(1,:) + P2(3,:) * x2];
    [~,S,V] = svd(A);
    [~,j] = min(diag(S));
    x = V(:,j);
    pts3d(:,i) = x/x(4);
end

pt1_prime = P1 * pts3d;
pt2_prime = P2 * pts3d;

pt1_prime(1,:) = pt1_prime(1,:) ./ pt1_prime(3,:);
pt1_prime(2,:) = pt1_prime(2,:) ./ pt1_prime(3,:);
pt1_prime(3,:) = []; 

pt1_prime = pt1_prime';

pt2_prime(1,:) = pt2_prime(1,:) ./ pt2_prime(3,:);
pt2_prime(2,:) = pt2_prime(2,:) ./ pt2_prime(3,:);
pt2_prime(3,:) = [];

pt2_prime = pt2_prime';

% % disp(pt1_prime);
% disp("pts3d");
% disp(pts3d);
% disp("--------------");
pts3d = pts3d(1:3,:)';
diff1 = pts1 - pt1_prime;
diff2 = pts2 - pt2_prime;
err1 = mean(sqrt(diff1(:,1).^2 + diff1(:,2).^2));
err2 = mean(sqrt(diff2(:,1).^2 + diff2(:,2).^2));
% err = mean(norm(pts1 - pt1_prime) + norm(pts2 - pt2_prime));
err = err1 + err2;

