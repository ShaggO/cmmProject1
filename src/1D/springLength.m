function [l] = springLength(positions, spring)
    % Get indices
    left  = positions(spring(:,1));
    right = positions(spring(:,2));

    % Compute length (left - right)
    l = left - right;
end
