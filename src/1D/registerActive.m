function [pMask sMask lUpdate, steps] = registerActive(positions, springs,...
lUpdate, velocities, time, dt, factor, steps, stepBound, rest)
    if nargin < 9
        stepBound = NaN;
    end

    % New positions using existing velocity
    positionsFull = positions + velocities * dt;

    % New length
    l = abs(springLength(positionsFull, springs));

    % Ratio between last updated length and next
%    ratio = abs(l-rest);
    ratio2 = abs(l ./ lUpdate);

    % Find indices of violating springs and points
    sMask = zeros(size(l));
%    sMask = ratio > factor;
%    sMask = ratio2 > factor | ratio2 <= 1/factor;
    if ~isnan(factor)
        sMask = ratio2 < factor & ratio2 >= 1/factor | sMask;
    end
%    sMask = ratio2 < factor | sMask;
%    sMask = ratio2 >= 1/factor & sMask;
    if ~isnan(stepBound)
        sMask = sMask | steps >= stepBound;
    end
    % Temporary override to debug the rest of the simulator
    sMask = find(sMask > 0);
    pMask = unique(springs(sMask,:));

    % Update last updated lengths and number of steps since update
    lUpdate(sMask) = l(sMask);
    steps = steps+1;
    steps(sMask) = 1;
end
