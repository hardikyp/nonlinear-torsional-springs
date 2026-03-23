clc; clear; close all;

a = 0.5;
b = 0.5;
c = 1;
d = 1;
x = 1;
y = 1;
theta2 = deg2rad(59);

A = [0, 0];
D = A + [d, 0];
B = A + a * [cos(theta2), sin(theta2)];


r = d - a * cos(theta2);
s = a * sin(theta2);

delta = acos((b^2 + c^2 - r^2 - s^2) / (2 * b * c));

h = c * sin(delta);
g = b - c * cos(delta);

theta3 = atan2(h*r - g*s, g*r + h*s);
theta4 = theta3 + delta;
C = D + c * [cos(theta4), sin(theta4)];

initGuessE = [0, 1];
fun = @(P) [(P(1) - A(1))^2 + (P(2) - A(2))^2 - x^2;
            (P(1) - C(1))^2 + (P(2) - C(2))^2 - y^2];
options = optimoptions('fsolve', 'Display', 'none');  % Suppress output from fsolve
PSol = fsolve(fun, initGuessE, options);
E = [PSol(1), PSol(2)];
pts = [A;E;B;D;C];

% % Stacked Asym
% pts1 = pts + [E]
% 
% % Stacked sym
% pts2 = [-pts(:, 1), pts(:, 2)] + [pts(4, 1), 0] + E

% Warren truss
ptsf = [-pts(:, 1), pts(:, 2)] + D;
pts1 = ptsf([4,5,3,1,2],:);
pts2 = [pts([2,1,3,5,4],:) - [E(1), 0] + [pts1(5,1), 0]];


final = [pts1;pts2(2:end, :)];

plot(final(:,1),final(:,2), 'o');
axis equal;
printMatrix2Col(final);

function printMatrix2Col(A)
%PRINTMATRIX2COL Print an n-by-2 matrix in MATLAB row format.
%
% Example output:
% [0, 0;
%  0.5, 0.866025403784439;
%  1, 0]

    if ~ismatrix(A) || size(A,2) ~= 2
        error('Input must be an n-by-2 matrix.');
    end

    fprintf('[');
    for i = 1:size(A,1)
        if i == 1
            fprintf('%g, %g', A(i,1), A(i,2));
        else
            fprintf(';\n %g, %g', A(i,1), A(i,2));
        end
    end
    fprintf('];\n');
end