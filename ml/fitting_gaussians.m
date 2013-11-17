% Demo for fitting Gaussians and using Bayes to classify : 2 classes

% generate some fake training data for class 1 :
X1 = randn(2,10);
% generate some fake training data for class 2 :
X2 = randn(2,15) + repmat(3*ones(2,1),1,15);
% fit a Gaussian to data X1 :
m1 = mean(X1')'; S1=cov(X1'); invS1 = inv(S1);
logdetS1=trace(logm(S1));
p1 = size(X1,2)/(size(X1,2)+size(X2,2)); % prior
% fit a Gaussian to data X2 :
m2 = mean(X2')'; S2=cov(X2'); invS2 = inv(S2);
logdetS2=trace(logm(S2));
p2 = 1-p1; % prior
Xnew =2*randn(2,50)+ 2*repmat(ones(2,1),1,50);; % some test points
% calculate the decisions :
d1=(Xnew-repmat(m1,1,size(Xnew,2)));d2=(Xnew-repmat(m2,1,size(Xnew,2)));
for i = 1 : size(Xnew,2)
    if d2(:,i)'*invS2*d2(:,i)+logdetS2 -2*log(p2) > d1(:,i)'*invS1*d1(:,i)+logdetS1-2*log(p1)
        class(1,i)=1;
    else
        class(1,i)=2;
    end
end

% plot a few things :
plot(X1(1,:),X1(2,:),'bx','markersize',10,'linewidth',2); hold on; % class 1;
plot(X2(1,:),X2(2,:),'ro','markersize',10,'linewidth',2); % class 2;
plot(Xnew(1,find(class==1)),Xnew(2,find(class==1)),'bx'); % class 1;
plot(Xnew(1,find(class==2)),Xnew(2,find(class==2)),'ro'); hold off % class 2;
