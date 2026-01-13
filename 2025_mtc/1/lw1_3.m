% lw1_3.m
run('lw1_params.m');

s = tf('s'); % оператор Лапласа для функцій передачі простору станів
W_U_tf = (s*eye(4) - A)\B;

figure('Position', [0, 0, 1920/2, 1080/2]); % бо не видно графіки норм

bode(W_U_tf(1), W_U_tf(2), W_U_tf(3), W_U_tf(4));
legend('W_U1','W_U2','W_U3','W_U4');
grid on;
title('Амплітудно-фазові частотні характеристики за керуючим впливом передатної функції Wu');

drawnow;
print(gcf, [mfilename('fullpath') '.png'], '-dpng', '-r300');
close(gcf);
