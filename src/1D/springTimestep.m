function dt = springTimestep(positions, springs, m, K, x0)
    % Get spring lengths
    dt = ones(size(positions,1),1) * -Inf;
    from = springs(:,1);
    to   = springs(:,2);
    dx = abs(springLength(positions, springs));
    divider = abs(-K .* (dx - x0))+0.1;

    dt(from) = max(dt(from), divider);
    dt(to) = max(dt(to), divider);
    dt = (m ./ dt).^(0.1);
%    dt(dt > 1) = 1;
end
