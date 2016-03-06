function [f,g] = wmax3(w,Xtrain,ttrain,lamda)

% Xtrain =[1,2,3;2,3,4];
% ttrain =[0.1,0.2,0.3;0.2,0.3,0.4];
%w = zeros(9,1);
[n,m]=size(Xtrain);
[nn,k]=size(ttrain);

ww = reshape(w,m,k);
expXw =exp(Xtrain * ww);
%expXw(find(expXw<1e-10))=1e-10;
suexp = sum(expXw,2);
suexp = repmat(suexp,1,k);
Y = expXw./suexp;

%L2 regularization
pen = ww.^2;
penalty = sum(sum(pen,1),2);
penalty = lamda*penalty/(k*m);

%calculation of negative log-likelihood
logY =log(Y);
f = -sum(sum(ttrain.*logY,1),2)+penalty;

%calculation of firstoder-derivative
pre = ttrain-Y;
gg = pre'*Xtrain;
gg = -gg'+2*ww*lamda/(k*m);
g = reshape(gg,m*k,1); 
