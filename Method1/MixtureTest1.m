 function [p,MRR,KL] = MixtureTest1(w,a,s,f,t,at)

[Nz,Nk,Nt]=size(w);
[Nc,~] = size(s);

correct = zeros(at,1);

ww = reshape(w,Nz*Nk,Nt);

gg = exp(s*ww');
ggg = reshape(gg,Nc,Nz,Nk);
su = reshape(sum(ggg,3),Nc,Nz);
su = repmat(su,1,Nk);

gg = reshape(gg./su,Nc,Nz,Nk);

af = exp(f*a');
sumaf = sum(af,2);
af = repmat(af,1,Nk);
af = reshape(af,Nc,Nz,Nk);
afgg = af.*gg;
sumafgg = reshape(sum(afgg,2),Nc,Nk);

sumaf = repmat(sumaf,1,Nk);
pro = sumafgg./sumaf;

%%%%%need to revise%%%%%%%
MRR = 0;
KL = 0;

for nn=1:Nc
    [P,PI] = sort(t(nn,:),'descend');
    [C,CI] = max(pro(nn,:));
    for att = 1:at
        if t(nn,att) >0  && pro(nn,att) > 0
            KL = KL + t(nn,att)*(log(t(nn,att))-log(pro(nn,att)));
        end
        if PI(att)==CI;
            correct(att) = correct(att)+1;
            MRR = MRR + 1.0/att;
            break;
        end      
    end
end
MRR = MRR/Nc;
KL = KL/Nc;

%fclose(fcid);
p = zeros(at,1);
for att = 1:at
    for attt = 1:att
        p(att) =  p(att) + correct(attt);
    end
    p(att) = p(att)/Nc;
end

%%%%%%%%%%%%%%
end