function [ model ] = TrainSVM(X,y)
% Function to train LS-SVM model multiclass OneVsOne

t1=cputime;
model = initlssvm(X,y,'c',[],[],'RBF_kernel');
model = tunelssvm(model,'simplex','crossvalidatelssvm',{10,'misclass'},'code_OneVsAll');
model = trainlssvm(model);
t2=cputime;
fprintf(1,'Tuning time %i \n',t2-t1);
a=simlssvm(model,X);
fprintf('Classifier Trained with accuracy %d %%\n',((sum(a==y)/size(y,1))*100));
end

