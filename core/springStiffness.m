%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Hardik Y. Patil                                                      %
% Email: hardikyp@umich.edu                                                    %
% Date: October 19, 2025                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% This function generates the stiffness matrix for a three-node torsional 
% spring element. The function also calculates the internal nodal forces due to
% the deformation of spring elements.
% 
% Inputs:
% -------
% springs (array): Nodes forming each three-node spring element (1, 3)
% kT (float): Rotational spring stiffness for each spring
% coords (array): Nodal coordinates of the structure in current iteration 
%                 (nNodes, 2)
%
% Outputs:
% --------
% kSpring (array): Stiffness matrix of a three-node torsional spring
%                  element (6, 6)
% intF (array): Total internal nodal force vector for each spring element (6, 1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [kSpring, intF] = springStiffness(springs, kT, coords, alpha0)
r1 = coords(springs(1, 1), :)'; 
r2 = coords(springs(1, 2), :)'; 
r3 = coords(springs(1, 3), :)';
a = r1 - r2;
b = r3 - r2;
L1 = norm(a);
L2 = norm(b);
N = [0 -1; 1 0];
C = dot(a, b);
S = a' * N * b;
alpha = mod(atan2(S, C) + 2 * pi, 2 * pi);

% Gradient and hessian of alpha
J = gradientAlpha(a, b, N, L1, L2);
H = hessianAlpha(a, b, N, L1, L2);

% Internal force
M = kT * (alpha - alpha0);
intF = M * J;

% Spring stiffness matrix
kSpring = kT * (J * J') + M * H;
end