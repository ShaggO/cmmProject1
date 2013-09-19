function h=dualform(p, varargin)
    h = ones(size(p,1),1);

    h(all(p >= -2,2) & all(p <= 2,2)) = 0.6;
        fh=@(p) 0.05+0.3*dcircle(p,0,0,0.5);
end
