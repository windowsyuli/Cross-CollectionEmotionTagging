function [p,MRR,KL] = test_CDCCET(X_test, L_test, w, v)
%calculate accu@1 for test data

N = length(L_test);

[cate_count_s, cate_count_t] = size(v);

cate_count_s = cate_count_s - 1;
tmp = exp(X_test * w);
phi_test = tmp ./ repmat(sum(tmp,2), 1, cate_count_s);
phi_test = [phi_test, ones(N,1)];
tmp = exp(phi_test * v);
Xi_test = tmp ./ repmat(sum(tmp,2), 1, cate_count_t);
%[~, L_pre] = max(Xi_test, [], 2);

%accu_test = sum(L_pre == L_test) / N;
 
%by lili
KL = 0;
MRR = 0;
at= cate_count_t;
correct = zeros(at, 1);
for nn=1:N
    [P,PI] = sort(L_test(nn,:),'descend');
    [C,CI] = max(Xi_test(nn,:));
    for att = 1:at
        if L_test(nn,att) ~= 0
            KL = KL + L_test(nn,att)*log(L_test(nn,att)/Xi_test(nn,att));
        end
        if PI(att)==CI;
            correct(att) = correct(att)+1;
            MRR = MRR + 1.0/att;
            break;
        end
    end
    
end

MRR = MRR/N;
KL = KL/N;

p = zeros(at,1);
for att = 1:at
    for attt = 1:att
        p(att) =  p(att) + correct(attt);
    end
    p(att) = p(att)/N;
end
end