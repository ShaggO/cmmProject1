clear all;
close all;
t_stop = 500;
fpses = [10,10];
results = cell(length(fpses),5);
for i = 1:length(fpses)
    [results{i,1}, results{i,2}, results{i,3}, results{i,4}, results{i,5}] = atomicSim(fpses(i),t_stop);
%    [results{i,1}, results{i,2}, results{i,3}] = springSim(fpses(i),t_stop);
end

displaySim(results, fpses);

%diffSim(results, fpses);
