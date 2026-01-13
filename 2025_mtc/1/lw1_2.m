% lw1_2.m

% Параметри для симуляції
run('lw1_params.m');
time_sim = [1, 5, 100, 1000];
x0 = [1; 0; 0; 0];
myConstant = 1;

figure('Position', [0, 0, 1920/2, 1080/2]); % бо не видно графіки норм


plotLegend = compose('змінна стану %d', 1:size(y_data,2));
for i = 1:length(time_sim)
    t_sim = time_sim(i);
    
    simLink = sim('lb1.slx', t_sim, simset('SrcWorkspace','current'));
    t = simLink.tout;
    y_data = simLink.yout{1}.Values.Data;
    
    subplot(2, 2, i);
    plot(t, y_data, 'LineWidth', 1.5);
    grid minor;
    legend(plotLegend);
    xlabel('Час, с');
    ylabel('Значення змінних стану');
end

sgtitle('Динаміка системи для різного часу симуляції');

drawnow;
print(gcf, [mfilename('fullpath') '.png'], '-dpng', '-r300');
close(gcf);
