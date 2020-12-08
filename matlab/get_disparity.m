function dispM = get_disparity(im1, im2, maxDisp, windowSize)
% GET_DISPARITY creates a disparity map from a pair of rectified images im1 and
%   im2, given the maximum disparity MAXDISP and the window size WINDOWSIZE.

% 
mask = ones(windowSize, windowSize);
w = (windowSize-1)/2;
[n,c] = size(im1);
dispar = zeros(size(im1,1), size(im1,2));
temp = zeros(n,c);

for d = 0:maxDisp
   index = 1:(n * (c - d));
   temp(index) = (im1(index + n * d) - im2(index)).^2;
   dispar(:,:,d+1) = conv2(temp, mask, 'same');
end

[~, idx] = min(dispar, [], 3);
dispM = idx - 1;

% for x = 1 : size(im1,2)
%    for y = 1 : size(im1,1)
%       min = 10000;
%       if y-w <= 0 || y+w > size(im1,1) || x-w <= 0 || x + w > size(im1,2)
%           continue;
%       end
%       img1 = im1(y - w : y + w, x - w : x + w);
%      
%       for d = 0:maxDisp
%          if y-w <= 0 || y+w > size(im2,1) || x-w-d <= 0 || x + w-d > size(im2,2)
%           continue;
%          end 
%          img2 = im2(y - w : y + w, x - w - d : x + w - d);
%          dist = sum (double((img1 - img2)).^2);
% %          x = [x, dist];
%          if dist < min
%              min = dist;
%              dispM(y,x) = d;
%          end
%       end
%       
%    end
% end