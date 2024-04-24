% ESN

clear; close all; clc;
tic
%% setting
% Set dimensions
input = 1;               %number of nueron in input layer
input_signal = 10000;    %number of singal we show the sistem
reservoir = 500;         %number of nueron in reservoir layer
output = 100;            %number of nueron in output layer

%%  Initialize Network
[X, W_input, K_reservoir, Y0] = ...
    InitializeNet(input_signal, reservoir, input, output);

g = @tanh;                               % reservoir activation function
grid_search = false;

if grid_search                                           
    % parameter for grid search
    Palpha = linspace(0.9,0.9999,5);         % Leaking rate of each reservoir layer
    Pbeta  = logspace(-13,-10,4);            % regularization coefficient
    PinScale = linspace(0.001,0.2,4);        % the scailin of the input weight matrix
    bias = 1;                                % Input bias for reservoir and readout
    Connectivity = linspace(0.02,0.95,7);    % connections reservoir matrix
    [Alpha, Beta, Input_scaling, Connect] = GridSearch(input_signal, reservoir, X, ...
        Y0, K_reservoir, W_input, Palpha, Pbeta, PinScale, bias, Connectivity, g);

else   
    % Parametrs and weight
    Alpha = 0.9999;                           %Leaking rate of each reservoir layer
    Beta  = 1.0000e-13;                       %regularization coefficient
    Input_scaling = 1.0000e-03;               %the scailin of the input weight matrix
    Connect = 0.9;                            %connections reservoir matrix
end

Connect_Percent = Connect * 100;
Matrix_con = rand(size(K_reservoir))<Connect;  %matrix of with 90% element eq to 1
                                               %and 10% element eq to 0
K_finel = K_reservoir .* Matrix_con;
Win_finel = W_input .* Input_scaling;          %input weight matrix with scale 

%% training 
% calculate reservoir state
[Memory_Capacity_train, Y_train, Wout_train, ~, R_sq_train] = Training(input_signal, ...
    reservoir, X, Win_finel, K_finel, Y0, Alpha, Beta, g);


%% validation 

[X_valid, ~, ~, Y0_valid] = ...
    InitializeNet(input_signal, reservoir, input, output);

[Memory_Capacity_valid, Y_valid, ~, R_sq_valid] = Validation(input_signal, ...
    input, X, Win_finel, K_finel, Wout_train, Y0_valid, Alpha, g);

%% plot

figure
Plot1 = plot(R_sq_train);
Plot1.LineWidth = 4;
Plot1.Color = 'b';
hold on
Plot2 = plot(R_sq_valid);
Plot2.LineWidth = 2.5;
Plot2.Color = 'r';
hold off
title('ESN: Correlation coefficient square' ,'fontsize',17);
parametersPrint = {['alpha=' num2str(Alpha) ', beta=' num2str(Beta)...
   ', Input scaling=' num2str(Input_scaling) ', Connectivity=' num2str(Connect_Percent) '%'] ...
   ['Memory capacity training=' num2str(Memory_Capacity_train)...
   ', Memory capacity training=' num2str(Memory_Capacity_valid)]};
SubT = subtitle(parametersPrint,'fontsize',12);
SubT.Color = [0.23 0.5854 0.78];
xlabel('Output [Y]');
ylabel('Teacher [Y0]');
legend([Plot1 , Plot2],'train','valid','fontsize',15, 'Location','NorthEastOutside');

%%
toc

