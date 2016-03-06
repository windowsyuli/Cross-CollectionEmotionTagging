function [F,G] = wmax2(x,h,t,s,lamda)


[Nc,Nt]=size(s);
[~,Nz,Nk]=size(h);

x = reshape(x,Nz,Nk,Nt);



pen = x.^2;

penalty = sum(sum(sum(pen,1),2),3);
penalty = lamda * penalty/Nk/Nt/Nz;

F=penalty; % function value
G=2*x*lamda/Nk/Nt/Nz; % gradient 

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
hhh = hh.*ggg;

F = F-sum(sum(sum(hhh,1),2),3)/Nc;

%calculate the gradient

iden = eye(Nk);

tt = reshape(t,Nc,1,Nk);
tt = repmat(tt,[1,Nz,1]);

hh = tt.*h;

hh = reshape(hh,Nc*Nz,Nk);

hhi = reshape(hh*iden,Nc,Nz,Nk);

sumhh = reshape(sum(hh,2),Nc,Nz);
sumhh = repmat(sumhh,1,Nk);
sumhh = reshape(sumhh,Nc,Nz,Nk);
sumhh = sumhh.*gg;

hhig = reshape(hhi-sumhh,Nc,Nz*Nk);

G = G- reshape(hhig'*s,Nz,Nk,Nt)/Nc;


G = reshape(G,Nz*Nk*Nt,1);
%fprintf('WMAX: The F is %d now\n',F);
end