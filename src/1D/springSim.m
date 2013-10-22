function [positions, lengths, times, switches] = springSim(fps_lowest, t_stop)
    % Create grid of particles at positions
    pP = [-2:0.5:1.99, 2:0.15:2.99, 3:0.5:6.99]';
    %pP = [-2:1:2];
    if size(pP,2) > size(pP,1)
        pP = pP';
    end

    % Initialize variables
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
    spX0 = abs(spX0(:,1) - spX0(:,2)) * 0.785;

    distance_show = false;
    momentum_show = false;

    t_start = 0;
    if t_stop == 0
        t_stop = 500;
    end
    if fps_lowest == 0
        fps_lowest = 30;
    end
    disp(fps_lowest);
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
    switches = [];

    % subdivide particles
    pSub = [];
    pSt = [];
    pSdt = [];

    dx = zeros(cntS,1);
    pF = zeros(cntP,2);
    while time <= t_stop + dt/2;
        p_last = pP;
        pP = pP + pV * dt;

        % Check for subdivision
        if dt < dt_base && size(pSub,1) > 0

            % Find springs to re-calculate force for
            springs = sp(ismember(sp,pSub));
        end

        % Force calculation
        [pF dx] = springForces(pP, sp, pV, spK, spX0, spC);

        % Position and velocity update
        [dp dv] = springStep(pP, pM, pV, sum(pF,2), dt);

        % Detect collisions / switches in position
        l = springLength(p_last, sp);
        l2 = springLength(pP + dp, sp);
        mask = l .* l2 < 0;
        if any(mask)
%            dt = dt/10;
            dt = 1/30;
            disp('Switch in next iteration!');
            pSub = sp(mask,:);
            cnt = size(pSub,1);
            switches(end+1:end+cnt,:) = [repmat(time,[cnt 1]), pSub];
%            dt = dt/10;
%            pV(pSub) = 0;
            [pF dx] = springForces(pP, sp, pV, spK, spX0, spC);

            [dp dv] = springStep(pP, pM, pV, sum(pF,2), dt);
        end

        % Registration
        positions(:,end+1) = pP;
        lengths(:,end+1) = -dx;
        times(end+1) = time;

        % Subdivide
        pV = pV + dv;

        % Time update
        time = time+dt;
    end

end
