function [K, R, t] = estimate_params(P)
% ESTIMATE_PARAMS computes the intrinsic K, rotation R and translation t from
% given camera matrix P.
[~, ~, V] = svd(P);
c = V(1:3, end) / V(end,end);
M = P(1:3, 1:3);
[K, R] = rq(M);
D = diag(sign(diag(K)));
K = K * D;
R = D * R;
K = K / K(end,end);
if det(R) < 0
   R = -R; 
end
t = -R * c;

%from https://www.uio.no/studier/emner/matnat/its/nedlagte-emner/UNIK4690/v17/forelesninger/lecture_5_2_pose_from_known_3d_points.pdf
function [R,Q] = rq(M)
[Q,R] = qr(rot90(M,3));
R = rot90(R,2)';
Q = rot90(Q);







