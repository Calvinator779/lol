% lw3_3.m
evalc('run("lw3_1.m")'); 

t_sim = '0.0164';

simOut = sim('lb3', 'StartTime', '0', 'StopTime', t_sim);

x_real = simOut.yout{1}.Values;

f = figure('Position', [100, 100, 800, 500]);
plot(x_real.Time, x_real.Data, 'LineWidth', 1.5);
legend('x_1', 'x_2', 'x_3', 'x_4');
grid on;
title('Вільний рух замкненої системи (Регулятор + Спостережувач)');
xlabel('Час, с');
print(f, [mfilename('fullpath') '.png'], '-dpng', '-r300');
close(f);

% для t_sim = '0.15' виникає помилка:
% Error using lw3_3
% Derivative of state '3' in block 'lb3/Integrator1 ' at time 
% 0.016609323578664462 is not finite. The simulation will be stopped. 
% There may be a singularity in the solution.  If not, try reducing 
% the step size (either by reducing the fixed step size or by tightening 
% the error tolerances)