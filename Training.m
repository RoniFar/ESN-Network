function [Memory_Capacity, Y, Wout, corr_matrix, R_sq] = Training(sig_in, ...
    reserv, XX, Win, K, Y0, aa, bb, gfun)
% calculate reservoir state
% input:
    % sig_in = integer. number of singal we show the sistem
    % reserv = integer. number of nuiron in reservoir layer
    % XX = number of nuiron in input layer
    % Win = integer. input weight matrix with scale 
    % K = reservoir afinel ctivation matrix 
    % Y0 = output teacher
    % aa = Leaking rate of each reservoir layer
    % bb = regularization coefficient
    % gfun = reservoir activation function
                   
% output:
    % Memory_Capacity = calcukate the Memory Capacity bum sum od R^2
    % Y = Input to reservoir weight matrix
    % Wout = input weight matrix 
    % corr_matrix = corelation matrix between the teacher and the output
    % R_sq = calculate R^2

    % calculate reservoir state
    r_state = zeros(sig_in,reserv);

    r_state(1,:) = aa .* gfun(Win * XX(1));         %calculate r(1)            
    for n = 1:(sig_in - 1)                          %recursive loop for r
        r_state(n+1,:) = (1 - aa) .* r_state(n,:)' + ...
         aa .* gfun(Win * XX(n+1) + K * r_state(n,:)');
    end

    C_train = r_state' * r_state ./ sig_in;             %Correlation matrix of reservoir state
    U_train = r_state' * Y0./ sig_in;                   %cross-correlation of the reservoir state and desired output
    Wout = inv(C_train + bb.* eye(size(C_train))) * U_train;  %Reservoir to output weight matrix
    Y = r_state * Wout;

    corr_matrix = corr(Y,Y0);      
    R_sq = diag(corr_matrix).^2;    
    Memory_Capacity = sum(R_sq);     
end