function [averpre,averMRR,averKL,t] = Method4C(File,part,x,y,z)
%% parameter
warning off all
addpath('./minFunc/');
addpath('./source/');
FilePath = strcat('./result/method4/',num2str(part),'_',num2str(File),'/');
mkdir(FilePath );
addpath(FilePath);

dimension = 1416;

doc_numA = 4088;
classnumA = 8;
nameA = 'A';

doc_numB = 7500 ;
classnumB = 8;
nameB='B';
cross=10;

lambda1=x;
lambda2=y;
lambda3=z;
%% Load
finputA=load(strcat('Feature',nameA,'inAorBFilter.txt'));
ftmatrixA = sparse(finputA(:,1), finputA(:,2), finputA(:,3),doc_numA, dimension);
ftmatrixA = full(ftmatrixA);

TA1=load(strcat('EmotionPro',nameA,'Filter.txt'));



ftmatrixA = ftmatrixA./repmat(max(ftmatrixA,[],1),doc_numA,1);
ftmatrixA1 =[ones(doc_numA,1),ftmatrixA];



finputB=load(strcat('Feature',nameB,'inAorBFilter.txt'));
ftmatrixB = sparse(finputB(:,1), finputB(:,2), finputB(:,3),doc_numB, dimension);
ftmatrixB=full(ftmatrixB);

TB1=load(strcat('EmotionPro',nameB,'Filter.txt'));


ftmatrixB = ftmatrixB./repmat(max(ftmatrixB,[],1),doc_numB,1);
ftmatrixB1 =[ones(doc_numB,1),ftmatrixB];
%% new array

tic
count=0;
fidall = fopen(strcat(FilePath,'result_all.txt'),'w+');

%% init read parameter
cate_count_t=classnumA;
cate_count_s=classnumB;
rand=reshape(randperm(doc_numA),1,doc_numA);
ftmatrixA = ftmatrixA1(rand(1,1:floor(doc_numA/part)),:);
TA = TA1(rand(1,1:floor(doc_numA/part)),:);


ftmatrixB = ftmatrixB1;
TB = TB1;

bsizeA=(doc_numA/part)/cross;
betaB=reshape(load(strcat('B',nameA,'.txt')),doc_numB,1);

averpre =zeros(classnumA,1);
averMRR = 0;
averKL = 0;

for l1 = lambda1
    for l2 = lambda2
        for l3 = lambda3
            tic
            fid = fopen(strcat(FilePath,'result_',num2str(l1),'_',num2str(l2),'_',num2str(l3),'.txt'),'w+');
            
            totalpre =zeros(classnumA,1);
            totalMRR = 0;
            totalKL = 0;
            
            
            count=count+1;
            
            fprintf(fid,'count:%d l1:%d l2:%d l3:%d  docA:%d docB:%d\r\n',count,l1,l2,l3,doc_numA,doc_numB);
            fprintf('count:%d l1:%d l2:%d l3:%d  docA:%d docB:%d\r\n',count,l1,l2,l3,doc_numA,doc_numB);
            for j = 1:cross
                ttrainA=[TA(1:floor(bsizeA*(j-1)),:);TA(1+floor(bsizeA*j):end,:)];  % emotion distribution for training
                ttestA=[TA(floor(1+bsizeA*(j-1)):floor(bsizeA*j),:);TA1(rand(1,1+floor(doc_numA/part):end),:)];  % emotion distribution for testing
                
                FtrainA = [ftmatrixA(1:floor(bsizeA*(j-1)),:);ftmatrixA(1+floor(bsizeA*j):end,:)];
                FtestA = [ftmatrixA(1+floor(bsizeA*(j-1)):floor(bsizeA*j),:);ftmatrixA1(rand(1,1+floor(doc_numA/part):end),:)];
                
                
                [w_tmp, v_tmp] = train(ftmatrixB, TB, FtrainA, ttrainA,cate_count_s, cate_count_t, l1, l2, l3,betaB);
                w_tmp = reshape(w_tmp, dimension+1, cate_count_s); %de-vectorize
                v_tmp = reshape(v_tmp, cate_count_s + 1, cate_count_t);
                [pre,MRR,KL] = test_CDCCET(FtestA, ttestA, w_tmp, v_tmp);
                fprintf(fid,'       Cross %d		pre %d%d%d\r\n',j,pre(1,1),MRR,KL);
                fprintf('       Cross %d		pre %d%d%d\r\n',j,pre(1,1),MRR,KL);
                totalpre = totalpre + pre;
                totalMRR = totalMRR + MRR;
                totalKL = totalKL + KL;
            end
            totalpre = totalpre/cross ;
            totalMRR = totalMRR /cross;
            totalKL = totalKL /cross;
            for pat =1:classnumA
                fprintf(fid, '      A: accuracy at: %d is %d\r\n',pat,totalpre(pat,1));
            end
            fprintf(fid,'       A: MRR is %d \r\n',totalMRR);
            fprintf(fid,'       A: KL is %d \r\n',totalKL);
            
            fprintf( '      A: accuracy at: %d is %d\r\n',pat,totalpre(1,1));
            fprintf('       A: MRR is %d \r\n',totalMRR);
            fprintf('       A: KL is %d \r\n',totalKL);
            fclose(fid);
            
            averpre = averpre + totalpre;
            averMRR = averMRR + totalMRR;
            averKL = averKL + totalKL;
            toc
        end
    end
end
fclose(fidall);
t=toc;
end

