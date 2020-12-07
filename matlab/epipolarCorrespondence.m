function [pts2] = epipolarCorrespondence(im1, im2, F, pts1)
% epipolarCorrespondence:
%   Args:
%       im1:    Image 1
%       im2:    Image 2
%       F:      Fundamental Matrix from im1 to im2
%       pts1:   coordinates of points in image 1
%   Returns:
%       pts2:   coordinates of points in image 2
%

im1 = double(im1);
im2 = double(im2);
n = size(pts1,1);
w_size = 5;
pts2 = zeros(n , 2);

for i = 1:n
   epipolar_line = F * [pts1(i,:), 1]';
   x1 = round(pts1(i,1));
   y1 = round(pts1(i,2));
   min = 10000;
   img1_wind =  im1(y1 - w_size:y1+w_size, x1-w_size:x1+w_size, :);
   for x2 = 1 + w_size: size(im2,2) - w_size
       y2 = round((epipolar_line(3) + epipolar_line(1) * x2) / (-epipolar_line(2)));
       if y2 - w_size <= 0 || y2+w_size > size(im2,1)
           continue
       end
%        disp(y2);
%        disp(x2);
       img2_wind = im2(y2-w_size : y2+w_size, x2-w_size:x2+w_size, :);
       dist = sqrt(sum((img1_wind(:) - img2_wind(:)).^2));
       if dist < min
           min = dist;
           pts2(i,:) = [x2, y2];
       end      
   end
end










% [n,c] = size(pts1);
% [width, ~] = size(im1);
% disp(n);
% disp(c);
% p1 = [pts1, ones(n, 1)]';
% disp(size(p1));
% %l1 = F *p1;
% l1 = p1' * F;
% l1 = l1';
% pts2 = [];
% for i = 1 : n
%    curr_line = l1(:,i); 
%    a = curr_line (1,:);
%    b = curr_line (2,:);
%    c = curr_line (3,:);
% %    eqn = (-a*x-c)/b ==y;
%    best_pt =[];
%    max = 0;
%    pt1 = pts1(i,:)';
%    for xval = 1:width
% %       soly = solve(eqn, 1);
%       y = (-a*1-c)/b;
%       pt2 = [1, y]';
% %       disp(pt2);
% %       disp(pt1);
%       X = [pt1'; pt2'];
% %       disp(X);
% %       d = pdist(X, 'cityblock');
%       d = pdist2(pt1', pt2', 'euclidean');
% %       d = sum(abs(bsxfun(@minus,pt1',pt2')),2);
% %       disp(d);
%       if(d > max)
%          max = d;
%          best_pt = pt2';
%       end
%    end
%    pts2 = [pts2; best_pt];
% end
