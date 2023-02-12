function [listRMSE, listMPE, listCalibration] = PredictTestCells(gprList, testList, socList, show )
%make predictions for test cells    

    listRMSE = NaN(length(socList),1);
    listMPE = NaN(length(socList),1);
    listCalibration = NaN(length(socList),1);
    numBags = length(gprList);
    parfor cellNum = 1: length(listRMSE) 
        
        xTest = cell2mat(testList(cellNum,:)); 
        yTest = socList{cellNum};
        filler = socList;
        [~, ~, RMSE, MPE, CS] =  SingleCellPrediction(gprList, xTest, yTest, false, filler);
        
        listCalibration(cellNum)  = CS;

        listRMSE(cellNum) = RMSE;
        listMPE(cellNum) = MPE;
    end
end

