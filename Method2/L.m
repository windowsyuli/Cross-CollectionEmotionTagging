function L
max= 0;
xx =-99;
yy=-99;
repeat = 20;
Part =64;
fprintf('Part: %d \r\n',Part);
for i=4
    for j=6
        [averpreA] = Method2R(repeat,Part,i,j);
        if(averpreA>max)
            max= averpreA;
            xx =i;
            yy =j;
        end
    end
end
fprintf('max: %d %d %d',xx,yy,max);
end

