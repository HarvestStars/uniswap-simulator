% 首先确定初始状态
init_x = 10;
init_y = 500;
init_invariant = initial_deposit(initial_x, initial_y);
init_share = initial_share(initial_x, initial_y);

% 初始化全局状态机
invariant = init_invariant;
x_pool = init_x;
y_pool = init_y;
x_share_total = init_share;
y_share_total = init_share;
x_price = 1;
y_price = 1 ./ x_price;

% 抵押
[reverse_A_new, reverse_B_new, share_A_mint, share_B_mint, share_A_total_new, share_B_total_new] = deposit(value_A_deposit, value_B_deposit, x_pool, y_pool, x_share_total, y_share_total);
x_pool = reverse_A_new;
y_pool = reverse_B_new;
x_share_total = share_A_total_new;
y_share_total = share_B_total_new;

% 交易
[Token_B_out, invariant_new, reserve_A_New, reserve_B_New, price_B_new] = swap(swap_A_value, invariant, x_pool, y_pool);
y_price = price_B_new;
x_price = 1 ./ y_price;
x_pool = reserve_A_New;
y_pool = reserve_B_New;
invariant = invariant_new;

% 赎回
[removed_A, removed_B, reverse_A_new, reverse_B_new, total_share_A_new, total_share_B_new] = withdraw(share_A_mint, share_B_mint, x_pool, y_pool, x_share_total, y_share_total);
x_pool = reverse_A_new;
y_pool = total_share_A_new;
x_share_total = total_share_A_new;
y_share_total = total_share_B_new;














