function [averem,averpre,averMRR,averKL,t]=Method2C(File,part,x,y)

%% parameter

warning off all
addpath('./minFunc/');
addpath('./source/');
FilePath = strcat('./result/method2/',num2str(part),'_',num2str(File),'/');
mkdir(FilePath );
addpath(FilePath);

doc_numA = 4088;
dimensionA = 266;
classnumA = 8;
nameA = 'A';


ftnum = 1416;%or
latentnum=3;

read=0;

cross=10;
sigma = 1;

lamas=x;
lamae=x;
stepa=1;

lamwas=y;
lamwae=y;
stepwa=1;

deleteA=[];
%% Load

sinputA=load(strcat('EmotionFeature',nameA,'Filter.txt'));
doc_term_matrixA = sparse(sinputA(:,1), sinputA(:,2), sinputA(:,3),doc_numA, dimensionA);
doc_term_matrixA=full(doc_term_matrixA);
finputA=load(strcat('Feature',nameA,'inAorBFilter.txt'));
ftmatrixA = sparse(finputA(:,1), finputA(:,2), finputA(:,3),doc_numA, ftnum);
ftmatrixA=full(ftmatrixA);
TA1=load(strcat('EmotionPro',nameA,'Filter.txt'));

doc_term_matrixA(deleteA,:)=[];
doc_term_matrixA = doc_term_matrixA./repmat(max(doc_term_matrixA,[],1),doc_numA,1);
doc_term_matrixA1 = [ones(doc_numA,1),doc_term_matrixA];

ftmatrixA(deleteA,:)=[];
ftmatrixA = ftmatrixA./repmat(max(ftmatrixA,[],1),doc_numA,1);
ftmatrixA1 =[ones(doc_numA,1),ftmatrixA];

TA1(deleteA,:)=[];
%% new array

tic
count=0;
fidall = fopen(strcat(FilePath,'result_all.txt'),'w+');
%% init read parameter
if(read == 1)
    inputwA = load(strcat('rwA.txt'));
    inputa = load(strcat('ra.txt'));
    inputran = randperm(doc_numA);
else
    inputwA = normrnd(0,sigma,latentnum,classnumA,dimensionA+1);
    inputa = normrnd(0,sigma,latentnum,ftnum+1);
    inputran = randperm(doc_numA);
    
    fidwA = fopen(strcat(FilePath,'rwA.txt'),'w+');
    fida = fopen(strcat(FilePath,'ra.txt'),'w+');
    
    fprintf(fidwA,'%d\n',inputwA);
    fprintf(fida,'%d\n',inputa);
    
    fclose(fidwA);
    fclose(fida);
end

%% init a or b?

wwA=reshape(inputwA,latentnum,classnumA,dimensionA+1);
aa=reshape(inputa,latentnum,ftnum+1);

rand=reshape(inputran,1,doc_numA);

doc_term_matrixA = doc_term_matrixA1(rand(1,1:floor(doc_numA/part)),:);
ftmatrixA = ftmatrixA1(rand(1,1:floor(doc_numA/part)),:);
TA = TA1(rand(1,1:floor(doc_numA/part)),:);

bsizeA=(doc_numA/part)/cross;

averpre =zeros(classnumA,1);
averMRR = 0;
averKL = 0;
averem = 0;

lama=lamas;
while lama <= lamae
    lamat = exp(lama);
    
    lamwa=lamwas;
    while lamwa <= lamwae
        lamwat = exp(lamwa);
        
        
        fid = fopen(strcat(FilePath,'result_',num2str(lama),'_',num2str(lamwa),'.txt'),'w+');
        
        totalpre =zeros(classnumA,1);
        totalMRR = 0;
        totalKL = 0;
        totalem = 0;
        
        count=count+1;
        
        fprintf(fid,'count:%d lama:%d  lamwa:%d  docA:%d\r\n',count,lama,lamwa,doc_numA);
        fprintf(fid,'*****************************************************\r\n');
        
        for j=1:cross
            
            if(part>1)
                
                XtrainA=[doc_term_matrixA(1:floor(bsizeA*(j-1)),:);doc_term_matrixA(1+floor(bsizeA*j):end,:)];
                XtestA=[doc_term_matrixA(1+floor(bsizeA*(j-1)):floor(bsizeA*j),:);doc_term_matrixA1(rand(1,1+floor(doc_numA/part):end),:)];  %data for testing
                
                ttrainA=[TA(1:floor(bsizeA*(j-1)),:);TA(1+floor(bsizeA*j):end,:)];  % emotion distribution for training
                ttestA=[TA(floor(1+bsizeA*(j-1)):floor(bsizeA*j),:);TA1(rand(1,1+floor(doc_numA/part):end),:)];  % emotion distribution for testing
                
                FtrainA = [ftmatrixA(1:floor(bsizeA*(j-1)),:);ftmatrixA(1+floor(bsizeA*j):end,:)];
                FtestA = [ftmatrixA(1+floor(bsizeA*(j-1)):floor(bsizeA*j),:);ftmatrixA1(rand(1,1+floor(doc_numA/part):end),:)];
                
                
            else
                
                XtrainA=[doc_term_matrixA(1:floor(bsizeA*(j-1)),:);doc_term_matrixA(1+floor(bsizeA*j):end,:)];
                XtestA=doc_term_matrixA(floor(bsizeA*(j-1))+1:floor(bsizeA*j),:);  %data for testing
                
                ttrainA=[TA(1:floor(bsizeA*(j-1)),:);TA(1+floor(bsizeA*j):end,:)];  % emotion distribution for training
                ttestA=TA(floor(bsizeA*(j-1))+1:floor(bsizeA*j),:);    % emotion distribution for testing
                
                FtrainA = [ftmatrixA(1:floor(bsizeA*(j-1)),:);ftmatrixA(1+floor(bsizeA*j):end,:)];
                FtestA = ftmatrixA(floor(bsizeA*(j-1))+1:floor(bsizeA*j),:);
                
            end
            
            wwwA = wwA;
            aaa = aa;
            
            [w,a,em] = MixtureTrain2(wwwA,aaa,XtrainA,FtrainA,ttrainA,lamwat,lamat);%,lamb,XtestA,FtestA,ttestA,classnumA,XtestB,FtestB,ttestB,classnumB
            
            [pre,MRR,KL] = MixtureTest2(w,a,XtestA,FtestA,ttestA,classnumA);
            
            
            totalem = totalem +em;
            totalpre = totalpre + pre;
            totalMRR = totalMRR + MRR;
            totalKL = totalKL + KL;
        end
        
        totalem = totalem/cross;
        
        totalpre = totalpre/cross ;
        totalMRR = totalMRR /cross;
        totalKL = totalKL /cross;
        
        fprintf(fid,'totalem is %d \r\n',totalem);
        
        for pat =1:classnumA
            fprintf(fid, 'ALL: accuracy at: %d is %d\r\n',pat,totalpre(pat,1));
        end
        fprintf(fid,'ALL: MRR is %d \r\n',totalMRR);
        fprintf(fid,'ALL: KL is %d \r\n',totalKL);
        
        fprintf(fidall,'pre: %d  lamda: %d %d \r\n',totalpre(1,1),lama,lamwa);
        fprintf('pre: %d  lamda: %d %d \r\n',totalpre(1,1),lama,lamwa);
        fclose(fid);
        
        averem = averem +totalem;
        averpre = averpre + totalpre;
        averMRR = averMRR + totalMRR;
        averKL = averKL + totalKL;
        
        lamwa = lamwa +  stepwa;
    end
    lama = lama +stepa;
end
t=toc;
fclose(fidall);
end