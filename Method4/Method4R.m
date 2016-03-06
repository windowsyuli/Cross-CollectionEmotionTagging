function [returnvalue] =  Method4R(File,part,l1,l2,l3)
preA = 0;
MRRA = 0;
KLA = 0;
at = 0;
FilePath = strcat('./result/method4/',num2str(part),'/');
mkdir(FilePath );
fid = fopen(strcat(FilePath,'result_repeat_',num2str(l1),'_',num2str(l2),'_',num2str(l3),'.txt'),'w+');
fprintf(fid,'Method4 Repeat: %d part: %d l1: %d l2: %d l3: %d\r\n',File,part,l1,l2,l3);
fprintf('Method4 Repeat: %d part: %d l1: %d l2: %d l3: %d\r\n',File,part,l1,l2,l3);
length =0;
for i=1:File
    [averpreA,averMRRA,averKLA,t] = Method4(i,part,l1,l2,l3);
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

fprintf('\r\naverpreA: %d,MRRA: %d,KLA: %d,at:%d \r\n',preA(1),MRRA,KLA,at);
fprintf(fid,'\r\naverpreA: %d,MRRA: %d,KLA: %d,at:%d \r\n',preA(1),MRRA,KLA,at);
for i=1:length
    fprintf(fid, 'accu@ %d is %d\r\n',i,preA(i));
    fprintf('accu@ %d is %d\r\n',i,preA(i));
end
fclose(fid);
returnvalue = preA(1);
end 