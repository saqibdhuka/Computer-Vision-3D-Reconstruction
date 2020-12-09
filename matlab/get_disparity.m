function dispM = get_disparity(im1, im2, maxDisp, windowSize)
% GET_DISPARITY creates a disparity map from a pair of rectified images im1 and
%   im2, given the maximum disparity MAXDISP and the window size WINDOWSIZE.

% 
w = ((windowSize-1)/2);
if mod(windowSize,2) == 0
   w = windowSize/2; 
end
dispM = ones(size(im1));

for x = 1 : size(im1,2)
   for y = 1 : size(im1,1)
      min = 10000;
      if y-w <= 0 || y+w > size(im1,1) || x-w <= 0 || x + w > size(im1,2)
          continue;
      end
      img1 = im1(y - w : y + w, x - w : x + w);
      for d = 0:maxDisp
         if y-w <= 0 || y+w > size(im2,1) || x-w-d <= 0 || x + w-d > size(im2,2)
          continue;
         end 
         img2 = im2(y - w : y + w, x - w - d : x + w - d);
         dist = sum((img1 - img2).^2);
%          x = [x, dist];
         if dist < min
             min = dist;
             dispM(y,x) = d;
         end
      end
   end
end