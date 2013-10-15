% Clear environment
clear all;
close all;
clc;

% Set up simulation parameters
t_stop = 500;
fpses =      [10, 10, 30];
stepBounds = [100, 100, 1];
rFactors =   [inf,  0.2, inf];
results = cell(length(fpses),5);

% Perform simulations
for i = 1:length(fpses)
    disp(fpses(i));
    [results{i,1}, results{i,2}, results{i,3}, results{i,4}, results{i,5}] = atomicSim(fpses(i),t_stop,stepBounds(i), rFactors(i));
end

displaySim(results, fpses);

%diffSim(results, fpses);
