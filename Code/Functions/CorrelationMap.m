function  [featureArray, corrArray] = CorrelationMap(x, y, numFeatures)
    
tbl = [x y];
coef = corr(tbl, 'rows', 'complete', 'type', 'spearman');
%figure
%heatmap(coef);
%flip(coef,2)
featureArray = NaN(numFeatures, 1);
corrArray = NaN(numFeatures, 1);

totalFeatures = size(x,2);

if(numFeatures >= totalFeatures)
    featureArray = 1:totalFeatures;
    corrArray = coef(1:totalFeatures,end);
    return;
end
[temp, temp2] = max(abs(coef(1:totalFeatures, end)));
featureArray(1) = temp2;
corrArray(1) = temp;


lookupTable = false(totalFeatures,1);
lookupTable(temp2) = true;

tol = 1e-9;

%%find best feature based on correlation, eliminate from candidates
%%find next best one
%   are they related? if yes, get next best feature
%   if not, add to feature list and eliminate
%repeat until there are numFeatures

[val, idx] = maxk(abs(coef(1:totalFeatures, end)), totalFeatures );
val(1) = NaN;
for n = 1:numFeatures - 1
    
    %sort totalFeatures - n to find best one
    
    idxCandidate = NaN;
    bestVal = max(val(n+1:end));
    for i = n + 1:totalFeatures 
        similarity = abs(coef(lookupTable,idx(i)));
        performance = val(i);
        if( abs(performance) > 0.4 && all(similarity < 0.8))

%             disp(['performance is ' num2str(performance)]);
%             disp((similarity));
            idxCandidate = idx(i); 
            break;
        end
    end
    if (isnan(idxCandidate))
        idxCandidate = idx((abs(val - bestVal) < tol));
        idxCandidate = idxCandidate(1);
    end
    lookupTable(idxCandidate) = true;
    corrArray(n+1) = val(idx == idxCandidate);
    val(idx == idxCandidate) = NaN;
    featureArray(n+1) = idxCandidate;
end

%[corrArray, featureArray] = maxk(abs(coef(1:totalFeatures, end)), numFeatures);
[featureArray,idx] = sort(featureArray);
corrArray = corrArray(idx);


end