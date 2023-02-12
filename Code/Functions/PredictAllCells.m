function  [trainError, testError, tEnd] = PredictAllCells(gprList, xTrain, yTrain, testList, socList)
%make predictions for test cells all training and testing data


    numBags = length(gprList);
    
    
    [yPredTrain, predictionInfo, RMSE, MPE, CS] = SingleCellPrediction(gprList, xTrain, yTrain, false, yTrain);
    
    
    trainError = yTrain - yPredTrain; 
    testError = cell(length(socList) ,1);
    
    tStart = tic;
    parfor cellNum = 1: length(socList) 
        
        xTest = cell2mat(testList(cellNum,:)); 
        yTest = socList{cellNum};
        
        filler = socList;
        [yPredTest, predictionInfo, RMSE, MPE, CS] =  SingleCellPrediction(gprList, xTest, yTest, false, filler);

        testError{cellNum} = (yTest - yPredTest);
 
    end
    
    tEnd = toc(tStart);
    disp(['Prediction time is ', num2str(tEnd), ' seconds']);
    
end

