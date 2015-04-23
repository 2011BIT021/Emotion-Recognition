function [H,alpha]=AdaBoost(Y,T)
% AdaBoost
% X Feature matrix N x M 
%                  N is numeber of samples
%                  M is number of features
global X
% Y: label of samples, 1 for objects, 0 for non-objects
% T: number of iterations
% H: Adaboost parameters for strong classifiers
% alpha: vector used in AdaBoost algorithm

VERY_LARGE=10;
H={};

N=size(X,1);
W=zeros(N,1);

%number of positive examples
n=sum(Y(find(Y==1)));

%number of negative examples
m=N-n;

%initialize weights
for i=1:N
    if (Y(i))
        W(i)=1/(2*n);
    else
        W(i)=1/(2*m);
    end;
end

beta=zeros(T,1);

Thresh=0;
alpha=zeros(1,T);

for t=1:T
    
    %normalize weights
    NW=sum(W);
    W=W/NW;
    %find current best hyp
    %weak classifier
    if (t==1)   
        Y_predict=ones(size(X,1),1);
    else
        p=H{t-1}{2};
        thresh=H{t-1}{1};
        C0=H{t-1}{3};
        Y_predict=((p*(X(:,C0)-thresh)>=0)~=Y);
    end
    [H{t},epsilon,Rt]=WeakLearner(Y,W,Y_predict);
    
    beta(t)=epsilon/(1-epsilon);
    if (epsilon==0)
        alpha(t)=VERY_LARGE;
    else
        alpha(t)=log(1/beta(t));
    end;
    
    %update weights 
    correct_classif=find(Y==Rt);
    if (epsilon==0)
        break;
    end;
    
    W(correct_classif)=W(correct_classif)*beta(t);   
end













