function [averem,averpreA,averMRRA,averKLA,averpreB,averMRRB,averKLB,t] = Method1C(File,part,x,y)

%% parameter

warning off all
addpath('./minFunc/');
addpath('./source/');
FilePath = strcat('./result/method1/',num2str(part),'_',num2str(File),'/');
mkdir(FilePath );
addpath(FilePath);

doc_numA = 4088;
dimensionA = 266;
classnumA = 8;
nameA = 'A';

doc_numB = 7500 ;
dimensionB = 343;
classnumB = 8;
nameB='B';

% doc_numB = 4088;
% dimensionB = 266;
% classnumB = 8;
% nameB = 'A';
% 
% doc_numA = 7500 ;
% dimensionA = 343;
% classnumA = 8;
% nameA='B';

ftnum = 1416;%or
fatnum = 1416;%and
latentnum=3;

read=0;

cross=10;
sigma = 0;
delta =1;

lamfs=x;
lamfe=x;
stepf=1;

lamas=0;
lamae=0;
stepa=1;

lamwas=y;
lamwae=y;
stepwa=1;

lamwbs=0;
lamwbe=0;
stepwb=1;

deleteA=[];
%deleteB=[101,177,308,333,489,501,511,734,947,1118,1190,1209,2160,2277,2385,2630,2838,2936,3144,3170,3223,3414,3496,3524,3539,3672,3773,3777,3831,4080,4340,4346,4504,4582,4854,4876,4993,5312,5498,5526,5538,5736,5815,5851,6291,6373,6640,6715,6798,7133,7297,7441];
deleteB=[];
%% Load

sinputA=load(strcat('EmotionFeature',nameA,'Filter.txt'));
doc_term_matrixA = sparse(sinputA(:,1), sinputA(:,2), sinputA(:,3),doc_numA, dimensionA);
doc_term_matrixA=full(doc_term_matrixA);

fainputA=load(strcat('Feature',nameA,'inAandBFilter.txt'));
fatmatrixA = sparse(fainputA(:,1), fainputA(:,2), fainputA(:,3),doc_numA, fatnum);
fatmatrixA=full(fatmatrixA);

finputA=load(strcat('Feature',nameA,'inAorBFilter.txt'));
ftmatrixA = sparse(finputA(:,1), finputA(:,2), finputA(:,3),doc_numA, ftnum);
ftmatrixA=full(ftmatrixA);

TA1=load(strcat('EmotionPro',nameA,'Filter.txt'));

doc_term_matrixA(deleteA,:)=[];
doc_term_matrixA = doc_term_matrixA./repmat(max(doc_term_matrixA,[],1),doc_numA,1);
doc_term_matrixA1 = [ones(doc_numA,1),doc_term_matrixA];

fatmatrixA(deleteA,:)=[];
fatmatrixA = fatmatrixA./repmat(max(fatmatrixA,[],1),doc_numA,1);
fatmatrixA1 =[ones(doc_numA,1),fatmatrixA];

ftmatrixA(deleteA,:)=[];
ftmatrixA = ftmatrixA./repmat(max(ftmatrixA,[],1),doc_numA,1);
ftmatrixA1 =[ones(doc_numA,1),ftmatrixA];
TA1(deleteA,:)=[];



sinputB=load(strcat('EmotionFeature',nameB,'Filter.txt'));
doc_term_matrixB = sparse(sinputB(:,1), sinputB(:,2), sinputB(:,3),doc_numB, dimensionB);
doc_term_matrixB =full(doc_term_matrixB);

fainputB=load(strcat('Feature',nameB,'inAandBFilter.txt'));
fatmatrixB = sparse(fainputB(:,1), fainputB(:,2), fainputB(:,3),doc_numB, fatnum);
fatmatrixB =full(fatmatrixB);

finputB=load(strcat('Feature',nameB,'inAorBFilter.txt'));
ftmatrixB = sparse(finputB(:,1), finputB(:,2), finputB(:,3),doc_numB, ftnum);
ftmatrixB =full(ftmatrixB);

TB1=load(strcat('EmotionPro',nameB,'Filter.txt'));

doc_term_matrixB(deleteB,:)=[];
doc_term_matrixB = doc_term_matrixB./repmat(max(doc_term_matrixB,[],1),doc_numB,1);
doc_term_matrixB1 =[ones(doc_numB,1),doc_term_matrixB];

