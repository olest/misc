function labels_predicted = nn_classification(trainingset,testset,labels,k)
%
% Performs k nearest neighbour classification on the data
% in testset using the training data in trainingset
%
% Ole Schulz-Trieglaff (0458133) (M.Sc.)
%
% Learning from Data : Assignment Sheet One
%

ntrpoints = size(trainingset,2);   % number of training points
nttpoints = size(testset,2);       % number of test points

dist_matrix      = zeros(ntrpoints,nttpoints); % allocate distance matrix
labels_predicted = zeros(nttpoints,1);         % allocate label vector

% Fill distance matrix 
for i=1:ntrpoints
    for j=1:nttpoints
        dist_matrix(i,j) = sum((trainingset(:,i)-testset(:,j)).^2);
    end
end

for i=1:nttpoints   % I classify each test point

    % I sort the distances and pick the five smallest
    [sorted,indizes] = sort(dist_matrix(:,i));
    indizes = indizes(1:5);
    
   % Now we need to find out which label occurs the most often
   nr_11 = size(find(labels(indizes)==1.1),1);
   nr_12 = size(find(labels(indizes)==1.2),1);
   nr_2  = size(find(labels(indizes)==2),1);
      
   max_nr = max(nr_11,max(nr_12,nr_2));
   
   if (max_nr == nr_11)
       labels_predicted(i) = 1.1;
   elseif (max_nr == nr_12)
       labels_predicted(i) = 1.2;
   else
       labels_predicted(i) = 2;
   end   
   
end

% Remark: This approach deals not in a very smart way with ambiguous cases.
% There is a strong preference for class 1.1 which means if two points
% come from 1.1 and two points from another class then class 1.1 is always
% selected. 
