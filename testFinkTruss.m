%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Hardik Y. Patil                                                      %
% Email: hardikyp@umich.edu                                                    %
% Date: February 4, 2026                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% This script is to test the behavior of Warren truss from 2026 IJSS paper.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear; close all;
addpath(genpath("core"));
addpath(genpath("post"));
addpath(genpath("solver"));
addpath(genpath("structures"));

% Load test structure
disp("Loading Fink truss...");
inputStructure = loadFinkTruss();
inputStructureName = "FinkTruss";

% Show undeformed structure before analysis
plotUndeformedStructure(inputStructure, inputStructureName);

% Run analysis
disp("Running analysis...");
% [results] = solverMGDCM(inputStructure);
[results] = solverALCM(inputStructure, 23000);

% Visualize the results of structural analysis
plotStructure(results, inputStructureName);
    
% Plot internal vs external energy
plotEnergy(results);

% Plot force vs displacement curve(s) with analytical solution
plotForceDisp(results, results.identity([10], 1));

disp("Analysis completed! All files saved.");