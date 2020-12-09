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
   if y1 - w_size<=0 || y1+w_size > size(im1,1)
      continue; 
   end
   img1_wind =  im1(y1 - w_size:y1+w_size, x1-w_size:x1+w_size, :);
   for x2 = 1 + w_size: size(im2,2) - w_size
       y2 = round((epipolar_line(3) + epipolar_line(1) * x2) / (-epipolar_line(2)));
       if y2 - w_size <= 0 || y2+w_size > size(im2,1)
           continue
       end
       img2_wind = im2(y2-w_size : y2+w_size, x2-w_size:x2+w_size, :);
       dist = sqrt(sum((img1_wind(:) - img2_wind(:)).^2));
       if dist < min
           min = dist;
           pts2(i,:) = [x2, y2];
       end      
   end
end
