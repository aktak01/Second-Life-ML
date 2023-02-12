function [listRMSE, listMPE, listCalibration, trainError, testError] = IterativeGPR(numIterations, numBags, sampleSize, numFeatures, totalCells, resList, currList, socList)
%ITERATIVEGPR 
%iteratively run through bagged GPR process


count = 1;
P = 0.7;

randIdx = randperm(length(socList));
testSize = length( randIdx(round(totalCells*P)+1:end));

listRMSE = NaN( testSize * numIterations, 1);
listMPE =  NaN( testSize * numIterations, 1);
listCalibration =  NaN( testSize * numIterations, 1);

trainError = [];
testError = [];

%run through bagged GPR process. Every iteration has a different training
%and testing sample
trainTime = 0;
testTime = 0;

tic

for i = 1:numIterations
    
    randIdx = randperm(length(socList));
    [xTrain, yTrain] = TrainTestSplit(randIdx, resList, currList, socList); %split data into training and testing data
    [featureArray, corrArray] = CorrelationMap(xTrain, yTrain, numFeatures); %generate correlation coefficient for features

    xTrain = xTrain(:,featureArray); 

    if(sampleSize < 0)
        sampleSize = length(xTrain);
    end
   
    [gprList, trainEnd] = TrainBags(xTrain, yTrain, numBags, sampleSize); %train models
    
    trainTime = trainTime + trainEnd;
    
    
    tempCell = cellfun(@isnan, resList, 'UniformOutput', false);
    tempIdx = ~cell2mat(cellfun(@all, tempCell, 'UniformOutput', false));
    
    combinedList = [resList(randIdx(round(totalCells*P)+1:end),  tempIdx(1, :))];
    if(~isempty(currList))
        combinedList = [ combinedList currList(randIdx(round(totalCells*P)+1:end),  tempIdx(1, :))];
    end
    
    [tempRMSE, tempMPE, tempCalibration] = PredictTestCells(gprList, combinedList(:, featureArray) ... 
        , socList( randIdx(round(totalCells*P)+1:end) ), false);
    
    listRMSE(count:count + length(tempRMSE) -1) = tempRMSE;
    listMPE(count:count + length(tempRMSE) -1) = tempMPE;
    listCalibration (count:count + length(tempRMSE) -1) = tempCalibration;
    
    count = count + length(tempRMSE);
    
    [train_temp, test_temp, testEnd] = PredictAllCells(gprList, xTrain, yTrain, combinedList(:, featureArray), socList( randIdx(round(totalCells*P)+1:end) ));
    testTime = testTime + testEnd;
    
    
    if(any(abs(vertcat(test_temp{:})) > 5) || any(abs(train_temp > 5)))
        disp('stop');
    end    
     
    trainError = [trainError; train_temp];
    testError = [testError, test_temp];
    
end

toc

disp(['Average train time is ', num2str(trainTime/numIterations), ' seconds']);
disp(['Average test time is ', num2str(testTime/numIterations), ' seconds']);