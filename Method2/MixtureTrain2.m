function [w,a,em] = MixtureTrain2(w,a,Xtrain,Ftrain,ttrain,lamwt,lamat)

[~,Nf]=size(a);
[Nz,Nk,Nt]=size(w);

options = [];
options.display = 'none';
%options.maxFunEvals = 100;

em=0;

while em <= 20
    %E-step:
    em = em + 1;
    h = Qfun2(Xtrain,Ftrain,w,a);
    %M-step:
    
    w=reshape(minFunc(@wmax2,reshape(w,Nz*Nk*Nt,1),options,h,ttrain,Xtrain,lamwt),Nz,Nk,Nt);
    a=reshape(minFunc(@amax2,reshape(a,Nf*Nz,1),options,h,ttrain,Ftrain,lamat),Nz,Nf);
    
    
end



end
