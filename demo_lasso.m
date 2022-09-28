function demo_lasso()
	% clc
%     rng(10);
    addpath('utils/');
    addpath('spams/build');    
%     model = load('mnist_10000.mat');
    
	d      = 10; 	% data dimension
	N      = 20; 	% number of samples 
	k      = 30; 	% dictionary size 
	lambda = 0.01;
    
	Y      = normc(rand(d, N));
	D      = normc(rand(d, k));
    result = rand(k, N);
%     Y = normc(D*result);
	%% cost function 
    function c = calc_F(X)
        c = (0.5*normF2(Y - D*X) + lambda*norm1(X));
    end
    %% helpern solution 
    opts.max_iter = 500;
    opts.plot = 2;
    opts.verbose = true;
	opts.pos = false;
	opts.lambda = lambda;
    opts.backtracking = false;
    opts.result = result;
    opts.helpern = 1;
%     for rho = [1,1.5,1.6,1.9,2]
for rho = 1.5
        opts.rho = rho;
        X_helpern = helpern_lasso(Y, D, [], opts);
        opts.helpern = 0;
        x_helpern = helpern_lasso(Y,D,[],opts);
    end
% 	X_fista = fista_lasso(Y, D, [], opts);
    %% fista solution 
	opts.pos = false;
	opts.lambda = lambda;
    opts.backtracking = false;
%     X_helpern = helpern_lasso(Y, D, [], opts);
	X_fista = fista_lasso(Y, D, [], opts);
    %% fista with backtracking 
%     opts.backtracking = true;
%     opts.L0 = 1; 
%     opts.eta = 1.5;
%     X_fista_bt = fista_lasso_backtracking(Y, D, [], opts);
	%% spams solution 
	param.lambda     = lambda;
	param.lambda2    = 0;
	param.numThreads = 1;
	param.mode       = 2;
	param.pos        = opts.pos;
	X_spams      = mexLasso(Y, D, param); 

	%% compare costs 
	cost_spams = calc_F(X_spams);
	cost_fista = calc_F(X_fista);
    cost_helpern = calc_F(X_helpern);
%     cost_fista_bt = calc_F(X_fista_bt);
    fprintf('Test lasso\n');
    fprintf('cost_spams                   = %.5s\n', cost_spams);
	fprintf('cost_fista                   = %.5s\n', cost_fista);
    fprintf('cost_helpern                   = %.5s\n', cost_helpern);
%     fprintf('cost_fista with backtracking = %.5s\n', cost_fista_bt);
    
end