function [F, dx] = springForces(positions, springs, v, K, x0, C)
    % Initialize internal variables
    cntS = size(springs,1);
    cntP = size(positions,1);
    Fs  = zeros(cntS,1);

    % Initialize output 
    F   = zeros(cntP,2);
    dx = zeros(cntS,1);

    % Calculate force F of each spring
    for s = 1:cntS
        % Endpoints of spring
        from = springs(s,1);
        to = springs(s,2);

        % Lengh of spring
        dx(s) = springLength(positions, springs(s,:));
        l = abs(dx(s));

        % Force calculation
        Fs = K(s) * (l - x0(s));                        % Spring force
        Fs = Fs + C(s) * (v(from) - v(to)) * dx(s) / l; % Dampening
        Fs = Fs * (- dx(s) / l);                        % Direction

        % Apply forces to endpoints
        F(from,1) = F(from,1) + Fs;
        F(to,2) = F(to,2) - Fs;
    end

end
