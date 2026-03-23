%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Hardik Y. Patil                                                      %
% Email: hardikyp@umich.edu                                                    %
% Date: February 2, 2026                                                       %
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
disp("Loading square unit truss...");
inputStructure = loadSquareUnit();
inputStructureName = "SquareUnit";

% Run analysis
disp("Running analysis...");
[results] = solverALCM(inputStructure, 6500);

% Visualize the results of structural analysis
% plotStructure(results, inputStructureName);
    
% Plot internal vs external energy
plotEnergy(results);

% Plot force vs displacement curve(s) with analytical solution
plotForceDisp(results, results.identity([2 5], 2));
disp("Analysis completed! All files saved.");