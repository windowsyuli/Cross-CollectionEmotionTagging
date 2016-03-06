function [averpre,averMRR,averKL,t] = Method3(File,part,l1)

%% parameter

warning off all
addpath('./minFunc/');
addpath('./source/');
% FilePath = strcat('./result/method3/',num2str(part),'_',num2str(File),'/');
% mkdir(FilePath );
% addpath(FilePath);
% 
% doc_numA = 7665;
% dimensionA = 1319;
% classnumA = 6;
% nameA = 'A';

doc_numA = 4654 ;
dimensionA = 770;
classnumA = 8;
nameA='B';

read=0;

cross=2;
sigma = 1;

lamwas=l1;
lamwae=l1;
stepwa=1;

deleteA=[];

%% Load
sinputA=load(strcat('EmotionFeature',nameA,'Filter.txt'));
doc_term_matrixA = sparse(sinputA(:,1), sinputA(:,2), sinputA(:,3),doc_numA, dimensionA);
doc_term_matrixA=full(doc_term_matrixA);
TA1=load(strcat('EmotionPro',nameA,'Filter.txt'));


doc_term_matrixA(deleteA,:)=[];
doc_term_matrixA = doc_term_matrixA./repmat(max(doc_term_matrixA,[],1),doc_numA,1);
doc_term_matrixA1 = [ones(doc_numA,1),doc_term_matrixA];
%check(doc_term_matrixA1);

TA1(deleteA,:)=[];

%% new array

tic
count=0;
% fidall = fopen(strcat(FilePath,'result_all.txt'),'w+');
%% init read parameter
if(read == 1)
    inputwA = load(strcat('rwA.txt'));
    inputran = randperm(doc_numA);
else
    inputwA = normrnd(0,sigma,classnumA*(dimensionA+1),1);
    inputran = randperm(doc_numA);
%     
%     fidwA = fopen(strcat(FilePath,'rwA.txt'),'w+');
%     
%     
%     fprintf(fidwA,'%d\n',inputwA);
%     
%     
%     fclose(fidwA);
    
end


%*****************************************
%% init a or b?

wwA=inputwA;


rand=reshape(inputran,1,doc_numA);

doc_term_matrixA = doc_term_matrixA1(rand(1,1:floor(doc_numA/part)),:);

TA = TA1(rand(1,1:floor(doc_numA/part)),:);



bsizeA=(doc_numA/part)/cross;
%**********************************************
totalpre =zeros(classnumA,1);
averpre=zeros(classnumA,1);

averMRR = 0;
averKL = 0;

totalMRR = 0;
totalKL = 0;
lamwa=lamwas;
while lamwa <= lamwae
    lamwat = exp(lamwa);
    
    totalpre =zeros(classnumA,1);
    totalMRR = 0;
    totalKL = 0;    

    tic
%     fid = fopen(strcat(FilePath,'result_','_',num2str(lamwa),'.txt'),'w+');
    
    
    count=count+1;
    
%     fprintf(fid,'count:%d lamwA:%d docA:%d \r\n',count,lamwa,doc_numA);
    
    for j=1:cross
        
%         if(part>1)
%             
%             XtrainA=[doc_term_matrixA(1:floor(bsizeA*(j-1)),:);doc_term_matrixA(1+floor(bsizeA*j):end,:)];
%             XtestA=[doc_term_matrixA(1+floor(bsizeA*(j-1)):floor(bsizeA*j),:);doc_term_matrixA1(rand(1,1+floor(doc_numA/part):end),:)];  %data for testing
%             
%             ttrainA=[TA(1:floor(bsizeA*(j-1)),:);TA(1+floor(bsizeA*j):end,:)];  % emotion distribution for training
%             ttestA=[TA(floor(1+bsizeA*(j-1)):floor(bsizeA*j),:);TA1(rand(1,1+floor(doc_numA/part):end),:)];  % emotion distribution for testing
%             
%         else
%             
%             XtrainA=[doc_term_matrixA(1:floor(bsizeA*(j-1)),:);doc_term_matrixA(1+floor(bsizeA*j):end,:)];
%             XtestA=doc_term_matrixA(floor(bsizeA*(j-1))+1:floor(bsizeA*j),:);  %data for testing
%             
%             ttrainA=[TA(1:floor(bsizeA*(j-1)),:);TA(1+floor(bsizeA*j):end,:)];  % emotion distribution for training
%             ttestA=TA(floor(bsizeA*(j-1))+1:floor(bsizeA*j),:);    % emotion distribution for testing
%             
%             
%             
%             
%             
%         end

            XtrainA=doc_term_matrixA;
            XtestA=doc_term_matrixA1(rand(1,1+floor(doc_numA/part):end),:);  %data for testing
            
            ttrainA=TA;  % emotion distribution for training
            ttestA=TA1(rand(1,1+floor(doc_numA/part):end),:);  % emotion distribution for testing
  

        wwwA = wwA;
        [wsingle] = MixtureTrain3(wwwA,XtrainA,ttrainA,lamwat);%(www,Xtrain,ttrain,lamwt)
        [pre,MRR,KL] = MixtureTest3(wsingle,XtestA,ttestA,classnumA);%(w, X, t,at)
        %fprintf('accuracy %d\r\n',pre(1));
        
        totalpre = totalpre + pre;
        totalMRR = totalMRR + MRR;
        totalKL = totalKL + KL;
        
    end
    
    
    totalpre = totalpre/cross ;
    totalMRR = totalMRR /cross;
    totalKL = totalKL /cross;
    
    
%     for pat =1:classnumA
%         fprintf(fid, 'ALL: accuracy at: %d is %d\r\n',pat,totalpre(pat,1));
%     end
%     fprintf(fid,'ALL: MRR is %d \r\n',totalMRR);
%     fprintf(fid,'ALL: KL is %d \r\n',totalKL);
%     
%     fprintf(fidall,'pre: %d  lamda:  %d \r\n',totalpre(1,1),lamwa);
%     fprintf('pre: %d  lamda: %d \r\n',totalpre(1,1),lamwa);
%     fclose(fid);
    
    averpre = averpre + totalpre;
    averMRR = averMRR + totalMRR;
    averKL = averKL + totalKL;
    
    lamwa = lamwa +  stepwa;
end

t=toc;
% fclose(fidall);
end
