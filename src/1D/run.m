% Clear environment
clear all;
close all;
clc;

% Set up simulation parameters
t_stop = 500;

pP = [-2:1:2];
%[positions, ~, times, ~] = springSim(30, t_stop, pP);
%fi1 = figure();
%
%plot(times, positions);
%hold on;
%axis([0 max(times) min(positions(:)) max(positions(:))]);
%xlabel('Time');
%ylabel('Position');
%
%
%
%%% Atomic:
%fpses =      [10, 10, 30];
%stepBounds = [100, 100, 1];
%rFactors =   [inf,  0.2, inf];
%results = cell(length(fpses),5);
%
%% Perform simulations
%for i = 1:length(fpses)
%    disp(fpses(i));
%    [results{i,1}, results{i,2}, results{i,3}, results{i,4}, results{i,5}] = atomicSim(fpses(i),t_stop,stepBounds(i), rFactors(i));
%end
%
%displaySim(results, fpses);


%% Inverse
fpses =      [10,30];
stepBounds = [1, 1];
rFactors =   [inf, inf];
results = cell(length(fpses),5);

% Perform simulations
for i = 1:length(fpses)
    disp(fpses(i));
    [results{i,1}, results{i,2}, results{i,3}, results{i,4}, results{i,5}] = inverseSim(fpses(i),t_stop,stepBounds(i), rFactors(i));
end
results
displaySim(results, fpses);

return

displaySim(results, fpses);

%% Switch
fpses = [10, 2, 0.15, 30];
results = cell(length(fpses),4);
for i = 1:length(fpses)
    disp(['Simulation: ' num2str(fpses(i))]);
    [results{i,1}, results{i,2}, results{i,3}, results{i,4}] = switchSim(fpses(i),t_stop, false);
end

displaySim(results, fpses);
