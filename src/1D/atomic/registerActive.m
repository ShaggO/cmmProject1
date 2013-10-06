function [pMask sMask lUpdate, steps] = registerActive(positions, springs,...
lUpdate, velocities, time, dt, factor, steps, stepBound)
    if nargin < 9
        stepBound = NaN;
    end

    % New positions using existing velocity
    positionsFull = positions + velocities * dt;

    % New length
    l = springLength(positionsFull, springs);

    % Ratio between last updated length and next
    ratio = lUpdate ./ l;

    % Find indices of violating springs and points
    sMask = ratio > factor | ratio < 1/factor;
    if time == 0
        sMask = ones(size(springs,1),1);
%    else
%        sMask = zeros(size(springs,1),1);
    end
    if ~isnan(stepBound)
        sMask = sMask | steps >= stepBound;
    end
    % Temporary override to debug the rest of the simulator
    sMask = find(sMask);
    pMask = unique(springs(sMask,:));

    % Update last updated lengths and number of steps since update
    lUpdate(sMask) = l(sMask);
    steps = steps+1;
    steps(sMask) = 1;
end
