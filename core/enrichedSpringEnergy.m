%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Hardik Y. Patil                                                      %
% Email: hardikyp@umich.edu                                                    %
% Date: February 26, 2026                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function computes the strain energy stored in three-node torsional
% springs using the enhanced nonlinear constitutive law (piecewise linear +
% tan-barrier branches). Unlike the linear model (0.5*kT*(alpha-alpha0)^2),
% this function evaluates the spring potential consistently with the
% enhanced moment law so that:
%   (i) dU/dalpha = M(alpha), and
%   (ii) tangent stiffness k_t(alpha) = dM/dalpha.
%
% The formulation supports the full rotation range alpha in [0, 2*pi), with
% transition angles alpha1 and alpha2 defining the central linear region.
% As alpha approaches 0 or 2*pi, the barrier branches increase stiffness
% sharply to discourage over-rotation and local panel/joint penetration.
%
% Inputs:
% -------
% k0     (scalar or vector): Base spring stiffness parameter.
% alpha  (vector): Current spring angles (rad), one value per spring.
% alpha0 (vector): Reference/rest spring angles (rad), same size as alpha.
% alpha1 (scalar or vector): Lower transition angle (rad), 0 < alpha1 < pi.
% alpha2 (scalar or vector): Upper transition angle (rad), pi < alpha2 < 2*pi.
%
% Outputs:
% --------
% Es (vector): Spring strain energy per spring, evaluated at alpha.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Es = enrichedSpringEnergy(k0, alpha, alpha0, alpha1, alpha2)

if isscalar(alpha1), alpha1 = alpha1*ones(size(alpha)); end
if isscalar(alpha2), alpha2 = alpha2*ones(size(alpha)); end
if isscalar(k0),  k0  = k0 *ones(size(alpha)); end

Es = zeros(size(alpha));
L = alpha < alpha1;
M = alpha >= alpha1 & alpha <= alpha2;
R = alpha > alpha2;
pl = pi./alpha1;
pr = pi./(2*pi - alpha2);
% Left branch
Es(L) = 0.5*k0(L).*(alpha0(L)-alpha1(L)).^2 + ...
        k0(L).*(alpha0(L)-alpha1(L)).*(alpha1(L)-alpha(L)) - ...
        4*k0(L)./pl(L).^2 .* log(abs(cos(pl(L)/2 .* (alpha1(L)-alpha(L)))));

% Middle branch
Es(M) = 0.5*k0(M).*(alpha(M)-alpha0(M)).^2;

% Right branch
Es(R) = 0.5*k0(R).*(alpha2(R)-alpha0(R)).^2 + ...
        k0(R).*(alpha2(R)-alpha0(R)).*(alpha(R)-alpha2(R)) - ...
        4*k0(R)./pr(R).^2 .* log(abs(cos(pr(R)/2 .* (alpha(R)-alpha2(R)))));
end
