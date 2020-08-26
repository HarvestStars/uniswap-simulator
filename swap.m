function [Token_B_out, invariant_new, reserve_A_New, reserve_B_New, price_A_new] = swap(Token_A_in, invariant, reserve_A, reserve_B)
    reserve_A_New = reserve_A + Token_A_in;
    fee = Token_A_in .* 0.0025;
    reserve_B_New = invariant ./ (reserve_A_New - fee);
    Token_B_out = reserve_B - reserve_B_New;
    invariant_new = reserve_A_New .*  reserve_B_New;
    price_A_new = Token_B_out./Token_A_in;
end