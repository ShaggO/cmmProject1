function diffSim(data, fps)
    cntD = size(data,1);

    if cntD > 1
        figure();
        for i = 1:cntD-1
            subplot(1,cntD-1,i);
            mult = fps(i) / fps(i+1);
            diff = data{i,2}(:,1:mult:end) - data{i+1,2};
            plot(data{i,3}(1:mult:end),diff,'-');
            title(['Diff between ' num2str(fps(i)) ' and ' num2str(fps(i+1)) ' fps']);
            xlabel('Time');
            ylabel('Diff in spring length');
        end
    else
        error('Not able to calculate diff of only 1 simulation');
    end
end
