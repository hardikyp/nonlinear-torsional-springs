%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Hardik Y. Patil                                                      %
% Email: hardikyp@umich.edu                                                    %
% Date: March 18, 2026                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% This script is to test the shallow arch truss with each arm consisting of 
% three parts. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear; close all;
addpath(genpath("core"));
addpath(genpath("post"));
addpath(genpath("solver"));
addpath(genpath("structures"));

% Load test structure
disp("Loading diagonal beam...");
inputStructure = loadShallowArchTriBeam();
inputStructureName = "ShallowArchTriBeam";

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