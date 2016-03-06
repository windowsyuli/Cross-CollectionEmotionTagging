function [w, v] = train(X_s, L_s, X_t, L_t, cate_count_s, cate_count_t,l1_opt,l2_opt,l3_opt,bw_opt)
[N_s, M] = size(X_s);
[N_t, ~] = size(X_t);
%train 

% fprintf('-----KDE start-----\r\n');
% %KDE bandwidth
% bandwidth = bw_opt;
% %ratio of category marginal probability between source and target (by kernel density estimation)
% pr_cate_marg = zeros(N_s,1);
% for i = 1:N_s
%     if(mod(N_s,10)==0)
%         fprintf('1/r/n');
%     end
%     pr_cate_marg_t = sum(exp(-sqrt(sum((repmat(X_s(i, :), N_t, 1) - X_t).^2, 2)) / bandwidth ^ 2));
%     pr_cate_marg_s = sum(exp(-sqrt(sum((repmat(X_s(i, :), N_s, 1) - X_s).^2, 2)) / bandwidth ^ 2)) - 1;
%     pr_cate_marg(i) = pr_cate_marg_t / pr_cate_marg_s;
% end
% %beta = pr_cate * pr_cate_marg
% beta = pr_cate_marg;
beta =bw_opt;
%fprintf('-----Optimization start-----\r\n');
%optimization
options = [];
options.display = 'none';
%options.maxFunEvals = 1000;
options.Methods = 'lbfgs';
options.Corr = 2000;
w_old = zeros(M * cate_count_s, 1);
v_old = zeros((cate_count_s + 1) * cate_count_t, 1);
w = w_old;
v = v_old;

%[w] = minFunc(@model_CDCCET_w, w, options, X_s, L_s, X_t, L_t, beta, l1_opt, l2_opt, cate_count_s, cate_count_t, v_old);
%[v] = minFunc(@model_CDCCET_v, v, options, X_t, L_t, l1_opt, l3_opt, cate_count_s, cate_count_t, w);
%w_old = w;
%v_old = v;
%options.maxFunEvals = 100;
%fprintf('Init w\r\n');
while true
    %optimize w2,v iteratively
    %w = rand(M * cate_count_s, 1);
    [w] = minFunc(@model_CDCCET_w, w, options, X_s, L_s, X_t, L_t, beta, l1_opt, l2_opt, cate_count_s, cate_count_t, v_old);
    %norm(w)
    model_CDCCET_w(w, X_s, L_s, X_t, L_t, beta, l1_opt, l2_opt, cate_count_s, cate_count_t, v_old);
    %fprintf('Iteration err ratio w: %f\r\n', norm(w - w_old)/norm(w_old));
    %v = rand(cate_count_s * cate_count_t, 1);
    [v] = minFunc(@model_CDCCET_v, v, options, X_t, L_t, l1_opt, l3_opt, cate_count_s, cate_count_t, w);

    %convergence condition
    %fprintf('Iteration err ratio v: %f\r\n', norm(v - v_old)/norm(v_old));
    if norm(w - w_old)/norm(w_old) < 0.2 && norm(v - v_old)/norm(v_old) < 0.2
        %fprintf('-----Convergency-----\r\n')
        break
    end
    w_old = w;
    v_old = v;
end
end