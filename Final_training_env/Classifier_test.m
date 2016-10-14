function [b]=Classifier_test(Features,label)
[Features_train,~,Features_test] = dividerand([Features,label]',0.7,0,0.3);

nTrees = 50;
leaf = 10;
rng(1);
tic
b = TreeBagger(nTrees,Features_train(1:end-1,:)',Features_train(end,:)','OOBVarImp','on','CategoricalPredictors',6,'MinLeaf',leaf);
toc
plot(b.oobError);
xlabel('Number of grown trees');
ylabel('Out-of-bag classification error');

figure;bar(b.OOBPermutedVarDeltaError);
xlabel('Feature number');
ylabel('Out-of-bag feature importance');
title('Feature importance results');

oobErrorFullX = b.oobError;

[predClass,classifScore] = b.predict(Features_test(1:end-1,:)');
C = confusionmat(num2str(Features_test(end,:)'),cell2mat(predClass));
Cperc = diag(sum(C,2))\C;
Accuracy=sum(diag(C)/sum(C(:)));

for class=1:2
[xVal,yVal,~,auc] = perfcurve(num2str(Features_test(end,:)'),classifScore(:,class),num2str(class));
figure;plot(xVal,yVal);
xlabel('False positive rate');
ylabel('True positive rate');
text(0.5,0.25,strcat('AUC=',num2str(auc)),'EdgeColor','k');
title(strcat('ROC curve: ',num2str(class) ,' predicted vs. actual rating'));
end

end