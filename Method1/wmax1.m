function [F,G] = wmax1(x,h,t,s,lamda1,lamda2,beta)

[Nc,Nt]=size(s);%word weight
[~,Nz,Nk]=size(h);%Q

b =repmat(reshape(beta,Nc,1,1),1,Nz,Nk);

x = reshape(x,Nz,Nk,Nt);%para

pen = x.^2;

penalty = sum(sum(sum(pen,1),2),3);
penalty = lamda1 * penalty/Nk/Nt/Nz;

F=penalty; % function value
G=2*x*lamda1/Nk/Nt/Nz; % gradient 

%calculate sum of h in j

xx = reshape(x,Nz*Nk,Nt);

gg = exp(s*xx');
ggg = reshape(gg,Nc,Nz,Nk);
su = reshape(sum(ggg,3),Nc,Nz);
su = repmat(su,1,Nk);

gg = reshape(gg./su,Nc,Nz,Nk);

ggg = log(gg);

tt = reshape(t,Nc,1,Nk);
tt = repmat(tt,[1 Nz 1]);

hh = tt.*h;
hhh = b.*hh.*ggg;

F = F-lamda2/Nc*sum(sum(sum(hhh,1),2),3);

%calculate the gradient

iden = eye(Nk);

tt = reshape(t,Nc,1,Nk);
tt = repmat(tt,[1,Nz,1]);

hh = b.*tt.*h;

hh = reshape(hh,Nc*Nz,Nk);

hhi = reshape(hh*iden,Nc,Nz,Nk);

sumhh = reshape(sum(hh,2),Nc,Nz);
sumhh = repmat(sumhh,1,Nk);
sumhh = reshape(sumhh,Nc,Nz,Nk);
sumhh = sumhh.*gg;

hhig = reshape(hhi-sumhh,Nc,Nz*Nk);

G = G- lamda2/Nc*reshape(hhig'*s,Nz,Nk,Nt);


G = reshape(G,Nz*Nk*Nt,1);
%fprintf('WMAX: The F is %d now\n',F);
end