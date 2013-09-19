clear all;
close all;
%fd=@(p) sqrt(sum(p.^2,2))-1;

fd=@(p) drectangle0(p,-2,2,-2,2);
fh=@(p) 0.05+0.25*dcircle(p,0,0,0.05);
figure;
%[p,t]=distmesh2d(fd,@huniform,0.5,[-2,-2;2,2],[]);
[p,t]=distmesh2d(fd,fh,0.05,[-1,-1;1,1],[-1,-1;-1,1;1,-1;1,1]);
%p2 = [];

%[X,Y] = meshgrid(-2:0.5:2,-2:0.5:2);
%X2 = X(1:2:end,1:2:end) + 0.25;
%Y2 = Y(1:2:end,1:2:end) + 0.25;

%p = [X(:),Y(:)];

%{

p2 = p(all(p >= -1,2) & all(p <= 1,2),:);
p2(:,1) = p2(:,1) + 0.2;
p2(:,2) = p2(:,2) + 0.2;
figure;
[p2,t2]=distmesh2d(fd,@huniform,0.3,[-2,-2;2,2],[]);
%}
p3 = [p;p2];
t3 = delaunay(p3(:,1),p3(:,2));

figure;
triplot(t3, p3(:,1), p3(:,2));
axis equal;
