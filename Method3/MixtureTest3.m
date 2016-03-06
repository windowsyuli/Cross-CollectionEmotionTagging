function [p,MRR,KL] = MixtureTest3(w, X, t,at)
[n,m] = size(X);
[tn,k]=size(t);

correct = zeros(at, 1);

KL = 0;

ww = reshape(w,m,k);
expXw =exp(X * ww);

suexp = sum(expXw,2);
suexp = repmat(suexp,1,k);
Pro = expXw./suexp;
MRR = 0;

for nn=1:n
    [P,PI] = sort(t(nn,:),'descend');
    [C,CI] = max(Pro(nn,:));
    for att = 1:at
        if t(nn,att) ~= 0
            KL = KL + t(nn,att)*log(t(nn,att)/Pro(nn,att));
        end
        
        if PI(att)==CI;
            correct(att) = correct(att)+1;
            MRR = MRR + 1.0/att;
            break;
        end
    end
    
end

MRR = MRR/n;
KL = KL/n;

p = zeros(at,1);
for att = 1:at
    for attt = 1:att
        p(att) =  p(att) + correct(attt);
    end
    p(att) = p(att)/n;
end
end


