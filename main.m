% ����ȷ����ʼ״̬
input_x = input('eth��ʼ��Ѻ��:');
input_y = input('lava��ʼ��Ѻ��:');
init_invariant = initial_deposit(input_x, input_y);
init_share = initial_share(input_x, input_y);

% ��ʼ��ȫ��״̬��
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
fprintf('eth����ʼ��Ϊ:%6.2f, lava����ʼ��λΪ: %6.6f\n',x_price,y_price);

while 1
    action = input('ִ��ʲô������ (''swap''�� ''deposit'', ''withdraw''):', 's');
    switch action
        case 'swap'
            % ����
            index = input('��Ҫ���ѱҵ����(0 or 1):');
            expense_value = input('��Ҫ���ѵ���:');
            if index == 0
                [Token_out, invariant_new, reserve_A_New, reserve_B_New, price_new] = swap(expense_value, invariant, x_pool, y_pool);
                fee_total = fee_total + expense_value .* 0.03;
                x_pool = reserve_A_New;
                y_pool = reserve_B_New;
                x_price = price_new;
                y_price = 1 ./ x_price;
                fprintf('����ETH:                   %6.4f,          ����lava:              %6.4f \n', expense_value, Token_out);
            else
                [Token_out, invariant_new, reserve_A_New, reserve_B_New, price_new] = swap(expense_value, invariant, y_pool, x_pool);
                y_pool = reserve_A_New;
                x_pool = reserve_B_New;
                y_price = price_new;
                x_price = 1 ./ y_price;
                fprintf('����Lava:                  %6.4f,          ����ETH:               %6.4f \n', expense_value, Token_out);
            end
            invariant = invariant_new;
            fprintf('eth�����´���:             %6.2f,          lava�����´���:         %6.6f\n',x_pool, y_pool);
            fprintf('eth�����¼۸�Ϊ:           %6.2f lava/eth, lava�����¼۸�Ϊ:       %6.6f eth/lava\n',x_price,y_price);
            fprintf('���׶Գ���:                %6.2f \n',invariant);
            
        case 'deposit'
            % ��Ѻ
            index = input('��Ҫ��Ѻ�����(0 or 1):');
            deposit_value = input('��Ѻ����:');
            if index == 0
                value_A_deposit = deposit_value;
                value_B_deposit = value_A_deposit .* y_pool ./ x_pool;
            else
                value_B_deposit = deposit_value;
                value_A_deposit = value_B_deposit .* x_pool ./ y_pool;
            end
            [reverse_A_new, reverse_B_new, share_A_mint, share_B_mint, share_A_total_new, share_B_total_new, invariant_new] = deposit(value_A_deposit, value_B_deposit, x_pool, y_pool, x_share_total, y_share_total);
            invariant = invariant_new;
            x_pool = reverse_A_new;
            y_pool = reverse_B_new;
            x_share_total = share_A_total_new;
            y_share_total = share_B_total_new;
            personal_share_x = personal_share_x + share_A_mint;
            personal_share_y = personal_share_y + share_B_mint;
            fprintf('eth�����´���:             %6.2f,          lava�����´���:         %6.6f \n',x_pool, y_pool);
            fprintf('����eth��share:            %6.6f,          ����lava��share:        %6.6f \n',share_A_mint, share_B_mint);
            fprintf('����ethռ��:               %6.2f           ����lavaռ��:           %6.2f \n',share_A_mint ./ x_share_total, share_B_mint ./ y_share_total);
            fprintf('�ۼ�eth��share:            %6.6f,          �ۼ�lava��share:        %6.6f \n',personal_share_x,  personal_share_y);
            fprintf('�ۼ�ethռ��:               %6.2f           �ۼ�lavaռ��:           %6.6f \n', personal_share_x ./ x_share_total, personal_share_y ./ y_share_total);
            
        case 'withdraw'
            % ���
            [removed_A, removed_B, reverse_A_new, reverse_B_new, total_share_A_new, total_share_B_new, invariant_new] = withdraw(personal_share_x, personal_share_y, x_pool, y_pool, x_share_total, y_share_total);
            invariant = invariant_new;
            x_pool = reverse_A_new;
            y_pool = total_share_A_new;
            x_share_total = total_share_A_new;
            y_share_total = total_share_B_new;
            fprintf('eth�������:                %6.2f,         lava�������Ϊ:          %6.2f\n', removed_A, removed_B);
            fprintf('eth�������ܴ���:            %6.2f,         lava�������ܴ���Ϊ:       %6.2f\n', x_pool, y_pool);
            fprintf('eth��������:                %6.6f,         eth�������ѷֳ�:          %6.6f\n', fee_total, fee_total .* personal_share_x ./ (personal_share_x + x_share_total));
    end
end





