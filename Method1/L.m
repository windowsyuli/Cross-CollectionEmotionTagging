function L

max= 0;
xx =-99;
yy=-99;
zz =-99;
bb =-99;
Part=8;
repeat =20;
fprintf('Part: %d \r\n',Part);
for i=2
    for j=0
        for k =5
            for l =0
                [averpreA] = Method1R(repeat,Part,i,j,k,l);
                if(averpreA>max)
                    max= averpreA;
                    xx =i;
                    yy =j;
                    zz=k;
                    bb= l;
                end
            end
        end
    end
end
fprintf('max: %d %d %d %d %d',xx,yy,zz,bb,max);
end

