 %% Heatmap
 % Display best correlation coefficient between output and input cell
 % array, getting a single value from early domain values
 % return range of best performance for the input based on indices, and the
 % correlation coefficient value.
 function  [s, e, minimum] = Heatmap(resL, maxCycles)
 
 
correlationMat = NaN(100,150); 


for i = 1:80
    for k = i:110
        x = NaN(length(maxCycles),1);
        for batchNumber = 1:length(maxCycles)
            resl = resL{batchNumber};
            if(isempty(resl)) 
                continue; 
            end
            x(batchNumber) = nanstd(resl(i:k));
        end
        if(length(x) ~= length(maxCycles))
            disp([num2str(length(resl)) ' != maxCycles length of ' num2str(length(resl))]);
            return;
        end
        temp = corrcoef(log(x),maxCycles, 'rows', 'complete');
        correlationMat(i,k) = temp(1,2);
        
    end
end


minimum = max(max(abs(correlationMat)));
[s,e] = find(abs(correlationMat) == minimum, 1);


 end

