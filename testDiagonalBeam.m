%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Hardik Y. Patil                                                      %
% Email: hardikyp@umich.edu                                                    %
% Date: March 18, 2026                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% This script is to test the torsional spring unit's energy storage capacity
% in a square 6-bar linkage unit. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear; close all;
addpath(genpath("core"));
addpath(genpath("post"));
addpath(genpath("solver"));
addpath(genpath("structures"));

% Load test structure
disp("Loading diagonal beam...");
inputStructure = loadDiagonalBeam();
inputStructureName = "DiagonalBeam";

% Run analysis
disp("Running analysis...");
[results] = solverALCM(inputStructure, 16000);

% Visualize the results of structural analysis
plotStructure(results, inputStructureName);
    
% Plot internal vs external energy
plotEnergy(results);

% Plot force vs displacement curve(s) with analytical solution
plotForceDisp(results, results.identity([4], 2));
disp("Analysis completed! All files saved.");