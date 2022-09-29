function demo_lasso()
	% clc
%     rng(10);
addpath('utils/');
addpath('spams/build');
%     model = load('mnist_10000.mat');

% 	d      = 5; 	% data dimension
% 	N      = 10; 	% number of samples
% 	k      = 15; 	% dictionary size
lambda = 0.01;
%

Data = '/home/chenkaihuang/data_UCI/';
path = '/home/chenkaihuang/Documents/test0929_UCI_halpern_obj_rho19/'

if ~exist(path, 'dir')
    mkdir(path);
end
cd(path)

files = dir(strcat(Data,'*.mat'));
% 	Y      = normc(rand(d, N));
% 	D      = normc(rand(d, k));
%     result = rand(k, N);

for i = 1:length(files)
    Fig = figure;
    probname = [files(i).folder,filesep,files(i).name]
    m = load([probname]);
    Y = m.b;
    D = m.A;
    [~, lx] = size(D);
    DTDmap = @(x) (D'*(D*x));
    %     Y = normc(D*result);
    %% cost function
    %     function c = calc_F(X)
    %     c = (0.5*normF2(Y - D*X) + lambda*norm1(X));
    %     end
    %% helpern solution
    opts.max_iter = 100;
    opts.plot = 1;
    opts.verbose = true;
    opts.pos = false;
    opts.lambda = lambda;
    opts.backtracking = false;
    %     opts.result = result;
    opts.helpern = 1;
    opts.prox = 'F';
    %% Lipschitz constant
    L = eigs(DTDmap, lx, 1) + 1e-4;
    %     for rho = [1,1.5,1.6,1.9,2]
    for rho = 1.9
        opts.rho = rho;
        X_helpern = helpern_lasso(Y, D, L, [], opts);
        opts.helpern = 0;
        x_helpern = helpern_lasso(Y, D, L, [],opts);
        opts.prox = 'G';
        opts.helpern = 1;
        X_helpern = helpern_lasso(Y, D, L, [], opts);
        opts.helpern = 0;
        x_helpern = helpern_lasso(Y, D, L, [],opts);
    end
    % 	X_fista = fista_lasso(Y, D, [], opts);
    %% fista solution
    opts.pos = false;
    opts.lambda = lambda;
    opts.backtracking = false;
    %     X_helpern = helpern_lasso(Y, D, [], opts);
    X_fista = fista_lasso(Y, D, L, [], opts);
    %% PG solution
    % 	opts.pos = false;
    % 	opts.lambda = lambda;
    %     opts.backtracking = false;
    %     X_helpern = helpern_lasso(Y, D, [], opts);
    opts.prox = 'F';
    opts.rho = 1;
    opts.halpern = 0;
    X_fista = helpern_lasso(Y, D, L, [], opts);
    %% add legend
    legend('F\_hp', 'F', 'G\_hp', 'G', 'APG', 'PG')
    
    saveas(gcf, [pwd, '/', files(i).name(1:end-4), '.fig'])
    close(Fig);
end
    
    %% fista with backtracking 
%     opts.backtracking = true;
%     opts.L0 = 1; 
%     opts.eta = 1.5;
%     X_fista_bt = fista_lasso_backtracking(Y, D, [], opts);
	%% spams solution 
% 	param.lambda     = lambda;
% 	param.lambda2    = 0;
% 	param.numThreads = 1;
% 	param.mode       = 2;
% 	param.pos        = opts.pos;
% 	X_spams      = mexLasso(Y, D, param); 

	%% compare costs 
% % 	cost_spams = calc_F(X_spams);
% % 	cost_fista = calc_F(X_fista);
%     cost_helpern = calc_F(X_helpern);
%     cost_fista_bt = calc_F(X_fista_bt);
%     fprintf('Test lasso\n');
%     fprintf('cost_spams                   = %.5s\n', cost_spams);
% 	fprintf('cost_fista                   = %.5s\n', cost_fista);
%     fprintf('cost_helpern                   = %.5s\n', cost_helpern);
%     fprintf('cost_fista with backtracking = %.5s\n', cost_fista_bt);
end