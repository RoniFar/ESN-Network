function [Alpha, Beta, InScale, Connect] = GridSearch(sig_in, reserv, XX,...
    Y0, Kres, Win, pa, pb, pinscale, bi, conn, gfun)
%% grid search
% we placed the paramater thata we found bellow.
% you can uncomment this section but you need the comment the "Parametrs
% and weight" instead
% input:
    % sig_in = integer. number of singal we show the sistem
    % reserv = number of nuiron in reservoir layer
    % XX = input nueron vec
    % Y0 = output teacher
    % pa = vector. Leaking rate of each reservoir layer
    % pb  = vector. regularization coefficient
    % pinscale = vector. the scailin of the input weight matrix
    % conn = vector. connections reservoir matrix
    % gfun = reservoir activation function
                   
% output:
    % Alpha = Leaking rate of each reservoir layer
    % Beta = regularization coefficient
    % InScale = the scailin of the input weight matrix
    % Connect = connections reservoir matrix


% Description
    % fist we create r_state matrix in which the lines represent the time
    % (i.e.line N is the state of reservoir at time N)
    % than we runing on each combination of the parameters using embedded
    % loops. each time we save the parameters combination values if it 
    % gives largest memory capacity than the set that allredy saved.

    r_state = zeros(sig_in,reserv);
    Memory = 0;

    for i = 1:length(pa)                   %search Leaking rate
        A = pa(i);

        for j = 1:length(pb)               %search regularization coefficient
            B = pb(j);

            for s = 1:length(pinscale)     %search input scale
                IS = pinscale(s);

                Win_scale = Win .* IS;
                for c = 1:length(conn)
                    CON = conn(c);
                    Sparse = rand(size(Kres))<CON;
                    K_sparse = Kres .* Sparse;

                    % calculate sreservoir state
                    r_state(1,:) = A .* gfun(Win_scale * XX(1));

                    for n = 1:(sig_in - 1)
                        r_state(n+1,:) = (1 - A) .* r_state(n,:)' + ...
                            A .* gfun(Win_scale * XX(n+1) + K_sparse * r_state(n,:)');
                    end

                    C = r_state' * r_state ./ sig_in;      %Correlation matrix of reservoir state
                    U = r_state' * Y0 ./ sig_in;           %cross-correlation of the reservoir state and desired output
                    W_out = inv(C + B.* eye(size(C))) * U;       %Reservoir to output weight matrix
                    Y = r_state * W_out;

                    corelation_matrix = corr(Y,Y0);
                    R_sq_tain = diag(corelation_matrix).^2;
                    Memory_Capacity = sum(R_sq_tain);

                    %saving the parameters val that gives the largest memory capacity
                    if Memory_Capacity > Memory
                       G_alpha = A;
                       G_beta = B;
                       G_input_scaling = IS;
                       G_connectivity = CON;
                       G_matrix_con = Sparse;
                       Memory = Memory_Capacity;
                       GY = Y;            %save the product (output) compatible with the parameters 
                    end

                end   
            end
        end
    end

    Alpha = G_alpha;                                 %Leaking rate of each reservoir layer
    Beta  = G_beta;                                  %regularization coefficient
    InScale = G_input_scaling ;                      %the scailin of the input weight matrix
    Connect = G_connectivity;                        %connections reservoir matrix
    
end