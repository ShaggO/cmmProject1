function scaleaxis (xpoints, ypoints)
    x_min = min(xpoints(:));
    x_max = max(xpoints(:));
    y_min = min(ypoints(:));
    y_max = max(ypoints(:));

    axis([x_min x_max y_min y_max]);
end
