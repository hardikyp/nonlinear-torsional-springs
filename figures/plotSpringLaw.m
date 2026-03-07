%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot the enriched torsional spring constitutive response.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

repoRoot = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(repoRoot, 'core'));

% Parameters
k0 = 1;
alpha0 = pi;
delta = deg2rad(20);
alpha1 = deg2rad(45);
alpha2 = 2*pi-alpha1;

% Sample the admissible angle range while staying away from the asymptotes.
epsA = 1e-12;
alpha = linspace(delta + epsA, 2*pi - delta - epsA, 2000);

% Evaluate constitutive law
M = zeros(size(alpha));
kT = zeros(size(alpha));
for i = 1:numel(alpha)
    [kT(i), M(i)] = enrichedSpringLaw(k0, alpha(i), alpha0, alpha1, alpha2, delta);
end
Es = enrichedSpringEnergy(k0, alpha, alpha0, alpha1, alpha2, delta);

% Plot
figure('Color', 'w', 'Position', [100, 100, 900, 850]);
tiledlayout(3, 1, 'TileSpacing', 'compact', 'Padding', 'compact');

xticksVals = [alpha1, alpha0, alpha2];
xtickLabels = {'\alpha_1', '\alpha_0', '\alpha_2'};
lineColor = [0.12, 0.25, 0.70];

nexttile;
plot(alpha, Es, 'LineWidth', 2.5, 'Color', lineColor);
formatAxes(gca, xticksVals, xtickLabels, [delta, 2*pi - delta]);
ylabel('Energy');
xlim([0 2*pi]);
title('Enriched Spring Response');

nexttile;
plot(alpha, M, 'LineWidth', 2.5, 'Color', lineColor);
hold on;
yline(0, '--', 'Color', [0.5, 0.5, 0.5], 'LineWidth', 1.2);
formatAxes(gca, xticksVals, xtickLabels, [delta, 2*pi - delta]);
ylabel('Moment');
xlim([0 2*pi]);
ylim([-5 5]);
yticks([-5, 0, 5]);
yticklabels({'-\infty', '0', '+\infty'});

nexttile;
plot(alpha, kT, 'LineWidth', 2.5, 'Color', lineColor);
hold on;
yline(k0, '--', 'Color', [0.5, 0.5, 0.5], 'LineWidth', 1.2);
formatAxes(gca, xticksVals, xtickLabels, [delta, 2*pi - delta]);
xlabel('\alpha (rad)');
xlim([0 2*pi]);
ylim([0, 5]);
ylabel('Stiffness');
yticks([0, 1, 5]);
yticklabels({'0', 'k_T', '\infty'});

sgtitle(sprintf(['k_0 = %.3g, \\alpha_0 = \\pi, \\delta = 10^\\circ, ', ...
    '\\alpha_1 = 15^\\circ, \\alpha_2 = 345^\\circ'], k0));

function formatAxes(ax, xticksVals, xtickLabels, xBounds)
hold(ax, 'on');
for x = xBounds
    xline(ax, x, '--', 'Color', [0.4, 0.4, 0.4], 'LineWidth', 1.2);
end
for x = xticksVals
    xline(ax, x, '--', 'Color', [0.6, 0.6, 0.6], 'LineWidth', 1.2);
end
grid(ax, 'on');
box(ax, 'on');
xlim(ax, xBounds);
allTicks = [0, xBounds(1), xticksVals, xBounds(2), 2*pi];
allLabels = {'0', '\delta', xtickLabels{:}, '2\pi-\delta', '2\pi'};
xticks(ax, allTicks);
xticklabels(ax, allLabels);
set(ax, 'FontSize', 12, 'LineWidth', 1.0);
end
