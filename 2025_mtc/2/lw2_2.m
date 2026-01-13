% lw2_2.m
evalc('run("lw2_1.m")'); 

t_sim = '0.6';      % Час симуляції
x0 = [1; 0; 0; 0];  % Початкові умови

simOut = sim('lb2', 'StartTime', '0', 'StopTime', t_sim);

signalVal = simOut.yout{1}.Values;
y_data = signalVal.Data;
t = signalVal.Time;

f = figure('Position', [100, 100, 1000, 600]);
plot(t, y_data, 'LineWidth', 1.5);
legend('x_1', 'x_2', 'x_3', 'x_4');
title(['Вільний рух замкненої системи (\omega_0 = ' num2str(w0) ')']);
xlabel('Час, с');
ylabel('Змінні стану');

print(f, [mfilename('fullpath') '.png'], '-dpng', '-r300');
close(f);