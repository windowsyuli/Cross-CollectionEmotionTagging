function [F,G] = amax1(x,hA,hB,tA,fA,tB,fB,lamda1,lamda2,beta)%,lamdb

[NdA,Nf]=size(fA);
[~,Nz,NkA]=size(hA);
[NdB,~]=size(fB);
[~,~,NkB]=size(hB);
b =repmat(reshape(beta,NdB,1),1,NkB*Nz);


x = reshape(x,Nz,Nf);


pen = x.^2;

penalty = sum(sum(pen,1),2);
penalty = penalty/Nz/Nf;

F=penalty; % function value
G=2*x/Nz/Nf; % gradient 


%calculate sum of h in j

ggA = exp(fA*x');
suA = sum(ggA,2);

surA = repmat(suA,1,Nz);

ggnlA = ggA./surA;
ggA = log(ggnlA);

hhA = reshape(hA,NdA,NkA*Nz);

ttA = reshape(tA,NdA,1,NkA);
ttA = repmat(ttA,[1 Nz 1]);
ttA = reshape(ttA,NdA,NkA*Nz);
gggA = repmat(ggA,1,NkA);
hhA = hhA.*ttA;
hhhA = hhA.*gggA;

%%%%%%%
ggB = exp(fB*x');
suB = sum(ggB,2);

surB = repmat(suB,1,Nz);

ggnlB = ggB./surB;
ggB = log(ggnlB);

hhB = reshape(hB,NdB,NkB*Nz);

ttB = reshape(tB,NdB,1,NkB);
ttB = repmat(ttB,[1 Nz 1]);
ttB = reshape(ttB,NdB,NkB*Nz);
gggB = repmat(ggB,1,NkB);
hhB = b.*hhB.*ttB;
hhhB = hhB.*gggB;

%%%%%
F = F-lamda1/NdA*sum(sum(hhhA,1),2)-lamda2/NdB*sum(sum(hhhB,1),2);%*lamdb

%calculate the gradient

ggA = ones(NdA,Nz)-ggnlA;

hhhA = reshape(hhA,NdA,Nz,NkA);
hsumA = reshape(sum(hhhA,3),NdA,Nz);
hsumA = hsumA.*ggA;

%%%%
ggB = ones(NdB,Nz)-ggnlB;

hhhB = reshape(hhB,NdB,Nz,NkB);
hsumB = reshape(sum(hhhB,3),NdB,Nz);
hsumB = hsumB.*ggB;

%%%
G = G - lamda1/NdA*hsumA'*fA - lamda2/NdB*(hsumB'*fB);%*lamdb

G = reshape(G,Nz*Nf,1);

%fprintf('AMAX: The F is %d now\n',F);
end