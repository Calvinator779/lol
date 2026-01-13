% lw1_1.m
run('lw1_params.m');

syms p
pE  = p * eye(4); % квадратна матриця 4 з діагоналлю p 
W_U = (pE - A)\B; % за керуючим впливом
% W_U = inv(pE - A)*B;
W_L = (pE - A)\G; % за збуренням

charPoly = simplify(det(pE - A)); % символьний характеристичний многочлен
coeffs = sym2poly(charPoly);      % числовий вектор коефіцієнтів
coeffRoots = roots(coeffs);       % числовий вектор коренів

disp('Результат лістингу 1:');
disp('$$');
pprint('Передатна функція $W_U$ (за керуючим впливом)', W_U)
pprint('Передатна функція $W_L$ (за збуренням)', W_L)
pprint('Характеристичний многочлен det(pI - A)', charPoly);
pprint('Коефіцієнти ',  coeffs);
pprint('Корені характеристичного рівняння', coeffRoots)
disp('$$');

function pprint(title, M)
    % disp(title); % Для не латеху 
    % pretty(M) % Для не латеху
    disp(['\\[1em] \text{', title, ':}']);
    if isa(M, 'sym')
        disp(latex(M));
    else
        disp('\begin{bmatrix}');
        for i = 1:size(M,1)
            disp([num2str(M(i,:)), ' \\']);
        end
        disp('\end{bmatrix}');
    end
end
