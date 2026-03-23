%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Hardik Y. Patil                                                      %
% Email: hardikyp@umich.edu                                                    %
% Date: March 19, 2026                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function plots the undeformed structure with the applied nodal loads.
% It expects the raw input struct returned by the load*.m files in structures/.
%
% Inputs:
% -------
% params (struct): Input and pre-processed parameters of the structure.
% plotTitle (string): Optional figure title string.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = plotUndeformedStructure(params, plotTitle)
coords = params.coords;
links = params.links;
springs = params.springs;
restraint = params.restraint;
force = params.force;

if nargin < 2 || strlength(string(plotTitle)) == 0
    plotTitle = "Undeformed structure";
else
    plotTitle = string(plotTitle);
end

if isfield(params, 'L0') && ~isempty(params.L0)
    charLength = mean(params.L0);
else
    [L0, ~] = barInfo(coords, links);
    charLength = mean(L0);
end

span = max(max(coords, [], 1) - min(coords, [], 1));
if ~isfinite(charLength) || charLength <= 0
    charLength = max(span, 1);
end

barThickness = 0.065 * charLength;
triSize = 1.2 * barThickness;
plotPad = max(4 * barThickness, 0.15 * max(charLength, span));

fprintf("PLOT: Undeformed structure\n");

fig = figure('Name', char(plotTitle), 'NumberTitle', 'off', 'Color', 'w');
ax = axes('Parent', fig);
axes(ax);
hold(ax, 'on');
axis(ax, 'equal');
axis(ax, 'off');

xlim(ax, [min(coords(:, 1)) - plotPad, max(coords(:, 1)) + plotPad]);
ylim(ax, [min(coords(:, 2)) - plotPad, max(coords(:, 2)) + plotPad]);

for bar = 1:size(links, 1)
    p1 = coords(links(bar, 1), :);
    p2 = coords(links(bar, 2), :);
    drawBar(p1, p2, barThickness);
end

for n = 1:size(coords, 1)
    center = coords(n, :);
    drawNode(center(1), center(2), 0.5 * barThickness);
end

for spr = 1:size(springs, 1)
    drawSpring(springs(spr, :), coords, barThickness);
end

for s = 1:size(restraint, 1)
    if any(restraint(s, :))
        cx = coords(s, 1);
        cy = coords(s, 2);

        if all(restraint(s, :))
            drawFixedSupport(cx, cy, triSize, s, links, coords);
        elseif restraint(s, 2) && ~restraint(s, 1)
            drawRollerSupport(cx, cy, triSize, 'horizontal');
        elseif restraint(s, 1) && ~restraint(s, 2)
            drawRollerSupport(cx, cy, triSize, 'vertical');
        end
    end
end

for n = 1:size(force, 1)
    if any(force(n, :))
        drawArrow(coords(n, :), force(n, :), barThickness);
    end
end

title(ax, char(plotTitle), 'FontName', 'Arial', 'FontWeight', 'normal');
drawnow;
end
