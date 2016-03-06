function L

max= 0;
xx =-99;
repeat = 20;
Part =64;
fprintf('Part: %d \r\n',Part);
for i=5
    [averpreA] = Method3R(repeat,Part,i);
    if(averpreA>max)
        max= averpreA;
        xx =i;
    end
end
fprintf('max: %d %d',xx,max);
end

