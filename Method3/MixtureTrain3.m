function [www] = MixtureTrain3(www,Xtrain,ttrain,lamwt)



options = [];
options.display = 'none';
options.maxFunEvals = 50;

www=minFunc(@wmax3,www,options,Xtrain,ttrain,lamwt);

end
