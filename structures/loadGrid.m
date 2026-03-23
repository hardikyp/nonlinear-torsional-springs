 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Hardik Y. Patil                                                      %
% Email: hardikyp@umich.edu                                                    %
% Date: March 20, 2026                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% This function loads a 2-level grid of square units.
%
% Outputs:
% --------
% params (struct): Loads all structural and analysis parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [params] = loadGrid()
links = [1, 2;
         1, 4;
         1, 6;
         2, 3;
         2, 5;
         2, 7;
         3, 8;
         4, 7;
         5, 8;
         6, 7;
         6, 9;
         6, 11;
         7, 8;
         7, 10;
         7, 12;
         8, 13;
         9, 12;
         10, 13;
         11, 12;
         12, 13];

springs = [1, 4, 7;
           2, 5, 8;
           6, 9, 12;
           7, 10, 13];

coords = [0,       0;
          -0.0083, 1;
          -0.0167, 1.9999;
          0.5417,  0.4545;
          0.5333,  1.4545;
          1,       0;
          0.9917,  1;
          0.9833,  1.9999;
          1.5417,  0.4545;
          1.5333,  1.4545;
          2,       0;
          1.9917,  1;
          1.9833,  1.9999];

restraint = [1, 1;
             0, 0;
             0, 0;
             0, 0;
             0, 0;
             1, 1;
             0, 0;
             0, 0;
             0, 0;
             0, 0;
             1, 1;
             0, 0;
             0, 0];

force = [0, 0;
         0, 0;
         0, -2000;
         0, 0;
         0, 0;
         0, 0;
         0, 0;
         0, 0;
         0, 0;
         0, 0;
         0, 0;
         0, 0;
         0, -2000];

A = 0.5 * ones(size(links, 1), 1);

E = 3000000000 * ones(size(links, 1), 1);

[L, theta] = barInfo(coords, links);
L0 = L;
theta0 = theta;

kT = [9.5;
      10;
      9.5;
      10];

alpha0 = springInfo(coords, springs);

[nNodes, nDof] = size(restraint);
nBars = size(links, 1);
nSpr = size(springs, 1);

[identity, nFree, reshapeIdx] = numberDOF(restraint, nNodes, nDof);
[mapBars, mapSprings] = generateMapping(identity, links, springs);

idxCtrlU = controlDisplacement(3, 2, identity, nNodes, nDof, nFree);
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