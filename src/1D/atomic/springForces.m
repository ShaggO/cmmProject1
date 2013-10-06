function [F, dx] = springForces(positions, springs, lUpdate, v, K, x0, C)
    element = true;
    % Initialize internal variables
    cntS = size(springs,1);
    cntP = size(positions,1);
    Fs  = zeros(cntS,1);

    % Initialize output 
    F   = zeros(cntP,2);
    dx = zeros(cntS,1);

    % Calculate force F of each spring
    if element
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
    else
        % Matrix alternative to spring (element) wise computation
        from = springs(:,1);
        to   = springs(:,2);

        dx = springLength(positions, springs);
        l  = abs(dx);

        Fs = K .* (l - x0);
        Fs = Fs + C .* (v(from) - v(to)) .* dx ./ l;
        Fs = Fs .* (-dx ./ l);

        F(from,1) = F(from,1) + Fs;
        F(to,2)   = F(to,2) - Fs;

    end

end
