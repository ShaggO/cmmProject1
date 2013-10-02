function displaySim(data, fps)
    movie = false;
    animation = false;

    figure();
    cntD = size(data,1);
    for i = 1:cntD
        i0 = i-1;
        plot1 = i;
        plot2 = plot1+3;
        subplot(2, cntD, plot1);
        plot(data{i,3},data{i,2});
        title(['Spring lengths for ' num2str(fps(i)) ' fps']);
        xlabel('Time');
        ylabel('Spring length');
        axis([0 max(data{i,3}) 0.2 0.55]);
        subplot(2, cntD, plot2);
        plot(data{i,3},data{i,1});
        title(['Simulation trace ' num2str(fps(i)) ' fps']);
        xlabel('Time');
        ylabel('Position');
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
