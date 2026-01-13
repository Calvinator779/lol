
% lw3_2.m
evalc('run("lw3_1.m")'); % Підтягуємо змінні A, B, C, K, H

H = zeros(1,4);
simOut = sim('lb3', 'StartTime', '0', 'StopTime', t_sim);

x_real = simOut.yout{1}.Values; % Дані об'єкта
x_est  = simOut.yout{2}.Values; % Дані спостережувача (Out_X)

f = figure('Position', [100, 100, 1000, 600]);
for i = 1:4
    subplot(2,2,i);
    plot(x_real.Time, x_real.Data(:,i), 'b', 'LineWidth', 1.5); hold on;
    plot(x_est.Time, x_est.Data(:,i), 'r--', 'LineWidth', 1.5);
    title(['Змінна x_' num2str(i)]);
    legend('Реальна', 'Оцінка');
    grid on;
end
sgtitle('Вільний рух та оцінювання (Розімкнена система)');
print(f, [mfilename('fullpath') '.png'], '-dpng', '-r300');
close(f);