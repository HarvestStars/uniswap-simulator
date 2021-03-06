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

Token_In_Sum = [];
x_pools = zeros(1,100);
y_pools = zeros(1,100);
%Token_In_Sum(0) = 0;
for iter = 1:1:100
    percent = 0.05;
    %Token_In_Sum(iter) = Token_In_Sum(iter-1) + percent .* x_pool;
    [Token_B_out, invariant_new, reserve_A_New, reserve_B_New, price_A_new] = swap(percent .* x_pool, invariant, x_pool, y_pool);
    x_pool = reserve_A_New;
    x_pools(iter) = x_pool;
    y_pool = reserve_B_New;
    y_pools(iter) = y_pool;
    invariant = invariant_new;
end
plot(x_pools, y_pools)
