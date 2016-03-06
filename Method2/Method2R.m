function [returnvalue] =  Method2R(File,part,l1,l2)
preA = 0;
MRRA = 0;
KLA = 0;
at = 0;
FilePath = strcat('./result/method2/',num2str(part),'/');
mkdir(FilePath );
fid = fopen(strcat(FilePath,'result_repeat_',num2str(l1),'_',num2str(l2),'.txt'),'w+');
fprintf(fid,'Method2 Repeat: %d part: %d lamda1: %d lamda2: %d\r\n',File,part,l1,l2);
fprintf('Method2 Repeat: %d part: %d lamda1: %d lamda2: %d\r\n',File,part,l1,l2);
for i=1:File
    [averpreA,averMRRA,averKLA,t] = Method2(i,part,l1,l2);
   if(i==1)
        preA=averpreA;
    else
        preA = preA+averpreA;
    end
    MRRA = averMRRA+ MRRA;
    KLA = averKLA+ KLA;
    at = t +at;
    fprintf(fid,'count: %d preA: %d,MRRA: %d,KLA: %d,at:%d \r\n',i,averpreA(1),averMRRA,averKLA,t);
    fprintf('count: %d preA: %d,MRRA: %d,KLA: %d,at:%d \r\n',i,averpreA(1),averMRRA,averKLA,t);
    [length,~] = size(averpreA);
    for j=1:length
        fprintf(fid, '	accu@ %d is %d\r\n',j,averpreA(j));
        fprintf('	accu@ %d is %d\r\n',j,averpreA(j));
    end
end
preA = preA/File;
MRRA = MRRA/File;
KLA = KLA/File;

fprintf('averpreA: %d,MRRA: %d,KLA: %d,at:%d \r\n',preA(1),MRRA,KLA,at);
fprintf(fid,'averpreA: %d,MRRA: %d,KLA: %d,at:%d \r\n',preA(1),MRRA,KLA,at);
for i=1:length
    fprintf(fid, 'accu@ %d is %d\r\n',i,preA(i));
    fprintf('accu@ %d is %d\r\n',i,preA(i));
end
fclose(fid);
returnvalue = preA(1);
end 