%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot a linear torsional spring constitutive response (no barrier branches).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

% Parameters
k0 = 1;
alpha0 = pi;

% Sample full interval
alpha = linspace(0, 2*pi, 2000);

% Linear spring law
M = k0 .* (alpha - alpha0);
kT = k0 .* ones(size(alpha));
Es = 0.5 * k0 .* (alpha - alpha0).^2;

% Plot
figure('Color', 'w', 'Position', [100, 100, 900, 850]);
tiledlayout(1, 3, 'TileSpacing', 'compact', 'Padding', 'compact');

lineColor = [192, 79, 21] / 255;

nexttile;
plot(alpha, Es, 'LineWidth', 2.5, 'Color', lineColor);
formatAxes(gca, alpha0);
xlabel('\alpha (rad)');
ylabel('Energy, U(\alpha)');
ylim([0, 0.5 * k0 * pi^2]);
yticks([0, 0.25 * k0 * pi^2, 0.5 * k0 * pi^2]);
yticklabels({'$0$', '$\frac{k_0\pi^2}{4}$', '$\frac{k_0\pi^2}{2}$'});
title('Strain Energy');

nexttile;
plot(alpha, M, 'LineWidth', 2.5, 'Color', lineColor);
hold on;
yline(0, '--', 'Color', [0.5, 0.5, 0.5], 'LineWidth', 1.2);
formatAxes(gca, alpha0);
xlabel('\alpha (rad)');
ylabel('Moment, M(\alpha)');
ylim([-k0 * pi, k0 * pi]);
yticks([-k0 * pi, 0, k0 * pi]);
yticklabels({'$-k_0\pi$', '$0$', '$+k_0\pi$'});
title('Restoring Moment');

nexttile;
plot(alpha, kT, 'LineWidth', 2.5, 'Color', lineColor);
hold on;
yline(k0, '--', 'Color', [0.5, 0.5, 0.5], 'LineWidth', 1.2);
formatAxes(gca, alpha0);
xlabel('\alpha (rad)');
ylabel('Stiffness, kT(\alpha)');
ylim([0, 2 * k0]);
yticks([0, k0, 2 * k0]);
yticklabels({'$0$', '$k_0$', '$2k_0$'});
title('Spring Stiffness');

function formatAxes(ax, alpha0)
hold(ax, 'on');
xline(ax, alpha0, '--', 'Color', [0.6, 0.6, 0.6], 'LineWidth', 1.2);
grid(ax, 'on');
box(ax, 'on');
xlim(ax, [0, 2*pi]);
xticks(ax, [0, alpha0, 2*pi]);
xticklabels(ax, {'$0$', '$\alpha_0$', '$2\pi$'});
set(ax, 'FontSize', 14, 'LineWidth', 1.0, 'TickLabelInterpreter', 'latex');
% axis(ax, 'square');
end
