%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Hardik Y. Patil                                                      %
% Email: hardikyp@umich.edu                                                    %
% Date: January 29, 2026                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% This script is to test the torsional spring unit's energy storage capacity in
% the elastic buckling of a shallow arch problem.  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear; close all;
addpath(genpath("core"));
addpath(genpath("post"));
addpath(genpath("solver"));
addpath(genpath("structures"));

% Load test structure
disp("Loading shallow arch truss...");
inputStructure = loadShallowArch();
inputStructureName = "ShallowArch";

% Run displacement controlled analysis
disp("Running elastic second order analysis using displacement controlled algorithm (Arc-length)...");
% [results] = solverLCM(inputStructure);
% [results] = solverDCM(inputStructure);
% [results] = solverALCM(inputStructure);
% [results] = solverGDCM(inputStructure);
[results] = solverAL_GDCM(inputStructure);

% Visualize the results of structural analysis
% plotStructure(results, inputStructureName);

% Plot internal vs external energy
plotEnergy(results);

% Plot force vs displacement curve(s) with analytical solution
plotForceDisp(results);

disp("Analysis completed! All files saved.");