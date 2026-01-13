% lw3_4.m
evalc('run("lw3_1.m")');

% Створення space-state моделі похибки
% Вхід: L, Вихід: Error (всі стани)
Sys_err = ss(A - K*C, G, eye(4), 0);

f = figure('Position', [100, 100, 900, 700]);
bode(Sys_err);
grid on;
title('Частотні характеристики спостережувача');
print(f, [mfilename('fullpath') '.png'], '-dpng', '-r300');
close(f);