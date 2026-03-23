%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Hardik Y. Patil                                                      %
% Email: hardikyp@umich.edu                                                    %
% Date: March 19, 2026                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% This function loads a shallow arch with each arm consisting of three parts.
%
% Outputs:
% --------
% params (struct): Loads all structural and analysis parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [params] = loadShallowArchTriBeam()
links = [1, 2;
         2, 3;
         3, 4;
         4, 5;
         5, 6;
         6, 7];

springs = [1, 2, 3;
           2, 3, 4;
           3, 4, 5;
           4, 5, 6;
           5, 6, 7];

coords = [0, 0;
          1, 1.01;
          2, 1.99;
          3, 3;
          4, 1.99;
          5, 1.01;
          6, 0];

restraint = [1, 1;
             0, 0;
             0, 0;
             1, 0;
             0, 0;
             0, 0;
             1, 1];

force = [0, 0;
         0, 0;
         0, 0;
         0, -200;
         0, 0;
         0, 0;
         0, 0];

A = [0.5; 
     0.5;
     0.5;
     0.5; 
     0.5;
     0.5;
     0.5];

E = [3000000000;
     3000000000;
     3000000000;
     3000000000;
     3000000000;
     3000000000;
     3000000000];

[L, theta] = barInfo(coords, links);
L0 = L;
theta0 = theta;

kT = [20;
      20;
      500;
      20;
      20];

alpha0 = springInfo(coords, springs);

[nNodes, nDof] = size(restraint);
nBars = size(links, 1);
nSpr = size(springs, 1);

[identity, nFree, reshapeIdx] = numberDOF(restraint, nNodes, nDof);
[mapBars, mapSprings] = generateMapping(identity, links, springs);

idxCtrlU = controlDisplacement(4, 2, identity, nNodes, nDof, nFree);
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