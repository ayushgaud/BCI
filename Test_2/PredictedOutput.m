function [ prediction,confidencelevel] = PredictedOutput( model , Xt)
%Function to predict output based on trained model
Y=simlssvm(model,Xt);
[prediction freq]= mode(Y);
confidencelevel = 100*(freq/length(Y));

end

