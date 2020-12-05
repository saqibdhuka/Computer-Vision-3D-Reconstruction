function N = getNorm(x, M)


centroid = mean(x,2);

% dist = sqrt(sum((x - repmat(centroid, 1, size(x,2))) .^2, 1));
% 
% dist_mean = mean(dist);
% 
% scale = sqrt(2)/dist_mean;

N = [1/M, 0, 0;
     0, 1/M, 0;
     0, 0, 1];

end