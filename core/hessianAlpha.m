%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Hardik Y. Patil                                                      %
% Email: hardikyp@umich.edu                                                    %
% Date: February 26, 2026                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% This function outputs the hessian of the relative angle alpha for the three
% node torsional spring element.
% 
% Inputs:
% -------
% a (array): Vector along bar 1 of the torsional spring (2, 1)
% b (array): Vector along bar 2 of the torsional spring (2, 1) 
% N (array): Counterclockwise 90 deg rotation matrix (2, 2)
% L1 (float): Length of bar 1
% L2 (float): Length of bar 2
%
% Outputs:
% --------
% H (array): Hessian of the relative angle alpha (6, 6)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [H] = hessianAlpha(a, b, N, L1, L2)
H11 = (1 / L1^2) * N - (2 / L1^4) * (N * a) * a';
H12 = - H11;
H13 = zeros(2, 2);
H23 = (1 / L2^2) * N - (2 / L2^4) * (N * b) * b';
H33 = - H23;
H22 = H11 + H33;
H = [H11,  H12,  H13;
     H12', H22,  H23;
     H13', H23', H33];
end