function X = helpern_lasso(Y, D, L, Xinit, opts)

    if ~isfield(opts, 'backtracking')
        opts.backtracking = false;
    end 

    opts = initOpts(opts);
    lambda = opts.lambda;

    if numel(lambda) > 1 && size(lambda, 2)  == 1
        lambda = repmat(opts.lambda, 1, size(Y, 2));
    end
    if numel(Xinit) == 0
        Xinit = zeros(size(D,2), size(Y,2));
    end
    %% cost f
    function cost = calc_f(X)
        cost = 1/2 *normF2(Y - D*X);
    end 
    %% cost function 
    function cost = calc_F(X)
        if numel(lambda) == 1 % scalar 
            cost = calc_f(X) + lambda*norm1(X);
        elseif numel(lambda) == numel(X)
            cost = calc_f(X) + norm1(lambda.*X);
        end
    end 
    %% gradient
    DtD = @(x) (D'*(D*x));
    DtY = D'*Y;
    function res = grad(X) 
        res = DtD(X) - DtY;
    end 
    %% Checking gradient 
    if opts.check_grad
        check_grad(@calc_f, @grad, Xinit);
    end 

%     opts.max_iter = 500;
    %% Use fista 
    [X, ~, ~] = helpern_general(@grad, @proj_l1, Xinit, L, opts, @calc_F);

end 