%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Hardik Y. Patil                                                      %
% Email: hardikyp@umich.edu                                                    %
% Date: September 10, 2025                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% This function loads a warren truss structure.
%
% Outputs:
% --------
% params (struct): Loads all structural and analysis parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [params] = loadWarrenTruss()
links = [1, 2;
         1, 4;
         2, 3;
         2, 6;
         3, 4;
         4, 5;
         4, 6;
         5, 7;
         6, 7;
         6, 9;
         7, 8;
         7, 10;
         8, 9;
         9, 10];

springs = [2, 3, 4;
           4, 5, 7;
           7, 8, 9];

coords = [0,      0;
          1.0000, 1.0000;
          1.2883, 0.7025;
          2.0000, 0.0002;
          3.0000, 0.0081;
          3.0000, 1.0002;
          3.9999, 0.0001;
          4.2882, 0.2976;
          5.0000, 1.0001;
          5.9999, 0];

restraint = [1, 1;
             0, 0;
             0, 0;
             0, 0;
             0, 0;
             0, 0;
             0, 0;
             0, 0;
             0, 0;
             0, 1];

force = [0, 0;
         0, 0;
         0, 0;
         0, 0;
         0, 0;
         0, 0;
         0, 0;
         0, 0;
         0, 0;
         -1000, 0];

A = [0.5; 
     0.5;
     0.5;
     0.5; 
     0.5;
     0.5;
     0.5; 
     0.5;
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
     3000000000;
     3000000000;
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
      20];

alpha0 = springInfo(coords, springs);

[nNodes, nDof] = size(restraint);
nBars = size(links, 1);
nSpr = size(springs, 1);

[identity, nFree, reshapeIdx] = numberDOF(restraint, nNodes, nDof);
[mapBars, mapSprings] = generateMapping(identity, links, springs);

idxCtrlU = controlDisplacement(5, 2, identity, nNodes, nDof, nFree);
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