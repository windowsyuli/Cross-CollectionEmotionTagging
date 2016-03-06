function [wA,wB,a,em] = MixtureTrain1(wA,wB,a,XtrainA,FtrainA,ttrainA,XtrainB,FtrainB,ttrainB,lamwA,lamwB,lamf,lama,betaA,betaB)%,lamb,XtestA,FtestA,ttestA,classnumA,XtestB,FtestB,ttestB,classnumB

[~,Nf]=size(a);
[Nz,NkA,NtA]=size(wA);
[~,NkB,NtB]=size(wB);

options = [];
options.display = 'none';
%options.maxFunEvals = 50;
em=0;


while em <= 20
    
    %E-step:
    
    em = em + 1;
    
    hA = Qfun1(XtrainA,FtrainA,wA,a);
    hB = Qfun1(XtrainB,FtrainB,wB,a);
    
    %M-step:
    
    wA=reshape(minFunc(@wmax1,reshape(wA,Nz*NkA*NtA,1),options,hA,ttrainA,XtrainA,lamwA,lamf,betaA),Nz,NkA,NtA);
    wB=reshape(minFunc(@wmax1,reshape(wB,Nz*NkB*NtB,1),options,hB,ttrainB,XtrainB,lamwB,lama,betaB),Nz,NkB,NtB);
    a=reshape(minFunc(@amax1,reshape(a,Nf*Nz,1),options,hA,hB,ttrainA,FtrainA,ttrainB,FtrainB,lamf,lama,betaB),Nz,Nf);%,lamb
    
    %lA = likelihood(wA,a,XtrainA,FtrainA,ttrainA);
    %lB = likelihood(wB,a,XtrainB,FtrainB,ttrainB);
    
end
%    fprintf('\r\nLikelihood_A: %d\r\n',lA);
%    fprintf('Likelihood_B: %d\r\n',lB);
%    fprintf('Likelihood_A+B: %d\r\n',lA+lB);
%     
%    [preA,~,~] = MixtureTest(wA,a,XtestA,FtestA,ttestA,classnumA);
%    [preB,~,~] = MixtureTest(wB,a,XtestB,FtestB,ttestB,classnumB);
%     
%    fprintf('step %d  PrecisionA %d   PrecisionB %d\r\n',em,preA(1),preB(1))
end