fatmatrixB(deleteB,:)=[];
fatmatrixB = fatmatrixB./repmat(max(fatmatrixB,[],1),doc_numB,1);
fatmatrixB1 =[ones(doc_numB,1),fatmatrixB];

ftmatrixB(deleteB,:)=[];
ftmatrixB = ftmatrixB./repmat(max(ftmatrixB,[],1),doc_numB,1);
ftmatrixB1 =[ones(doc_numB,1),ftmatrixB];

TB1(deleteB,:)=[];



%% new array
averpreA =zeros(classnumA,1);
averpreB =zeros(classnumB,1);
averMRRA = 0;
averMRRB = 0;
averKLA = 0;
averKLB = 0;

averem = 0;

tic
count=0;
fidall = fopen(strcat(FilePath,'result_all.txt'),'w+');
%% init read parameter
if(read == 1)
    inputwA = load(strcat('rwA.txt'));
    inputwB = load(strcat('rwB.txt'));
    inputa = load(strcat('ra.txt'));
    inputran = randperm(doc_numA);
else
    inputwA = normrnd(0,sigma,latentnum,classnumA,dimensionA+1);
    inputwB = normrnd(0,sigma,latentnum,classnumB,dimensionB+1);
    inputa = normrnd(0,sigma,latentnum,ftnum+1);
    inputran = randperm(doc_numA);
    
    fidwA = fopen(strcat(FilePath,'rwA.txt'),'w+');
    fidwB = fopen(strcat(FilePath,'rwB.txt'),'w+');
    fida = fopen(strcat(FilePath,'ra.txt'),'w+');
    
    fprintf(fidwA,'%d\n',inputwA);
    fprintf(fidwB,'%d\n',inputwB);
    fprintf(fida,'%d\n',inputa);
    
    fclose(fidwA);
    fclose(fidwB);
    fclose(fida);
end

%% init a or b?

wwA=reshape(inputwA,latentnum,classnumA,dimensionA+1);
wwB=reshape(inputwB,latentnum,classnumB,dimensionB+1);
aa=reshape(inputa,latentnum,ftnum+1);

rand=reshape(inputran,1,doc_numA);

doc_term_matrixA = doc_term_matrixA1(rand(1,1:floor(doc_numA/part)),:);
ftmatrixA = ftmatrixA1(rand(1,1:floor(doc_numA/part)),:);
fatmatrixA = fatmatrixA1(rand(1,1:floor(doc_numA/part)),:);
TA = TA1(rand(1,1:floor(doc_numA/part)),:);

doc_term_matrixB = doc_term_matrixB1;
ftmatrixB = ftmatrixB1;
fatmatrixB = fatmatrixB1;
TB = TB1;

bsizeA=(doc_numA/part)/cross;
bsizeB=doc_numB/cross;
tic
%betaB = calb(fatmatrixA,fatmatrixB,delta,FilePath);
%betaB = ones(doc_numB,1);
betaB=reshape(load(strcat('B',nameA,'.txt')),doc_numB,1);
t = toc;

