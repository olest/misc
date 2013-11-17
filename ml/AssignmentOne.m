%-----------------------------------------------------------------------
% Learning from Data - Assignment one
%
% Ole Schulz-Trieglaff 0458133
%
% PCA_AssignmentOne.m
% ----------------------------------------------------------------------

load assignmentone.mat;

% I transpose each dataset such that I can apply
% the formulas in the lecture notes
% => each column is one datapoint
xtrain = xtrain';  
xtest  = xtest';
testpointa = testpointa';

% ----------------------------- (1) PCA on xtrain dataset -------------------------------------
c_xtrain = mean(xtrain,2);   % calculate mean for every row  (!)
Sigma_xtrain= cov(xtrain');  

% collect eigenvectors and eigenvalues
[Evectors,Evalmatrix] = eig(Sigma_xtrain);
Evalues = diag(Evalmatrix);

disp('The eigenvalues are :');
disp(Evalues');

% ----------------------------- (2)  Reduction to the first two components -------------------------------------

% Keep the two eigenvectors with the largest eigenvalues
Evectors_kept = Evectors(:,20:-1:19);

% Generation of the lowerdimensional representation 
x = xtrain - repmat(c_xtrain,1,300);       % substract mean 
xtrain_ld = Evectors_kept'*x;              

% reduction of the control point
x2 = testpointa - c_xtrain;
testpointa_ld = Evectors_kept'*x2;

disp('Testpointa in two dimensions :');
disp(testpointa_ld);

% ----------------------------- (3)  Visualisation -------------------------------------

% Remove the '%' to show the plots
% gscatter(xtrain_ld(1,:),xtrain_ld(2,:),ttrain2)
% hist(xtrain_ld(1,find(ttrain==1)),40)

% ----------------------------- (4) Fitting of Gaussian distributions to each class -------------------------------------

% I store the datapoints in three different matrices according to their
% class label
class11 = xtrain_ld(:,find(ttrain2==1.1));
class12 = xtrain_ld(:,find(ttrain2==1.2));
class2  = xtrain_ld(:,find(ttrain2==2));

mean11 = mean(class11')';
mean12 = mean(class12')';
mean2  = mean(class2')';

% Calculate covariance matrix and is inverse for each class
Sigma_11 = cov(class11'); invS11 = inv(Sigma_11);
Sigma_12 = cov(class12'); invS12 = inv(Sigma_12);
Sigma_2  = cov(class2'); invS2 = inv(Sigma_2);

% prior probabilities for each class
num_points = size(class11,2) + size(class12,2) + size(class2,2);

prior_11 = size(class11,2) / num_points;
prior_12 = size(class12,2) / num_points;
prior_2  = size(class2,2) / num_points;

disp('Covariance matrix of class 1.2');
disp(Sigma_12);
disp('Mean of class 1.1');
disp(mean11);
disp('Prior probability of class 2:');
disp(prior_2);

% ----------------------------- (5) Classification using class conditional model -------------------------------------

% I am using the hint in the lecture notes to calculate
% the determinant, maybe it is not needed here ?
logdetS11 = trace(logm(Sigma_11));
logdetS12 = trace(logm(Sigma_12));
logdetS2  = trace(logm(Sigma_2));

% First I reduce the test data to two dimensions 
c_test = mean(xtest,2);   
Sigma_test = cov(xtest');

% collect eigenvectors and eigenvalues
[Evectors_test,Evalmatrix_test] = eig(Sigma_test);
Evectors_test_kept = Evectors_test(:,20:-1:19);

x3 = xtest - repmat(c_test,1,300);
xtest_ld = Evectors_test_kept'*x3;   % the lowerdimensional representation of the test data

% I define two helper vars in order to shorten the following calculations
helper11 = xtest_ld - repmat(mean11,1,size(xtest_ld,2));
helper12 = xtest_ld - repmat(mean12,1,size(xtest_ld,2));
helper2  = xtest_ld - repmat(mean2,1,size(xtest_ld,2));

% According to the assignment task, I assign a point to a class if the
% probability for this class is higher than for any other class
for i = 1:size(xtest_ld,2)
    
    results(1) = -0.5 * helper11(:,i)'*invS11*helper11(:,i) - 0.5 * logdetS11 + log(prior_11);
    results(2) = -0.5 * helper12(:,i)'*invS12*helper12(:,i) - 0.5 * logdetS12 + log(prior_12);
    results(3) = -0.5 * helper2(:,i)'*invS2*helper2(:,i) -0.5 * logdetS2 + log(prior_2);
    
    [sorted,indizes] = sort(results);   % sort the probabilities
    
    switch indizes(3)   % the biggest index is at position 3
        case 1
            class_predicted_cc(i) = 1.1;
        case 2
            class_predicted_cc(i) = 1.2;
        case 3
            class_predicted_cc(i) = 2;
    end
   
end

% ----------------------------- (6) Nearest neighbour classification -------------------------------------

class_predicted_nn1 = nn_classification(xtrain,xtest,ttrain2,5);   % performs 5 nn classification with original datapoints

class_predicted_nn2 = nn_classification(xtrain_ld,xtest_ld,ttrain2,5);   % performs 5 nn classification with reduced datapoints

disp('Results for the Gaussian classification:');
wrong_11_cc = size(find(ttest2(find(class_predicted_cc~=1.1))==1.1),1)      % false negatives for class 1.1 and class conditional classification
fp_11_cc    = size(find(ttest2(find(class_predicted_cc==1.1))~=1.1),1)      % false positives for class 1.1 and class conditional classification
right_11_cc = size(find(ttest2(find(class_predicted_cc==1.1))==1.1),1)      % true positives for class 1.1 and class conditional classification

wrong_12_cc = size(find(ttest2(find(class_predicted_cc~=1.2))==1.2),1)      % false negatives for class 1.2 and class conditional classification
fp_12_cc    = size(find(ttest2(find(class_predicted_cc==1.2))~=1.2),1)      % false positives for class 1.2 and class conditional classification
right_12_cc = size(find(ttest2(find(class_predicted_cc==1.2))==1.2),1)      % true positives for class 1.2 and class conditional classification

wrong_2_cc = size(find(ttest2(find(class_predicted_cc~=2))==2),1)           % false negatives for class 2 and class conditional classification
fp_2_cc    = size(find(ttest2(find(class_predicted_cc==2))~=2),1)           % false positives for class 2 and class conditional classification
right_2_cc = size(find(ttest2(find(class_predicted_cc==2))==2),1)           % true positives for class 2 and class conditional classification

disp('Results for the nn classification in 20 dimensions:');
wrong_11_nn1 = size(find(ttest2(find(class_predicted_nn1~=1.1))==1.1),1)    % same for nearest neighbour classification on the original dataset
fp_11_nn1    = size(find(ttest2(find(class_predicted_nn1==1.1))~=1.1),1)
right_11_nn1 = size(find(ttest2(find(class_predicted_nn1==1.1))==1.1),1)

wrong_12_nn1 = size(find(ttest2(find(class_predicted_nn1~=1.2))==1.2),1)    % same for nearest neighbour classification on the original dataset
fp_12_nn1    = size(find(ttest2(find(class_predicted_nn1==1.2))~=1.2),1)
right_12_nn1 = size(find(ttest2(find(class_predicted_nn1==1.2))==1.2),1)

wrong_2_nn1 = size(find(ttest2(find(class_predicted_nn1~=2))==2),1)       % same for nearest neighbour classification on the original dataset
fp_2_nn1    = size(find(ttest2(find(class_predicted_nn1==2))~=2),1)
right_2_nn1 = size(find(ttest2(find(class_predicted_nn1==2))==2),1)

disp('Results for the nn classification in 5 dimensions:');
wrong_11_nn2 = size(find(ttest2(find(class_predicted_nn2~=1.1))==1.1),1)    % same for nearest neighbour classification on the reduced dataset
fp_11_nn2    = size(find(ttest2(find(class_predicted_nn2==1.1))~=1.1),1)
right_11_nn2 = size(find(ttest2(find(class_predicted_nn2==1.1))==1.1),1)

wrong_12_nn2 = size(find(ttest2(find(class_predicted_nn2~=1.2))==1.2),1)    % same for nearest neighbour classification on the reduced dataset
fp_12_nn2    = size(find(ttest2(find(class_predicted_nn2==1.2))~=1.2),1)
right_12_nn2 = size(find(ttest2(find(class_predicted_nn2==1.2))==1.2),1)

wrong_2_nn2 = size(find(ttest2(find(class_predicted_nn2~=2))==2),1)       % same for nearest neighbour classification on the reduced dataset
fp_2_nn2    = size(find(ttest2(find(class_predicted_nn2==2))~=2),1)
right_2_nn2 = size(find(ttest2(find(class_predicted_nn2==2))==2),1) 


% plot the predicted and the real class labels
subplot(2,2,1);
plot(xtest(1,find(ttest2==1.1)),xtest(2,find(ttest2==1.1)),'b.');  hold on;
plot(xtest(1,find(ttest2==1.2)),xtest(2,find(ttest2==1.2)),'g.');
plot(xtest(1,find(ttest2==2)),xtest(2,find(ttest2==2)),'r.'); legend('Class 1.1','Class 1.2','Class 2'); hold off;
title('Real class labels');

subplot(2,2,2);
plot(xtest(1,find(class_predicted_cc==1.1)),xtest(2,find(class_predicted_cc==1.1)),'b.'); hold on;
plot(xtest(1,find(class_predicted_cc==1.2)),xtest(2,find(class_predicted_cc==1.2)),'g.');
plot(xtest(1,find(class_predicted_cc==2)),xtest(2,find(class_predicted_cc==2)),'r.'); hold off;
title('Gaussian classification on reduced dataset')

subplot(2,2,3);
plot(xtest(1,find(class_predicted_nn1==1.1)),xtest(2,find(class_predicted_nn1==1.1)),'b.'); hold on;
plot(xtest(1,find(class_predicted_nn1==1.2)),xtest(2,find(class_predicted_nn1==1.2)),'g.');
plot(xtest(1,find(class_predicted_nn1==2)),xtest(2,find(class_predicted_nn1==2)),'r.'); hold off;
title('Nearest neighbour class. on original dataset')

subplot(2,2,4);
plot(xtest(1,find(class_predicted_nn2==1.1)),xtest(2,find(class_predicted_nn2==1.1)),'b.'); hold on;
plot(xtest(1,find(class_predicted_nn2==1.2)),xtest(2,find(class_predicted_nn2==1.2)),'g.');
plot(xtest(1,find(class_predicted_nn2==2)),xtest(2,find(class_predicted_nn2==2)),'r.'); hold off;
title('Nearest neighbour class. on reduced dataset')