% 首先确定初始状态
input_x = input('eth初始抵押量:');
input_y = input('lava初始抵押量:');
init_invariant = initial_deposit(input_x, input_y);
init_share = initial_share(input_x, input_y);

% 初始化全局状态机
invariant = init_invariant;
fee_total = 0;
x_pool = input_x;
y_pool = input_y;
x_share_total = init_share;
y_share_total = init_share;
x_price = input_y ./ input_x;
y_price = input_x ./ input_y;
personal_share_x = 0;
personal_share_y = 0;
fprintf('eth的起始价为:%6.2f, lava的起始价位为: %6.6f\n',x_price,y_price);

while 1
    action = input('执行什么操作？ (''swap''， ''deposit'', ''withdraw''):', 's');
    switch action
        case 'swap'
            % 交易
            swap_A_value = input('购买lava, 花费的eth量:');
            [Token_B_out, invariant_new, reserve_A_New, reserve_B_New, price_A_new] = swap(swap_A_value, invariant, x_pool, y_pool);
            fee_total = fee_total + swap_A_value .* 0.03;
            x_price = price_A_new;
            y_price = 1 ./ x_price;
            x_pool = reserve_A_New;
            y_pool = reserve_B_New;
            invariant = invariant_new;
            fprintf('购得的lava量:%6.4f \n', Token_B_out);
            fprintf('eth的最新储量:%6.2f, lava的最新储量: %6.6f\n',x_pool, y_pool);
            fprintf('eth的最新价格为:%6.2f lava/eth, lava的最新价格为: %6.6f eth/lava\n',x_price,y_price);
        
        case 'deposit'
            % 抵押
            value_A_deposit = input('eth抵押量:');
            value_B_deposit = value_A_deposit .* y_pool ./ x_pool;
            [reverse_A_new, reverse_B_new, share_A_mint, share_B_mint, share_A_total_new, share_B_total_new] = deposit(value_A_deposit, value_B_deposit, x_pool, y_pool, x_share_total, y_share_total);
            x_pool = reverse_A_new;
            y_pool = reverse_B_new;
            x_share_total = share_A_total_new;
            y_share_total = share_B_total_new;
            personal_share_x = personal_share_x + share_A_mint;
            personal_share_y = personal_share_y + share_B_mint;
            fprintf('eth的总储量:%6.2f, lava的总储量为: %6.2f \n',x_pool,y_pool);
            fprintf('本次eth的share值:%6.6f, 占比:%6.2f \n本次lava的share值: %6.6f, 占比: %6.2f \n',share_A_mint, share_A_mint ./ x_share_total, share_B_mint, share_B_mint ./ y_share_total);
            fprintf('投资者eth的share总额:%6.6f, 占比:%6.2f \n投资者lava的share总额: %6.6f, 占比: %6.2f \n',personal_share_x, personal_share_x ./ x_share_total, personal_share_y, personal_share_y ./ y_share_total);
        
        case 'withdraw'
            % 赎回
            [removed_A, removed_B, reverse_A_new, reverse_B_new, total_share_A_new, total_share_B_new] = withdraw(personal_share_x, personal_share_y, x_pool, y_pool, x_share_total, y_share_total);
            x_pool = reverse_A_new;
            y_pool = total_share_A_new;
            x_share_total = total_share_A_new;
            y_share_total = total_share_B_new;
            fprintf('eth的赎回量:%6.2f, lava的赎回量为: %6.2f\n', removed_A, removed_B);
            fprintf('eth的最新总储量:%6.2f, lava的最新总储量为: %6.2f\n', x_pool, y_pool);
            fprintf('eth总手续费: %6.6f, eth的手续费分成:%6.6f\n', fee_total, fee_total .* personal_share_x ./ (personal_share_x + x_share_total));
    end
end





