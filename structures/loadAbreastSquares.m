%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Hardik Y. Patil                                                      %
% Email: hardikyp@umich.edu                                                    %
% Date: March 18, 2026                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% This function loads abreast square units.
%
% Outputs:
% --------
% params (struct): Loads all structural and analysis parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [params] = loadAbreastSquares()
links = [1, 2;
         1, 3;
         1, 4;
         2, 5;
         3, 5;
         4, 5;
         4, 6;
         4, 7;
         5, 8;
         6, 8;
         7, 8;
         7, 9;
         7, 10;
         8, 11;
         9, 11;
         10, 11];

springs = [1, 3, 5;
           4, 6, 8;
           7, 9, 11];

coords = [0,       0;
          -0.0083, 1;
          0.5417,  0.4545;
          1,       0;
          0.9917,  1;
          1.5417,  0.4545;
          2,       0;
          1.9917,  1;
          2.5417,  0.4545;
          3,       0;
          2.9917,  1];

restraint = [1, 1;
             0, 0;
             0, 0;
             0, 1;
             0, 0;
             0, 0;
             0, 1;
             0, 0;
             0, 0;
             1, 1;
             0, 0];

force = [0, 0;
         0, -2000;
         0, 0;
         0, 0;
         0, -2000;
         0, 0;
         0, 0;
         0, -2000;
         0, 0;
         0, 0;
         0, -2000];

A = 0.5 * ones(size(links, 1), 1);

E = 3000000000 * ones(size(links, 1), 1);

[L, theta] = barInfo(coords, links);
L0 = L;
theta0 = theta;

kT = [20;
      20;
      20];

alpha0 = springInfo(coords, springs);

[nNodes, nDof] = size(restraint);
nBars = size(links, 1);
nSpr = size(springs, 1);

[identity, nFree, reshapeIdx] = numberDOF(restraint, nNodes, nDof);
[mapBars, mapSprings] = generateMapping(identity, links, springs);

idxCtrlU = controlDisplacement(2, 2, identity, nNodes, nDof, nFree);
deltaU = 1;

params = struct('links', links, ...
                'springs', springs, ...
                'coords', coords, ...
                'restraint', restraint, ...
                'force', force, ...
                'A', A, ...
                'E', E, ...
                'L', L, ...
                'L0', L0, ...
                'theta', theta, ...
                'theta0', theta0, ...
                'kT', kT, ...
                'alpha0', alpha0, ...
                'identity', identity, ...
                'nNodes', nNodes, ...
                'nDof', nDof, ...
                'nBars', nBars, ...
                'nSpr', nSpr, ...
                'nFree', nFree, ...
                'reshapeIdx', reshapeIdx, ...
                'mapBars', mapBars, ...
                'mapSprings', mapSprings, ...
                'idxCtrlU', idxCtrlU, ...
                'deltaU', deltaU);
end