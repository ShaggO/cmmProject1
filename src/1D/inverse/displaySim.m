function displaySim(data, fps)
    movie = false;
    animation = false;
    timesteps = true;

    figure();
    cntD = size(data,1);
    for i = 1:cntD
        i0 = i-1;
        plot1 = i;
        plot2 = plot1+cntD;
        subplot(2, cntD, plot1);
        plot(data{i,3},data{i,2});
        title(['Spring lengths for ' num2str(fps(i)) ' fps']);
        xlabel('Time (s)');
        ylabel('Spring length');
        axis([0 max(data{i,3}) -0.3 0.55]);
        subplot(2, cntD, plot2);
        plot(data{i,3},data{i,1});
        title(['Simulation trace ' num2str(fps(i)) ' fps']);
        xlabel('Time (s)');
        ylabel('Position');
        hold on;
        for j = 1:size(data{i,4},1)
            time = data{i,4}(j,1);
            ind1 = data{i,4}(j,2);
            ind2 = data{i,4}(j,3);
            plot(time,data{i,1}(ind1, data{i,3} == time),'xr');
            plot(time,data{i,1}(ind2, data{i,3} == time),'xr');
        end
        if timesteps
            updPoints = find(data{i,5});
            plot(data{i,3}(updPoints),data{i,1}(:,updPoints),'xb');
            disp(length(updPoints) / max(data{i,3}));
        end
        axis([0 max(data{i,3}) -2 7]);
    end

%    if animation
%        figure();
%        y_values = zeros(size(positions,1),1);
%        plot(positions(:,1),y_values,'x');
%        set(gca,'NextPlot','replaceChildren');
%        for i=1:length(times)
%            plot(positions(:,i),y_values,'xr');
%            hold on;
%            title(['Time frame: ' num2str(times(i))]);
%            %    drawnow;
%            hold off;
%            %    pause(0.1);
%            F(i) = getframe;
%        end
%    end
%
%    if movie
%        figure();
%        movie(F,1,fps);
%    end
end
