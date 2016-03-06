function [returnvalue] =  Method1R(File,part,l1,l2,l3,l4)
em = 0;
preA = 0;
MRRA = 0;
KLA = 0;
preB = 0;
MRRB = 0;
KLB = 0;
at = 0;
FilePath = strcat('./result/method1/',num2str(part),'/');
mkdir(FilePath );
fid = fopen(strcat(FilePath,'result_repeat_',num2str(l1),num2str(l2),num2str(l3),num2str(l4),'.txt'),'w+');
fprintf(fid,'Method1 Repeat: %d part: %d lamda1: %d lamda2: %d lamda3: %d lamda4: %d\r\n',File,part,l1,l2,l3,l4);
fprintf('Method1 Repeat: %d part: %d lamda1: %d lamda2: %d lamda3: %d lamda4: %d\r\n',File,part,l1,l2,l3,l4);
for i=1:File
    [averpreA,averMRRA,averKLA,averpreB,averMRRB,averKLB,t] = Method1(i,part,l1,l2,l3,l4);
    %     em = averem +em;
    %     preA = averpreA(1)+ preA;
    %     MRRA = averMRRA+ MRRA;
    %     KLA = averKLA+ KLA;
    %     preB = averpreB(1)+ preB;
    %     MRRB = averMRRB+ MRRB;
    %     KLB = averKLB+ KLB;
    %     at = t +at;
    % 	fprintf('      em: %d,preA: %d,MRRA: %d,KLA: %d,preB: %d,MRRB: %d,KLB: %d,at:%d \r\n',averem,averpreA(1),averMRRA,averKLA,averpreB(1),averMRRB,averKLB,at);
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
preA =preA /File;
MRRA =MRRA /File;
KLA = KLA /File;

fprintf('averpreA: %d,MRRA: %d,KLA: %d,at:%d \r\n',preA(1),MRRA,KLA,at);
fprintf(fid,'averpreA: %d,MRRA: %d,KLA: %d,at:%d \r\n',preA(1),MRRA,KLA,at);
for i=1:length
    fprintf(fid, 'accu@ %d is %d\r\n',i,preA(i));
    fprintf( 'accu@ %d is %d\r\n',i,preA(i));
end
fclose(fid);
returnvalue = preA(1);
end