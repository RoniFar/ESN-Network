function [Memory_Capacity, Y, corr_matrix, R_sq] = Validation(sig_in, in, ...
    XX, Win, K, Woutt, Y0_val, aa, gfun)
% define validation set or W_out (the only weight the sistem learn)
% by chosing another random set of input, calculating the teacher value
% and reservoir state, and define the output with the pruduct of the 
% reservoir state validation and W_out train. 
% input:
    % sig_in = integer. number of singal we show the sistem
    % reserv = integer. number of nuiron in reservoir layer
    % XX = number of nuiron in input layer
    % Win = integer. input weight matrix with scale 
    % K = reservoir afinel ctivation matrix 
    % Woutt = Wout from trining
    % Y0_val = output teacher
    % aa = Leaking rate of each reservoir layer
    % bb = regularization coefficient
    % gfun = reservoir activation function
                   
% output:
    % Memory_Capacity = calcukate the Memory Capacity bum sum od R^2
    % Y = Input to reservoir weight matrix
    % corr_matrix = corelation matrix between the teacher and the output
    % R_sq = calculate R^2

   % calculate sreservoir state
    r_state(1,:) = aa .* gfun(Win * XX(1));

    for n = 1:(sig_in - 1)
        r_state(n+1,:) = (1 - aa) .* r_state(n,:)' + ...
         aa .* gfun(Win * XX(n+1) + K * r_state(n,:)');
    end

    Y = r_state * Woutt;   
    corr_matrix = corr(Y, Y0_val);
    R_sq = diag(corr_matrix).^2;
    Memory_Capacity = sum(R_sq);
end

     