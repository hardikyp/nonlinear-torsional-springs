 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Hardik Y. Patil                                                      %
% Email: hardikyp@umich.edu                                                    %
% Date: January 29, 2026                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% This function loads a square unit.
%
% Outputs:
% --------
% params (struct): Loads all structural and analysis parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [params] = loadSquareUnit()
links = [1, 2;
         1, 3;
         1, 4;
         2, 5;
         3, 5;
         4, 5];

springs = [1, 3, 5];

coords = [0,       0;
          -0.0083, 1;
          0.5417,  0.4545;
          1,       0;
          0.9917,  1];

restraint = [1, 1;
             0, 0;
             0, 0;
             0, 1;
             0, 0];

force = [0, 0;
         0, -10000;
         0, 0;
         0, 0;
         0, -10000];

A = [0.5;
     0.5;
     0.5;
     0.5;
     0.5; 
     0.5];

E = [3000000;
     3000000;
     3000000;
     3000000;
     3000000;
     3000000];

[L, theta] = barInfo(coords, links);
L0 = L;
theta0 = theta;

kT = [10];
alpha0 = springInfo(coords, springs);

[nNodes, nDof] = size(restraint);
nBars = size(links, 1);
nSpr = size(springs, 1);

[identity, nFree, reshapeIdx] = numberDOF(restraint, nNodes, nDof);
[mapBars, mapSprings] = generateMapping(identity, links, springs);

idxCtrlU = controlDisplacement(1, 1, identity, nNodes, nDof, nFree);
deltaU = 1.5;

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