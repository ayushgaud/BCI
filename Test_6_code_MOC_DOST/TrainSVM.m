function [ model ] = TrainSVM(X,y)
% Function to train LS-SVM model multiclass OneVsOne
Index=randi([1 size(X,1)],192,1);
Xt=X(Index,:);
yt=y(Index,:);
t1=cputime;
model = initlssvm(X,y,'c',[],[],'RBF_kernel');
model = tunelssvm(model,'simplex','crossvalidatelssvm',{10,'misclass'},'code_OneVsOne');
model = trainlssvm(model);
Y = simlssvm(model,Xt);

t2=cputime;
fprintf(1,'Tuning time %i \n',t2-t1);
fprintf(1,'Accuracy: %2.2f\n',100*sum(Y==yt)/length(yt));

end

