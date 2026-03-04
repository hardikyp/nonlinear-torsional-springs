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

function Es = enrichedSpringEnergy(k0, alpha, alpha0, alpha1, alpha2, delta)

if ~(0 <= delta && delta < alpha1 && alpha1 < alpha2 && alpha2 < 2*pi-delta)
    error('Require 0 <= delta < alpha1 < alpha2 < 2*pi-delta');
end

% Match spring law safeguard
if delta > 0
    epsA = 1e-12;
    alpha = min(max(alpha, delta + epsA), 2*pi - delta - epsA);
end

if isscalar(alpha1), alpha1 = alpha1*ones(size(alpha)); end
if isscalar(alpha2), alpha2 = alpha2*ones(size(alpha)); end
if isscalar(alpha0), alpha0 = alpha0*ones(size(alpha)); end
if isscalar(k0),     k0     = k0    *ones(size(alpha)); end

Es = zeros(size(alpha));
Lidx = alpha < alpha1;
Midx = alpha >= alpha1 & alpha <= alpha2;
Ridx = alpha > alpha2;

% Updated to include delta (shifted asymptotes)
pl = pi ./ (alpha1 - delta);
pr = pi ./ ((2*pi - delta) - alpha2);

% Left branch
Es(Lidx) = 0.5*k0(Lidx).*(alpha0(Lidx)-alpha1(Lidx)).^2 + ...
           k0(Lidx).*(alpha0(Lidx)-alpha1(Lidx)).*(alpha1(Lidx)-alpha(Lidx)) - ...
           4*k0(Lidx)./pl(Lidx).^2 .* ...
           log(abs(cos(pl(Lidx)/2 .* (alpha1(Lidx)-alpha(Lidx)))));

% Middle branch
Es(Midx) = 0.5*k0(Midx).*(alpha(Midx)-alpha0(Midx)).^2;

% Right branch
Es(Ridx) = 0.5*k0(Ridx).*(alpha2(Ridx)-alpha0(Ridx)).^2 + ...
           k0(Ridx).*(alpha2(Ridx)-alpha0(Ridx)).*(alpha(Ridx)-alpha2(Ridx)) - ...
           4*k0(Ridx)./pr(Ridx).^2 .* ...
           log(abs(cos(pr(Ridx)/2 .* (alpha(Ridx)-alpha2(Ridx)))));
end