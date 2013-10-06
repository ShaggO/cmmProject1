function [dp, dv] = springStep(p, m, v, F, dt, activeP, springs, steps)
    cntA = size(activeP,1);
    pSprings = zeros(cntA,1);
    for i = 1:cntA
        pSprings(i) = find(springs(:,1) == activeP(i) |...
                           springs(:,2) == activeP(i),1);
    end

    % Position change
    dp = v * dt;

    % Velocity change
    dv = F(activeP) ./ m(activeP) .* dt .* steps(pSprings);
end
