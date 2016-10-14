function[svmStruct]=classify_svm(X,Y)

svmStruct = fitcsvm(X,Y,'Standardize',true,'KernelFunction','rbf','KernelScale','auto','solver','SMO','verbose',1);
cv = crossval(svmStruct);
kfoldLoss(cv)
% P = cvpartition(Y,'Holdout',0.20);
% % Use a linear support vector machine classifier
% svmStruct = svmtrain(X(P.training,:),Y(P.training),'kernel_function','rbf','method','LS');
% C = svmclassify(svmStruct,X(P.test,:));
% errRate = sum(Y(P.test)~= C)/P.TestSize  %mis-classification rate
% conMat = confusionmat(Y(P.test),C) % the confusion matrix
end

        