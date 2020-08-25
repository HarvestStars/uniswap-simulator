function [removed_A, removed_B, reverse_A_new, reverse_B_new, total_share_A_new, total_share_B_new] = withdraw(share_A, share_B, reverse_A, reverse_B, total_share_A, total_share_B)
    removed_A = share_A ./ total_share_A .* reverse_A;
    removed_B = share_A ./ total_share_B .* reverse_B;    
    reverse_A_new = reverse_A - removed_A;
    reverse_B_new = reverse_B - removed_B;
    total_share_A_new = total_share_A - share_A;
    total_share_B_new = total_share_B - share_B;
end