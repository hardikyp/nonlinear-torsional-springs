%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Hardik Y. Patil                                                      %
% Email: hardikyp@umich.edu                                                    %
% Date: March 20, 2026                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% This script is to test the behavior of 2 square, stacked 6-bar linkage units 
% fitted with torsional springs and loaded in vertically downward direction.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear; close all;
addpath(genpath("core"));
addpath(genpath("post"));
addpath(genpath("solver"));
addpath(genpath("structures"));

% Load test structure
disp("Loading square truss grid...");
inputStructure = loadGrid();
inputStructureName = "Grid";

% Show undeformed structure before analysis
plotUndeformedStructure(inputStructure, inputStructureName);

% Run analysis
disp("Running analysis...");
% [results] = solverMGDCM(inputStructure);
[results] = solverALCM(inputStructure, 15000); % 17500 unguided, 11000 guided

% Visualize the results of structural analysis
plotStructure(results, inputStructureName);
    
% Plot internal vs external energy
plotEnergy(results);

% Plot force vs displacement curve(s) with analytical solution
plotForceDisp(results, results.identity([3 13], 2));

disp("Analysis completed! All files saved.");