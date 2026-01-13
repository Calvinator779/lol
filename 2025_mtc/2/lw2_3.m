% lw2_3.m
evalc('run("lw2_1.m")');

% Передатна функція замкненої системи по збуренню
% W_L_cl = (sI - (A-BH))^-1 * G
sys_closed_dist = ss(A_new, G, eye(4), 0);

f = figure('Position', [0, 0, 1000, 800]);
bode(sys_closed_dist); 
grid on;
title('ЛАЧХ та ЛФЧХ замкненої системи (вхід: Збурення L)');
legend('x_1', 'x_2', 'x_3', 'x_4');

drawnow;
print(gcf, [mfilename('fullpath') '.png'], '-dpng', '-r300');
close(f);