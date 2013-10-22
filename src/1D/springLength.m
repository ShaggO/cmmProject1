function [l] = springLength(positions, springs)
    % Get indices
    left  = positions(springs(:,1));
    right = positions(springs(:,2));

    % Compute length (left - right)
    l = left - right;
end
