function [xTrain, yTrain] = TrainTestSplit(randIdx, resList, currList, socList)
%TrainTestSplit Split data into training and testing portion. 


    P = 0.7;
    cutoff = round( length(randIdx) *P);

    xTrain = [];
    yTrain = [];
    
    yTrain = cell2mat(socList((randIdx(1:round(cutoff)))));
    
    tempCell = cellfun(@isnan, resList, 'UniformOutput', false);
    tempIdx = ~cell2mat(cellfun(@all, tempCell, 'UniformOutput', false));
   
    xTrain = cell2mat( resList(randIdx(1:cutoff), tempIdx(1, :)));

    if(isempty(currList))
        return;
    end
        
    tempCell = cellfun(@isnan, currList, 'UniformOutput', false);
    tempIdx = ~cell2mat(cellfun(@all, tempCell, 'UniformOutput', false));

    xTrain = [xTrain cell2mat( currList(randIdx(1:cutoff), tempIdx(1, :)))];
    

end

