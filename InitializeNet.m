function [X, W_in, K_res, Y0] = InitializeNet(sig_in, reserv, in, out)
% input:
    % sig_in = integer. number of singal we show the sistem
    % reserv = integer. number of nuiron in reservoir layer
    % in = number of nuiron in input layer
    % out = integer. number of nuiron in output layer
                   
% output:
    % X = input nueron vec
    % W_in= Input to reservoir weight matrix
    % K_res = reservoir activation matrix 
    % Y0 = output teacher

    % set layers
    X = randn(in ,sig_in);            %input nueron vec

    % Initialize weights
    W_in = randn(reserv ,in);           %Input to reservoir weight matrix
    K_res = Kreservoir(reserv);      %reservoir activation matrix    

    % calculate the output teacher
    Y0 = zeros(sig_in, out);
    for k = 1:out
        for t = (k+1):sig_in  % if t<=k Y0=0
            Y0(t,k) = X(t - k);
        end
    end
end
    
 %random K matrix 
function k_reservoir = Kreservoir(reserv)
    %create random K matrix
    k_tilde = randn(reserv,reserv);  %random val for reservoir activation matrix
    max_k_eig = max(real(eig(k_tilde)));           %find the max complex real part of K_tilde igenvalues
    k_reservoir = k_tilde ./ max_k_eig;   
end