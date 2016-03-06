function [f, g1] = model_CDCCET_w(w1, X_s, L_s, X_t, L_t, beta, lambda1, lambda2, cate_count_s, cate_count_t, v1)%

[N_s, M] = size(X_s);
[N_t, ~] = size(X_t);

w = reshape(w1, M, cate_count_s); %de-vectorize
v = reshape(v1, cate_count_s + 1, cate_count_t);

tmp = exp(X_s * w);
phi_s = tmp ./ repmat(sum(tmp,2), 1, cate_count_s);

tmp = exp(X_t * w);
phi_t1 = tmp ./ repmat(sum(tmp,2), 1, cate_count_s);
phi_t = [phi_t1, ones(N_t, 1)];
tmp = exp(phi_t * v);
Xi_t = tmp ./ repmat(sum(tmp,2), 1, cate_count_t);

%loss function
log_Xi_t = log(Xi_t);
log_phi_s = log(phi_s);
f = - sum(sum( log_Xi_t.* L_t,2),1) * exp(lambda1) / N_t  ...
    - sum(beta .* sum(log_phi_s.*L_s,2),1) * exp(lambda2) / N_s ...
    + trace(w' * w); 
    %+ exp(lambda3) * trace(v' * v);

% gradient
delta = (L_t-Xi_t)*v';

bb=zeros(N_t, cate_count_s+1,cate_count_s);
for i = 1:cate_count_s
    b = zeros(N_t, cate_count_s);
    b(:, i) = ones(N_t, 1);
    b = phi_t1 .* (b - phi_t1);
    b(:,cate_count_s+1)=phi_t1(:,i);
    bb(:,:,i)=b;        
end 
k=zeros(1,cate_count_s*M);
for i= 1:N_t
    b= reshape(bb(i,:,:),(cate_count_s+1)*cate_count_s,1);
    x= reshape(X_t(i,:),1,M);
    k =k+delta(i,:)*reshape(b*x,(cate_count_s+1),cate_count_s*M);
end

% kk=-(L_t-Xi_t)*v'*(X_t'*phi_t.*(zeros(N_t, cate_count_s+1)-phi_t))';
% 
% 
% 
% 
% a = L_t - Xi_t;
% %a = a(sub2ind(size(Xi_t), 1:N_t, L_t'));
% a=sum(a,2);
% c = zeros(N_t, cate_count_s);
% %g = zeros(M * cate_count_s);
% 
% for i = 1:cate_count_s
%     b = zeros(N_t, cate_count_s); %not bug, but not good
%     b(:, cate_count_s + 1) = ones(N_t, 1); % b = [b,ones(N_t,1)]
%     b(:, i) = ones(N_t, 1);
%     b = phi_t .* (b - phi_t) * v;
%     %b = b(sub2ind(size(Xi_t), 1:N_t, L_t'));
%     %b=sum(b.*L_t,2);
%     b=sum(b,2);
%     c(:, i) = b;
%     %g(:, i) = - sum(X_t' * diag(a .* b), 2) ...           
% end
% kk=X_t' * diag(a) * c ;
%  fprintf('piandao %d\r\n',kk);
k = reshape(k,M,cate_count_s);
g = -  k* exp(lambda1)/ N_t...
    - X_s' * diag(beta) * (L_s - phi_s) * exp(lambda2) / N_s...  
    + 2 * w;

g1 = reshape(g, M*cate_count_s, 1); %vectorize

