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
[n, ~] = size(pts1);
pts2 = [];
for i = 1 : n
    x1 = pts1(i,1);
    y1 = pts1(i,2);
    p1 = [x1; y1; 1]; 
%     disp(p1);  %3x1  
    l1 = F * p1;
    scale = sqrt(l1(1)^2 + l1(2)^2);
    l1 = l1/scale;
    
    l2 = [-l1(2) l1(1) l1(2)*x1-l1(1)*y1];
    projection = round(cross(l1,l2));
    
    w_size = 20;
    k_size = 2*w_size + 1;
    p1 = double(im1((y1-w_size):(y1+w_size), (x1-w_size):(x1+w_size)));
    min = 1000;
    sigma = 7;
    w = fspecial('gaussian', [k_size k_size], sigma);
    x2 = 1;
    y2 = 2;
    for i = projection(1)-20:1:projection(1)+20
        for j =projection(2)-20:1:projection(2)+20 
            p2 = double(im2(j-w_size:j+w_size,i-w_size:i+w_size));
            dist = p1 - p2;
            err = norm(w .* dist);
            if err < min
               min = err;
               x2 = i;
               y2 = j;
            end
        end 
    end
   pts2 = [pts2; [x2 y2]]; 
end
