function h=Qfun2(s,f,w,a)

    [Nc,tmp]=size(s);
    [Nz,Nk,Nt]=size(w);

    
ww = reshape(w,Nz*Nk,Nt);

gg = exp(s*ww');
ggg = reshape(gg,Nc,Nz,Nk);
su = reshape(sum(ggg,3),Nc,Nz);    
su = repmat(su,1,Nk);

gg = reshape(gg./su,Nc,Nz,Nk);

af = exp(f*a');
%sumaf = (sum(af))';
af = repmat(af,1,Nk);
af = reshape(af,Nc,Nz,Nk);
afgg = af.*gg;
sumafgg = sum(afgg,2);
sumafgg = repmat(sumafgg,[1 Nz 1]);

h = afgg./sumafgg;

end
