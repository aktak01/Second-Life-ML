%% Get simple statistics of original data and differential form of data
function rowVector = getFeatures(data)
    rowVector = NaN(1,14);
    rowVector(1) = mean((data), 'omitnan');
    rowVector(2) = median((data), 'omitnan'); 
    rowVector(3) = nansum(data);
    rowVector(4) = nanstd(data);
    rowVector(5) = nanvar(data);
    rowVector(6) = kurtosis(data);
    rowVector(7) = iqr(data);
    %{
    gradVal = gradient(data);
    rowVector(8) = mean(gradVal, 'omitnan'); 
    rowVector(9) = median(gradVal, 'omitnan'); 
    rowVector(10) = nansum(gradVal);
    rowVector(11) = nanstd(gradVal);
    rowVector(12) = nanvar(gradVal);
    rowVector(13) = kurtosis(gradVal);
    rowVector(14) = iqr(gradVal);
    %}
end