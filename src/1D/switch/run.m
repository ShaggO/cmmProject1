% Clear environment
clear all;
close all;
clc;

% Set up simulation parameters
t_stop = 500;
fpses = [10, 2, 0.15, 30];
results = cell(length(fpses),4);
for i = 1:length(fpses)
    disp(['Simulation: ' num2str(fpses(i))]);
    [results{i,1}, results{i,2}, results{i,3}, results{i,4}] = springSim(fpses(i),t_stop);
end

displaySim(results, fpses);

%diffSim(results, fpses);
