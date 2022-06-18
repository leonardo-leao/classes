%%============================================================================
%%                    Main Code
%%============================================================================
clc
clear all
close all

RA = 217276;
feature('DefaultCharacterSet','UTF-8')

%   1DOF Forced Vibration Vibration System with Viscous Damping
%   mddx + cdx + kx = f e^(iwt)
m   = 1;    % mass
c   = 1;    % dampling coeficient
k   = 1;    % elastic coeficient
f   = 1;    % force magnitude
step= 0.01; % step of 

wn  = sqrt(k/m);        % natural frequency
phi = c / (2 * wn * m); % damping coeficient



% %%============================================================================
% %%                    Exercices
% %%============================================================================

ex2(step, 1, 1, 1);
ex3(step, 1, 1, 1);
ex4(step, 1, 1, 1);
ex5(step, 1, 1, 1);
ex6(step, 1, 5, 100);
ex7(step, 10, 5, 100);
ex8(step, 1, 1, 1);
ex9(step, 1, 1, 1);
ex10(step, 1, 1, 1);
ex15(1, 1, 1);