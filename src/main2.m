% Clear workspace
clear all;
close all;

% Load mesh

load('data.mat');

% Set simulation time
t_start = 0;
fps = 100;
dt = 1 / fps;
t_end = 20

% Set simulation constants
lambda = 398;
% E = Young's modulus
%E = 
mu = 265;
%lambda = mu * (E - 2*mu) / (3 * mu - E);

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


% Loop over time
%for t = t_start : dt : t_end
for step = 1:2000
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
        fi =fe;
        if step == 1
            fi = fi + [0 -100]';
%        elseif step == 200
%            disp('Additional');
%            fi = fi + [0 -800]';
        end

        v(i,:) = v(i,:) + dt / m(i) * fi';
        xn(i,:) = xn(i,:) + dt * v(i,:);
    end
%    [T, X, Y]
%    if area
%        
%    end

    % Dirichlet condition
    xn(ind,:) = [X(ind), Y(ind)];
    v(ind,1) = 0;

    triplot(T, xn(:,1),xn(:,2));
    axis equal;
    drawnow;
end
