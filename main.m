% 首先确定初始状态
input_x = input('eth初始抵押量:');
input_y = input('lava初始抵押量:');
init_x = input_x;
init_y = input_y;
init_invariant = initial_deposit(init_x, init_y);
init_share = initial_share(init_x, init_y);

% 初始化全局状态机
invariant = init_invariant;
x_pool = init_x;
y_pool = init_y;
x_share_total = init_share;
y_share_total = init_share;
x_price = input_y ./ input_x;
y_price = input_x ./ input_y;
fprintf('eth的起始价为:%6.2f, \nlava的起始价位为: %6.2f \n ',x_price,y_price);

% 抵押
value_A_deposit = input('eth抵押量:');
value_B_deposit = value_A_deposit .* input_y ./ input_x;
[reverse_A_new, reverse_B_new, share_A_mint, share_B_mint, share_A_total_new, share_B_total_new] = deposit(value_A_deposit, value_B_deposit, x_pool, y_pool, x_share_total, y_share_total);
x_pool = reverse_A_new;
y_pool = reverse_B_new;
x_share_total = share_A_total_new;
y_share_total = share_B_total_new;

% 交易
[Token_B_out, invariant_new, reserve_A_New, reserve_B_New, price_A_new] = swap(swap_A_value, invariant, x_pool, y_pool);
x_price = price_A_new;
y_price = 1 ./ x_price;
x_pool = reserve_A_New;
y_pool = reserve_B_New;
invariant = invariant_new;

% 赎回
[removed_A, removed_B, reverse_A_new, reverse_B_new, total_share_A_new, total_share_B_new] = withdraw(share_A_mint, share_B_mint, x_pool, y_pool, x_share_total, y_share_total);
x_pool = reverse_A_new;
y_pool = total_share_A_new;
x_share_total = total_share_A_new;
y_share_total = total_share_B_new;