%% Loop
lamf=lamfs;
while lamf <= lamfe
    lamft = exp(lamf);
    
    lama=lamas;
    while lama <= lamae
        lamat = exp(lama);
        
        lamwa=lamwas;
        while lamwa <= lamwae
            lamwat = exp(lamwa);
            
            lamwb=lamwbs;
            while lamwb <= lamwbe
                lamwbt = exp(lamwb);
                
                tic
                fid = fopen(strcat(FilePath,'result_',num2str(lamf),'_',num2str(lama),'_',num2str(lamwa),'_',num2str(lamwb),'.txt'),'w+');
                
                totalpreA =zeros(classnumA,1);
                totalpreB =zeros(classnumB,1);
                totalMRRA = 0;
                totalMRRB = 0;
                totalKLA = 0;
                totalKLB = 0;
                totalem = 0;
                
                count=count+1;
                
                fprintf(fid,'count:%d lamf:%d lama:%d lamwA:%d lamwB:%d docA:%d docB:%d\r\n',count,lamf,lama,lamwa,lamwb,doc_numA,doc_numB);
                
                for j=1:cross
                    
                    if(part>1)
                        
                        XtrainA=[doc_term_matrixA(1:floor(bsizeA*(j-1)),:);doc_term_matrixA(1+floor(bsizeA*j):end,:)];
                        XtestA=[doc_term_matrixA(1+floor(bsizeA*(j-1)):floor(bsizeA*j),:);doc_term_matrixA1(rand(1,1+floor(doc_numA/part):end),:)];  %data for testing
                        
                        ttrainA=[TA(1:floor(bsizeA*(j-1)),:);TA(1+floor(bsizeA*j):end,:)];  % emotion distribution for training
                        ttestA=[TA(floor(1+bsizeA*(j-1)):floor(bsizeA*j),:);TA1(rand(1,1+floor(doc_numA/part):end),:)];  % emotion distribution for testing
                        
                        FtrainA = [ftmatrixA(1:floor(bsizeA*(j-1)),:);ftmatrixA(1+floor(bsizeA*j):end,:)];
                        FtestA = [ftmatrixA(1+floor(bsizeA*(j-1)):floor(bsizeA*j),:);ftmatrixA1(rand(1,1+floor(doc_numA/part):end),:)];
                        
                        FatrainA = [fatmatrixA(1:floor(bsizeA*(j-1)),:);fatmatrixA(1+floor(bsizeA*j):end,:)];
                        FatestA = [fatmatrixA(1+floor(bsizeA*(j-1)):floor(bsizeA*j),:);fatmatrixA1(rand(1,1+floor(doc_numA/part):end),:)];
                        
                        XtrainB=[doc_term_matrixB(1:floor(bsizeB*(j-1)),:);doc_term_matrixB(1+floor(bsizeB*j):end,:)];
                        XtestB=doc_term_matrixB(floor(bsizeB*(j-1))+1:floor(bsizeB*j),:);  %data for testing
                        
                        ttrainB=[TB(1:floor(bsizeB*(j-1)),:);TB(1+floor(bsizeB*j):end,:)];  % emotion distribution for training
                        ttestB=TB(floor(bsizeB*(j-1))+1:floor(bsizeB*j),:);    % emotion distribution for testing
                        
                        FtrainB = [ftmatrixB(1:floor(bsizeB*(j-1)),:);ftmatrixB(1+floor(bsizeB*j):end,:)];
                        FtestB = ftmatrixB(floor(bsizeB*(j-1))+1:floor(bsizeB*j),:);
                        
                        FatrainB = [fatmatrixB(1:floor(bsizeB*(j-1)),:);fatmatrixB(1+floor(bsizeB*j):end,:)];
                        FatestB = fatmatrixB(floor(bsizeB*(j-1))+1:floor(bsizeB*j),:);
                        
                    else
                        
                        XtrainA=[doc_term_matrixA(1:floor(bsizeA*(j-1)),:);doc_term_matrixA(1+floor(bsizeA*j):end,:)];
                        XtestA=doc_term_matrixA(floor(bsizeA*(j-1))+1:floor(bsizeA*j),:);  %data for testing
                        
                        ttrainA=[TA(1:floor(bsizeA*(j-1)),:);TA(1+floor(bsizeA*j):end,:)];  % emotion distribution for training
                        ttestA=TA(floor(bsizeA*(j-1))+1:floor(bsizeA*j),:);    % emotion distribution for testing
                        
                        FtrainA = [ftmatrixA(1:floor(bsizeA*(j-1)),:);ftmatrixA(1+floor(bsizeA*j):end,:)];
                        FtestA = ftmatrixA(floor(bsizeA*(j-1))+1:floor(bsizeA*j),:);
                        
                        FatrainA = [fatmatrixA(1:floor(bsizeA*(j-1)),:);fatmatrixA(1+floor(bsizeA*j):end,:)];
                        FatestA = fatmatrixA(floor(bsizeA*(j-1))+1:floor(bsizeA*j),:);
                        
                        XtrainB=[doc_term_matrixB(1:floor(bsizeB*(j-1)),:);doc_term_matrixB(1+floor(bsizeB*j):end,:)];
                        XtestB=doc_term_matrixB(floor(bsizeB*(j-1))+1:floor(bsizeB*j),:);  %data for testing
                        
                        ttrainB=[TB(1:floor(bsizeB*(j-1)),:);TB(1+floor(bsizeB*j):end,:)];  % emotion distribution for training
                        ttestB=TB(floor(bsizeB*(j-1))+1:floor(bsizeB*j),:);    % emotion distribution for testing
                        
                        FtrainB = [ftmatrixB(1:floor(bsizeB*(j-1)),:);ftmatrixB(1+floor(bsizeB*j):end,:)];
                        FtestB = ftmatrixB(floor(bsizeB*(j-1))+1:floor(bsizeB*j),:);
                        
                        FatrainB = [fatmatrixB(1:floor(bsizeB*(j-1)),:);fatmatrixB(1+floor(bsizeB*j):end,:)];
                        FatestB = fatmatrixB(floor(bsizeB*(j-1))+1:floor(bsizeB*j),:);
                    end
                    
                    wwwA = wwA;
                    wwwB = wwB;
                    aaa = aa;
                    
                    
                    [sizeN,~]=size(FatrainA);
                    betaA = ones(sizeN,1);
                    betaBB = [betaB(1:floor(bsizeB*(j-1)),:);betaB(1+floor(bsizeB*j):end,:)];
                    [wA,wB,a,em] = MixtureTrain1(wwwA,wwwB,aaa,XtrainA,FtrainA,ttrainA,XtrainB,FtrainB,ttrainB,lamwat,lamwbt,lamft,lamat,betaA,betaBB);%,lamb,XtestA,FtestA,ttestA,classnumA,XtestB,FtestB,ttestB,classnumB
                    
                    [preA,MRRA,KLA] = MixtureTest1(wA,a,XtestA,FtestA,ttestA,classnumA);
                    [preB,MRRB,KLB] = MixtureTest1(wB,a,XtestB,FtestB,ttestB,classnumB);
                    
                    fprintf(fid,'       Cross %d	em %d	preA %d	preB %d\r\n',j,em,preA(1,1),preB(1,1));
                    %fprintf('       Cross %d	em %d	preA %d	preB %d\r\n',j,em,preA(1,1),preB(1,1));
                    totalem = totalem +em;
                    
                    totalpreA = totalpreA + preA;
                    totalMRRA = totalMRRA + MRRA;
                    totalKLA = totalKLA + KLA;
                    
                    totalMRRB = totalMRRB + MRRB;
                    totalpreB = totalpreB + preB;
                    totalKLB = totalKLB + KLB;
                    
                    
                end
                
                totalem = totalem/cross;
                
                totalpreA = totalpreA/cross ;
                totalMRRA = totalMRRA /cross;
                totalKLA = totalKLA /cross;
                
                totalpreB = totalpreB/cross ;
                totalMRRB = totalMRRB /cross;
                totalKLB = totalKLB /cross;
                
                fprintf(fid,'       totalem is %d \r\n',totalem);
                
                for pat =1:classnumA
                    fprintf(fid, '      A: accuracy at: %d is %d\r\n',pat,totalpreA(pat,1));
                end
                fprintf(fid,'       A: MRR is %d \r\n',totalMRRA);
                fprintf(fid,'       A: KL is %d \r\n',totalKLA);
                
                for pat =1:classnumB
                    fprintf(fid, '      B: accuracy at: %d is %d\r\n',pat,totalpreB(pat,1));
                end
                fprintf(fid,'       B: MRR is %d \r\n',totalMRRB);
                fprintf(fid,'       B: KL is %d \r\n',totalKLB);
                
                t=toc;
                fprintf(fidall,'count: %d prea: %d preb:%d lamda:%d %d %d %d time: %d\r\n',count,totalpreA(1,1),totalpreB(1,1),lamf,lama,lamwa,lamwb,t);
                fprintf('count: %d prea: %d preb:%d lamda:%d %d %d %d time: %d\r\n',count,totalpreA(1,1),totalpreB(1,1),lamf,lama,lamwa,lamwb,t);
                fclose(fid);
                
                averem = totalem +averem;
                
                averpreA = totalpreA + averpreA;
                averMRRA = totalMRRA + averMRRA;
                averKLA = totalKLA + averKLA;
                
                averMRRB = totalMRRB + averMRRB;
                averpreB = totalpreB + averpreB;
                averKLB = totalKLB + averKLB;
                
                lamwb = lamwb + stepwb;
            end
            lamwa = lamwa +  stepwa;
        end
        lama = lama +stepa;
    end
    lamf = lamf +stepf;
end
t=toc;

averem = averem/1;

averpreA = averpreA/1 ;
averMRRA = averMRRA/1;
averKLA = averKLA/1;

averpreB = averpreB/1 ;
averMRRB = averMRRB/1;
averKLB = averKLB/1;

fclose(fidall);
end