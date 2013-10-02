clear all;
close all;

% Create grid of particles at positions
pP = [-2:0.5:1.99, 2:0.15:2.99, 3:0.5:6.99]';
pP = [-2:1:2];
if size(pP,2) > size(pP,1)
    pP = pP';
end
cntP = size(pP,1);

% Set up initial measurements for each particle
pV = zeros(cntP,1);         % Initial velocities
pF = zeros(cntP,1);         % Force at time t
pM = ones(cntP,1) * 30;    % Mass of each particle

% Fix the left-most point
% Find left side
val = min(pP);
pFixed = find(pP == val);

% Register all springs
% Springs between all inner particles (indices)
sp = [1:cntP]';
sp = [sp(1:end-1),sp(2:end)];
cntS = size(sp,1);

% Set up initial measurements for each spring
spC = ones(cntS,1) * 0.5;   % Damping
spK = ones(cntS,1) * 0.5;   % Stiffness
spX0 = pP(sp);
spX0 = abs(spX0(:,1) - spX0(:,2)) * 0.8;
spD = ones(cntS,1) * 0.1;   % Viscous drag


% Plot initial particles
figure(1);
plot(pP,ones(1,cntP),'xr');
title('Initial particles');

distance_show = false;
momentum_show = false;

t_start = 0;
t_stop = 500;
fps_lowest = 30;
dt_base = 1 / fps_lowest;
dt = dt_base;

valMax = max(pP);
rind = find(pP == valMax);

% External force:
f_ext = 0;

% Initial time
time = 0;
explicit = true;
h = 1;

positions = [];
lengths = [];
times = [];
dx = zeros(cntS,1);
while time <= t_stop
    f = zeros(cntS,1);
    pF = zeros(cntP,1);
    for s = 1:cntS
        from = sp(s,1);
        to = sp(s,2);

        dx(s) = pP(from) - pP(to);
        l = abs(dx(s));
        spL(s) = dx(s);

        dv = pV(from) - pV(to);
        f = spK(1) * (l - spX0(s));
        f = f + spC(1) * dv * dx(s) / l;
        f = f * (- dx(s) / l);
        pF(from) = pF(from) + f;
        pF(to) = pF(to) - f;
    end


    % Derivative calculation
    dv = pF ./ pM;
%
    % Position update
    pP = pP + pV * dt;
    pV = pV + dv * dt;
    positions(:,end+1) = pP;
    lengths(:,end+1) = -dx;
    times(end+1) = time;
%{
    if mod(time, dt_base) == 0
        % Perform
        disp(['Master step: ' num2str(time)]);
    else
        disp(['Non-master: ' num2str(time)]);
    end
%}
%    figure(1);
%    s1 = subplot(1,1,1);
%    plot(pP,zeros(1,cntP),'xr');
%    axis([-4 4 -0.5 0.5]);
%    title(s1, ['Particles at time ' num2str(time)]);
%    subplot(2,1,2);
%    plot(1:cntS,spX0,'ob');
%    hold on;
%    plot(time, spL(1),'.r');
%    plot(time, spL(2),'.b');
%    disp(spL);
%    axis([0, t_stop, -3, 3]);
%%    hold off;
%    drawnow;
    time = time+dt;
end

figure(1);
plot(times,lengths);

figure(2);
plot(times,positions);

figure(3);
y_values = zeros(size(positions,1),1);
plot(positions(:,1),y_values,'x');
set(gca,'NextPlot','replaceChildren');
for i=1:length(times)
    plot(positions(:,i),y_values,'xr');
    hold on;
    title(['Time frame: ' num2str(times(i))]);
%    drawnow;
    hold off;
%    pause(0.1);
    F(i) = getframe;
end
figure(4);
movie(F,1,fps_lowest);
