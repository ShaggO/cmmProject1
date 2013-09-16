% Clear workspace
clear all;
close all;

% Load mesh

load('data.mat');

area_show = false;
momentum_show = false;

% Set simulation time
t_start = 0;
fps = 30;
dt = 1 / fps;
t_end = 20

% Set simulation constants
%G = 79.3;
%E = 207;
% E = Young's modulus
%lambda = G * (E - 2*G) / (3 * G - E);
%mu = G;
lambda = 398;
mu = 265;

Nle = zeros(length(cntT),2,3);
invDe0 = zeros(2,2,cntT);

% Pre-compute inv(Ge0)
% and Ne * le
for i = 1:cntT
    % Positions (x,y) of (i,j,k)
    x = X(T(i,:));
    y = Y(T(i,:));

    Ge0_ji = [x(2); y(2)] - [x(1); y(1)];
    Ge0_ki = [x(3); y(3)] - [x(1); y(1)];

    invDe0(:,:,i) = inv([Ge0_ji Ge0_ki]);

    Ge0_hat_ij = ([-y(1) x(1)] - [-y(2) x(2)]);
    Ge0_hat_jk = ([-y(2) x(2)] - [-y(3) x(3)]);
    Ge0_hat_ki = ([-y(3) x(3)] - [-y(1) x(1)]);

    Nle(i,:,1) = Ge0_hat_ij;
    Nle(i,:,2) = Ge0_hat_jk;
    Nle(i,:,3) = Ge0_hat_ki;

end

% Pre-allocate P matrix [ P1 P2 ... Plength(t) ]
P = zeros(2,2,cntT);
v = zeros(cntV,2);
m = ones(cntV,1) * 10;

xn = [X Y];

% Find left side
val = min(X);
ind = find(X == val);
qind = find(X ~= val);

valMax = max(X);
rind = find(X == valMax);

TR = TriRep(T,X,Y);
boundary = freeBoundary(TR);

iters = 1:1000;
Volume = zeros(length(iters),1);
Momentum = zeros(length(iters),1);


fi = zeros(2,cntV);
% Loop over time
%for t = t_start : dt : t_end
for step = iters
    parfor(e = 1:cntT,cntT)
        % Positions (x,y) of (i,j,k)
        x = xn(T(e,:),1);
        y = xn(T(e,:),2);

        ge_ji = [x(2); y(2)] - [x(1); y(1)];
        ge_ki = [x(3); y(3)] - [x(1); y(1)];

        De = [ge_ji ge_ki];

        Fe = De * invDe0(:,:,e);

        Ee = (1/2) * (Fe'*Fe - eye(2));

        Se = lambda * trace(Ee) * eye(2) + 2 * mu * Ee;

        Pe = Fe * Se;

        % Loop over triangles and save F, E, S and P in e
        P(:,:,e) = Pe;
    end

    parfor(i = 1:cntV,cntV)
        [T1 T2] = find(T == V(i));

        fe = zeros(2,1);

        % Go through each triangle
        for e = 1:length(T1)
            % Find indices of edges
            Nji = Nle(T1(e),:,T2(e));
            Nki = Nle(T1(e),:,mod(T2(e)-2,3)+1);

            % Compute boundary integrals:
            fe = fe - 1/2 * P(:,:,T1(e)) * (Nji + Nki)';
        end
        fi(:,i) = fe';
        fi(:,i) = [0, -0.5] + fe';
%        if step == 1 && any(i == rind)
%            fi(:,i) = fi(:,i) + [1000; 0];
%        elseif step == 200
%            disp('Additional');
%            fi = fi + [0 -800]';
%        end

        v(i,:) = v(i,:) + dt / m(i) * fi(:,i)';
        xn(i,:) = xn(i,:) + dt * v(i,:);
    end

    Volume(step) = polyarea(xn(boundary(:,1),1),xn(boundary(:,1),2));
    Momentum(step) = sum(sqrt(v(:,1).^2 + v(:,2).^2));

    % Set left edge stuck
    xn(ind,:) = [X(ind), Y(ind)];
    v(ind,1) = 0;



    fi1 = figure(1);
    hold off;
    triplot(T, X, Y,'red');
    hold on;

    triplot(T, xn(:,1),xn(:,2),'LineWidth',2);
    quiver(xn(qind,1),xn(qind,2),v(qind,1),v(qind,2),'b');
    quiver(xn(qind,1),xn(qind,2),fi(1,qind)',fi(2,qind)','g');
    xlim([-4 5.2]);
    ylim([-5 2]);
    title(['Simulation frame ' num2str(step)]);
    drawnow;
%    if (mod(step, 10) == 0)
%    xlabel('x');
%    ylabel('y');
%    set(fi1, 'PaperPosition', [-0.2 -0.25 6 5.5])
%    set(fi1, 'PaperSize', [5.4 5.2]);
%    saveas(fi1,['../images/push_frame_' num2str(step)],'pdf');
%    end
end


fi2 = figure(2);
plot(1:step,Volume(1:step));
xlabel('frame');
ylabel('Volume');
title('Volume');
set(fi2, 'PaperPosition', [-0.2 -0.25 6 5.5])
set(fi2, 'PaperSize', [5.4 5.2]);
saveas(fi2, '../images/push_volume','pdf');

fi3 = figure(3);
plot(1:step,Momentum(1:step));
title('Momentum');
xlabel('frame');
set(fi3, 'PaperPosition', [-0.2 -0.25 6 5.5])
set(fi3, 'PaperSize', [5.4 5.2]);
ylabel('Sum of length of velocity');
saveas(fi3, '../images/push_momentum','pdf');
