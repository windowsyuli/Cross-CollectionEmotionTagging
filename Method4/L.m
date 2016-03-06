function L
max= 0;
xx =-99;
yy=-99;
zz=-99;
repeat = 20;
Part =4;
fprintf('Part: %d \r\n',Part);
for i=2
    for j=4
        for k=-9
            [averpreA] = Method4R(repeat,Part,i,j,k);
            if(averpreA>max)
                max= averpreA;
                xx =i;
                yy =j;
                zz =k;
            end
        end
    end
end
fprintf('max: %d %d %d %d',xx,yy,zz,max);
end

