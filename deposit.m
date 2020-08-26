function [reverse_A_new, reverse_B_new, share_A_mint, share_B_mint, share_A_total_new, share_B_total_new] = deposit(value_A, value_B, reverse_A, reverse_B, total_share_A, total_share_B)
    reverse_A_new = reverse_A + value_A;
    reverse_B_new = reverse_B + value_B;
    share_A_mint = mint_share(value_A, reverse_A, total_share_A);
    share_B_mint = mint_share(value_B, reverse_B, total_share_B);
    share_A_total_new = share_A_mint + total_share_A;
    share_B_total_new = share_B_mint + total_share_B;
end

function share_minted = mint_share(x_deposit, x_starting, s_starting)
    share_minted = x_deposit ./ x_starting .* s_starting;
end