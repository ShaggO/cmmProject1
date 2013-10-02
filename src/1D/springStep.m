function [dp, dv] = springStep(p, m, v, F, dt)
    % Calculate derivative of velocity
    dv = F ./ m;

    % Position change
    dp = v * dt;

    % Velocity change
    dv = dv * dt;
end
