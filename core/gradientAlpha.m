%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Hardik Y. Patil                                                      %
% Email: hardikyp@umich.edu                                                    %
% Date: February 26, 2026                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% This function outputs the gradient of the relative angle alpha for the three
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
% J (array): Gradient of the relative angle alpha (6, 1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [J] = gradientAlpha(a, b, N, L1, L2)
J11 = N * a / L1^2;
J21 = N * b / L2^2 - N * a / L1^2;
J31 = -N * b / L2^2;
J = [J11; J21; J31];
end