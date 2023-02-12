function [ypred, predictionInfo, RMSE, MPE, CS] =  SingleCellPrediction(gprList, xTest, yTest, show, timeList)
    
    numBags = length(gprList);
    yPredList =  NaN(length(yTest),numBags);

    
    lowBound = NaN(length(yTest),numBags);
    highBound = NaN(length(yTest),numBags);
    varWeights = NaN(length(yTest),numBags);

    %make predictions using each bag
    parfor cellNum = 1:numBags

        [y,ysd, yint] = predict(gprList{cellNum}, xTest);  
        yPredList(:,cellNum) = y;
        lowBound(:,cellNum) = yint(:,1);
        highBound(:,cellNum) = yint(:,2);
        varWeights(:, cellNum) = ysd.^2;

    end

    
    rankIdx = varWeights;
    
    %% generate prediction and confidence interval
    ypred = nansum(yPredList./rankIdx,2 ) ./ nansum(1./rankIdx,2);

    weightedSigma = sqrt ( (nansum( 1./rankIdx .* (yPredList - ypred).^2 ,2)) ./ nansum(1./rankIdx, 2) * ... 
    length(rankIdx(1,:)) ./ (  length(rankIdx(1,:)) - 1 )  );
    
    %weightedSigma = max(varWeights,1) - min(varWeights,1);
    confidenceRange = 1.96*weightedSigma;


    lowBound = ypred - 1.96 * weightedSigma;
    highBound = ypred + 1.96 * weightedSigma;
    isNotMissing = ~isnan(highBound) & ~isnan(lowBound);
    
  
    RMSE = sqrt(nansum((ypred(isNotMissing)./yTest(isNotMissing) -1).^2)/length(ypred(isNotMissing)))*100;
    MPE = mean(abs((yTest(isNotMissing)) - ypred(isNotMissing))./yTest(isNotMissing))*100;

    CS  = 100 * sum( abs(yTest(isNotMissing) - ypred(isNotMissing) ) ...
            < confidenceRange(isNotMissing) ) / length(ypred(isNotMissing));

    predictionInfo.yPredList = yPredList;
    predictionInfo.varWeights = rankIdx;
end

