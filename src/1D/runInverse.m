clear all;
close all;
clc;
impath = '../../images/';
% Set up simulation parameters
t_stop = 250;
fpses =      [10, 10, 30];
stepBounds = [60, 60, 1];
rFactors =   [inf,  0.2, inf];
results = cell(length(fpses),5);

%% Uniform plots
pP = [-2:2:2];
[positions, ~, times, ~, active, dForces] = inverseSim(2, t_stop, 1, inf);
[positions2, ~, times2, ~, dForces2] = springSim(5, t_stop, pP, 0.3);
[positions3, ~, times3, ~, dForces3] = springSim(2.5, t_stop, pP, 0.3);
fi1 = figure();

plot(times, positions(1,:), '-b','linewidth',2);
hold on;
plot(times2, positions2(1,:),'-r');
plot(times3, positions3(1,:), '-k');
plot(times, positions(2:end,:), '-b','linewidth',2);
plot(times2, positions2(2:end,:), '-r');
plot(times3, positions3(2:end,:), '-k');
%updPoints = find(active);
%plot(times(updPoints),positions(:,updPoints),'xg');
axis([0 max(times) min(positions(:)) max(positions(:))]);
xlabel('Time');
ylabel('Position');
title('Simple simulation');
legend('GEA','Standard (5 fps)','Standard (2.5 fps)','Location','best')

%fi2 = figure();
%plot(times2, dForces2,'-r');
%hold on
%plot(times, dForces, '-b');
%title('Damping forces during simulation');
%legend('Standard','GEA');
%xlabel('Time');
%ylabel('Sum of damping force');
%scaleaxis([times,times2],[dForces,dForces2]);

fi3 = figure();
steps = times(2:end)-times(1:end-1);
steps2 = times2(2:end)-times2(1:end-1);
steps3 = times3(2:end)-times3(1:end-1);
plot(times(1:end-1), steps,'-b');
hold on;
plot(times2(1:end-1), steps2,'-r');
plot(times3(1:end-1), steps3,'-k');
title('Timesteps during simulation');
legend('GEA','Standard (5 fps)','Standard (2.5 fps)','location','best');
xlabel('Time of simulation');
ylabel('Timestep size');
%scaleaxis([times(1:end-1),times2(1:end-1),times3(1:end-1)],[steps,steps2,steps3]);


%% Multi-scale plots
t_stop = 20000;
pP = [-2:0.5:1.99, 2:0.15:2.99, 3:0.5:6.99]';
tic;
[positions, ~, times, ~,~] = inverseSim(2, t_stop,...
    1,inf,@(x)((x.^(0.8)).*1/120)-0.038, pP,0.5);
a = toc
fi4 = figure();
plot(times, positions);
hold on
axis([0 max(times) min(positions(:)) max(positions(:))]);
xlabel('Time');
ylabel('Position');
title('GEA simulation');

fi6 = figure()
tic;
[positions2, ~, times2, ~, dForces2] = springSim(1.8, t_stop);
b = toc
plot(times2, positions2);
axis([0 max(times2) min(positions2(:)) max(positions2(:))]);
xlabel('Time');
ylabel('Position');
title('Standard simulation (1.8 fps)');

fi5 = figure();
steps = times(2:end)-times(1:end-1);
steps2 = times2(2:end)-times2(1:end-1);
plot(times(1:end-1), steps,'-b');
hold on;
plot(times2(1:end-1), steps2,'-r');
title('Timesteps during simulation');
xlabel('Time of simulation');
ylabel('Timestep size');
legend('GEA','Standard (1.8 fps)');

fi7 = figure()
plot(times,1:size(times,2),'-b')
hold on
plot(times2,1:size(times2,2),'-r')
title('Number of steps for simulations');
xlabel('Time');
ylabel('Accumulated number of steps');
legend('GEA','Standard (1.8 fps)','location','best');
scaleaxis([times,times2],[0 size(times,2) size(times2,2)]);

disp(size(times));
disp(size(times2));


%[positions, ~, times, ~,~] = inverseSim(10, t_stop, 68, inf, pP, 0.8, 0.5, 0.5);
%fi5 = figure();
%plot(times, positions);
%hold on
%axis([0 max(times) min(positions(:)) max(positions(:))]);
%xlabel('Time');
%ylabel('Position');
%title('AUH simulation (10 fps, sbound = 68)');

fi = [fi1 fi3 fi4 fi5 fi7];
%fi = [fi1 fi2 fi3];
set(fi, 'PaperPosition', [-0.2 -0.25 6 6]);
set(fi, 'PaperSize', [5.4 5.6]);

saveas(fi1, [impath 'inverse_uniform_30fps'],'pdf');
%saveas(fi2, [impath 'inverse_uniform_30fps_damping'],'pdf');
saveas(fi3, [impath 'inverse_uniform_30fps_steps'],'pdf');
saveas(fi4, [impath 'inverse_multiscale'],'pdf');
saveas(fi5, [impath 'inverse_multiscale_steps'],'pdf');
saveas(fi7, [impath 'inverse_multiscale_cumstep'],'pdf');
