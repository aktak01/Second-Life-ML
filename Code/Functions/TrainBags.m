function [gprList, tEnd] = TrainBags(xTrain, yTrain, numBags, sampleSize)
% Train bags  - each bag is randomized with replacement
    
    tStart = tic;

    gprList = cell(numBags,1);

    parfor cellNum = 1:numBags
        [xBag, idx] = datasample(xTrain, sampleSize, 1);

        yBag = yTrain(idx);

        gprList{cellNum} = fitrgp(xBag, yBag, 'Kernelfunction', 'ardmatern52',  'verbose', 0, 'fitmethod', 'exact');

    end


    tEnd = toc(tStart);
    disp(['Train time is ', num2str(tEnd), ' seconds']);
end
