# ESN-Network

This MATLAB code was used to find the best parameters for the network. We conducted a grid search and applied the parameters we obtained to compute the output connection matrix. These are the only connections learned in this network.

The code print a graph of correlation coefficient (R^2), which we used to compute the memory capacity.

Additionally, after multiple runs of the code, it appears that the network is stable, the memory capacity is approximately 90, and the validation set is very close to the training set.

How to Use:
Run the main.m script to execute the code.

Files Description:
main.m: MATLAB script for running the code.
GridSearch.m: Contains the functions for the grid search.
InitializeNet.m: iniate the matrix for the network and the teacher
Training.m: calculate reservoir state
Validation.n: calculating reservoir state on another random set of input
