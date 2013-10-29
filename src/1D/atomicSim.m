function [positions, lengths, times, switches, active] = springSim(fps, t_stop, stepBound, rFactor, pP)
    %% Initialize particles
    if nargin < 5
        % Create grid of particles at positions
        %pP = [-2:0.5:1.99, 2:0.15:2.99, 3:0.5:6.99]';
        pP = [-2:2:2]';
    end

    % Initialize variables
    cntP = size(pP,1);
    positions = [];
    lengths = [];
    times = [];
    switches = [];
    active = [];

    % Set up initial measurements for each particle
    pV = zeros(cntP,1);         % Initial velocities
    pF = zeros(cntP,1);         % Force at time t
    pM = ones(cntP,1) * 30;     % Mass of each particle

    %% Register springs
    % Springs between all inner particles (indices)
    sp = [1:cntP]';
    sp = [sp(1:end-1),sp(2:end)];
    cntS = size(sp,1);

    % Set up initial measurements for each spring
    spC = ones(cntS,1) * 0.01;   % Damping
    spK = ones(cntS,1) * 0.5;   % Stiffness
    spX0 = pP(sp);
    spX0 = abs(spX0(:,1) - spX0(:,2)) * 0.6;
    spL = springLength(pP,sp);  % Length at last update
    spSteps = zeros(cntS,1);    % Number of steps since last update

    % Initial time
    dt_base = 1 / fps;
    dt = dt_base;
    time = 0;

    dx = zeros(cntS,1);
    pF = zeros(cntP,2);

    % Loop simulation over time
    while time <= t_stop + dt/2;

        % Find active particles pA and active springs spA
        [pA spA spL spSteps_new] = registerActive(pP, sp, spL, pV, time, dt,...
                                                 rFactor, spSteps, stepBound,...
                                                 spX0);
        active(end+1) = length(spA);

        % Force calculation of active springs/particles
        [pF dx] = springForces(pP, sp(spA,:), pV,...
                                   spK(spA), spX0(spA), spC(spA));

        % Position and velocity update
        [dp dv] = springStep(pP, pM, pV, sum(pF,2), dt, pA, sp, spSteps);
        % Detect collisions / switches in position
        l = springLength(pP + dp, sp);
        l2 = springLength(pP, sp);
        mask = l .* l2 < 0;
        if any(mask)
            disp('Switch in next iteration!');
            disp(time);
            pSub = unique(sp(mask,:));
            cnt = size(pSub,1);
%            switches(end+1:end+cnt,:) = [repmat(time,[cnt 1]), pSub];
        end

        % Registration
        positions(:,end+1) = pP;
        lengths(:,end+1) = -springLength(pP, sp);
        times(end+1) = time;

        % Subdivide
        pP = pP + dp;
        pV(pA) = pV(pA) + dv;
        spSteps = spSteps_new;

        % Time update
        time = time+dt;
    end

end
