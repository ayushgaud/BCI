trainSamples = [3  1; 
           5  2;
           1 -3;
          -1 -5;
           2 -3;
           5 -5;];
       
trainClasses = {'1', '1', '2', '2', '3', '3'}; %try drawing samples and discriminant line!

testSamples = [14 15;
              -8 -6];
          
testClasses = {'1', '2'};

%************************* MultiClass LDA ***************************************

mLDA = LDA(trainSamples, trainClasses);
mLDA.Compute();

%dimension of a samples is < (mLDA.NumberOfClasses-1) so following line cannot be executed:
%transformedSamples = mLDA.Transform(meas, mLDA.NumberOfClasses - 1);

transformedTrainSamples = mLDA.Transform(trainSamples, 1);
transformedTestSamples = mLDA.Transform(testSamples, 1);

%************************* MultiClass LDA ***************************************

calculatedClases = knnclassify(transformedTestSamples, transformedTrainSamples, trainClasses);

simmilarity = [];
for i = 1 : 1 : length(testClasses)
    similarity(i) = ( testClasses{i} == calculatedClases{i} );
end

accuracy = sum(similarity) / length(testClasses);
fprintf('Testing: Accuracy is: %f %%\n', accuracy*100);