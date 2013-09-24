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
pM = ones(cntP,1) * 500;    % Mass of each particle

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
spC = ones(cntS,1) * 0.1;   % Damping
spK = ones(cntS,1) * 0.7;   % Stiffness
spX0 = pP(sp);
spX0 = abs(spX0(:,1) - spX0(:,2));  % Rest length (x0)
spD = ones(cntS,1) * 0.1;   % Viscous drag


% Plot initial particles
figure(1);
plot(pP,ones(1,cntP),'xr');
title('Initial particles');

distance_show = false;
momentum_show = false;

t_start = 0;
t_stop = 100;
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


while time < t_stop

    %% Force calculation
    % Calculate spring lengths
    pP_temp = pP(sp);
    dx = pP_temp(:,1) - pP_temp(:,2);       % start - end: L
    l = abs(pP_temp(:,1) - pP_temp(:,2));   % length l

    pV_temp = pV(sp);                       % velocities
    vx = pV_temp(:,1) - pV_temp(:,2);       % Difference in velocities

    f = -(spC .* vx .* dx ./ l + spK .* (l - spX0) .* dx ./ l) .* dx ./ l;
    if time == 0
        f(end) = f(end) + 0;
    end
    pFfixed = pF(pFixed);
    pF(sp(:,1)) = pF(sp(:,1)) + f;
    pF(sp(:,2)) = pF(sp(:,2)) - f;
    pF(pFixed) = pFfixed;

    % Derivative calculation
    dp = pV;
    dv = pF ./ pM;

    % Position update
    pP = pP + dp * dt;
    pV = pV + dv * dt;
%{
    if mod(time, dt_base) == 0
        % Perform
        disp(['Master step: ' num2str(time)]);
    else
        disp(['Non-master: ' num2str(time)]);
    end
%}
    figure(1);
    plot(pP,ones(1,cntP),'xr');
    title(['Particles at time ' num2str(time)]);
    drawnow;
%    pause(0.01);
    time = time+dt;
end
