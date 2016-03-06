function [F,G] = amax2(x,h,t,f,lamda)

[Nd,Nf]=size(f);
[~,Nz,Nk]=size(h);

x = reshape(x,Nz,Nf);


pen = x.^2;

penalty = sum(sum(pen,1),2);
penalty = lamda * penalty/Nz/Nf;

F=penalty; % function value
G=2*x*lamda/Nz/Nf; % gradient 


%calculate sum of h in j

gg = exp(f*x');
su = sum(gg,2);

sur = repmat(su,1,Nz);

ggnl = gg./sur;
gg = log(ggnl);

hh = reshape(h,Nd,Nk*Nz);

tt = reshape(t,Nd,1,Nk);
tt = repmat(tt,[1 Nz 1]);
tt = reshape(tt,Nd,Nk*Nz);
ggg = repmat(gg,1,Nk);
hh = hh.*tt;
hhh = hh.*ggg;

%%%%%
F = F-sum(sum(hhh,1),2)/Nd;

%calculate the gradient

gg = ones(Nd,Nz)-ggnl;

hhh = reshape(hh,Nd,Nz,Nk);
hsum = reshape(sum(hhh,3),Nd,Nz);
hsum = hsum.*gg;

G = G - hsum'*f/Nd ;

G = reshape(G,Nz*Nf,1);

%fprintf('AMAX: The F is %d now\n',F);
end
