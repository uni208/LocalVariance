function [LocalVariances, epsilonAADi, epsilonADWADi, epsilonADeWADi, epsilonCnti] = LocalVariance(xnorm, y)

[N, D] = size(xnorm);

epsilonAADi = NaN(N,1);
epsilonADWADi = NaN(N,1);
epsilonADeWADi = NaN(N,1);
epsilonCnti = NaN(N,1);


ynorm = zscore(y);

tic
totalPdist = pdist(xnorm);
% [minError, threshold] = minErrorApprox2(totalPdist, y, 100);
[threshold, minError] = minDiffApprox(totalPdist, y, 10);
thresholdSelectionTime = toc;

tic
for pointIdx = 1:N
    distance = getDistance(totalPdist, N, pointIdx); idx = setdiff(1:1:N, pointIdx);
    epsilonIdx = distance < threshold;
    edist = distance(epsilonIdx)'; edist = edist + eps;
    if sum(epsilonIdx) > 0
        epsilonAADi(pointIdx,1) = mean(  abs(ynorm(idx(epsilonIdx)) - repmat(ynorm(pointIdx), sum(epsilonIdx),1)) );
        epsilonADWADi(pointIdx,1) = (1 - edist ./ (threshold))' * abs(ynorm(idx(epsilonIdx)) - repmat(ynorm(pointIdx), sum(epsilonIdx),1)) / sum((1 - edist ./ (threshold)));                %   distance weight
        epsilonADeWADi(pointIdx,1) = exp(power((1 - edist ./ (threshold)),2))' * abs(ynorm(idx(epsilonIdx)) - repmat(ynorm(pointIdx), sum(epsilonIdx),1)) / sum(exp(power((1 - edist ./ (threshold)),2)));     %   distance weight
        epsilonCnti(pointIdx, 1) = sum(epsilonIdx);
    end
end
epsilonTime = toc;

LocalVariances.threshold = threshold;
LocalVariances.minError = minError;
LocalVariances.thresholdSelectionTime = thresholdSelectionTime;
LocalVariances.AAD = nanmean(epsilonAADi)';
LocalVariances.WAAD = nansum(epsilonCnti.*epsilonAADi)' ./ nansum(epsilonCnti)';
LocalVariances.ADWAD = nanmean(epsilonADWADi)';
LocalVariances.WADWAD = nansum(epsilonCnti.*epsilonADWADi)' ./ nansum(epsilonCnti)';
LocalVariances.ADeWAD = nanmean(epsilonADeWADi)';
LocalVariances.WADeWAD = nansum(epsilonCnti.*epsilonADeWADi)' ./ nansum(epsilonCnti)';
LocalVariances.existNeighborCnt = sum(~isnan(epsilonCnti));
LocalVariances.AvgNeighborCnt = nanmean(epsilonCnti)';
LocalVariances.CumNeighborCnt = nansum(epsilonCnti)';
LocalVariances.Time = epsilonTime;

end
