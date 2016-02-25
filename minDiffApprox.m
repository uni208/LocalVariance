function [threshold, dataMinDiff] = minDiffApprox(totalPdist, y, k) 
    N = length(y);
    minD = min(totalPdist(totalPdist~=0)); maxD = max(totalPdist);
    threshold = maxD; dataMinDiff = NaN;
    while minD < maxD && abs(minD-maxD) > 0.1
        thresholdList = [log(minD):((log(maxD) - log(minD))/(k-1)):log(maxD)];
        pointMinDiff = zeros(N, length(thresholdList));
        for thidx = 1:length(thresholdList)
            thresholdDistance = exp(thresholdList(thidx));
            for pointIdx = 1:N
                distance = getDistance(totalPdist,N,pointIdx);
                pointMinDiff(pointIdx, thidx) = minDiffsApprox(distance, y(setdiff(1:1:N, pointIdx)), thresholdDistance, y(pointIdx));
            end
        end
        dataDiff = mean(pointMinDiff); % figure; plot(dataDiff);
        [mv, maxI] = max(dataDiff);
        threshold = exp(thresholdList(maxI));
        dataMinDiff = mv;
        if maxI > 1 && maxI < k
            minD = exp(thresholdList(maxI-1));
            maxD = exp(thresholdList(maxI+1));
        elseif maxI == 1
            minD = exp(thresholdList(maxI));
            maxD = exp(thresholdList(maxI+1));
        elseif maxI == k
            minD = exp(thresholdList(maxI-1));
            maxD = exp(thresholdList(maxI));
        else
            display('Somethin is wrong in minDiffApprox Function..')
            break
        end
    end
    
%     if minD < maxD
%         thresholdList = [log(minD):((log(maxD) - log(minD))/(k-1)):log(maxD)];
%         initMinDiffs = zeros(N, length(thresholdList));
%         for thidx = 2:length(thresholdList)-1
%             thresholdDistance = exp(thresholdList(thidx));
%             for pointIdx = 1:N
%                 distance = getDistance(totalPdist,N,pointIdx);
%                 initMinDiffs(pointIdx, thidx) = minDiffsApprox(distance, y, thresholdDistance, pointIdx);
%             end
%         end
%         initMinDiff = mean(initMinDiffs)'; 
%         minDiffs = initMinDiffs;    minDiff = initMinDiff;
%         [~, si] = sortrows(initMinDiff,-1);
%         maxMinDiff = initMinDiff(si(1)); secondMaxMinDiff = initMinDiff(si(2));
%         maxMinTh = thresholdList(si(1)); secondMaxMinTh = thresholdList(si(2));
%         while 1
%             if abs(maxMinTh-secondMaxMinTh) < abs(log(minD)-log(maxD))*0.001
%                 break
%             end
%             thresholdDistance = exp(mean([maxMinTh secondMaxMinTh]));
%             tmpMinDiffs = zeros(N, 1);
%             for pointIdx = 1:N
%                 distance = getDistance(totalPdist,N,pointIdx);
%                 tmpMinDiffs(pointIdx,1) = minDiffsApprox(distance, y, thresholdDistance, pointIdx);
%             end
%             
%             if maxMinDiff <= mean(tmpMinDiffs)
%                 thresholdList = [thresholdList, thresholdDistance];
%                 secondMaxMinTh = maxMinTh;          secondMaxMinDiff = maxMinDiff;
%                 maxMinTh = log(thresholdDistance);  maxMinDiff = mean(tmpMinDiffs);
%             elseif maxMinDiff > mean(tmpMinDiffs) && secondMaxMinDiff <= mean(tmpMinDiffs)
%                 thresholdList = [thresholdList, thresholdDistance];
%                 secondMaxMinTh = log(thresholdDistance);    secondMaxMinDiff = mean(tmpMinDiffs);
%             else
%                 break
%             end
%             minDiffs = [minDiffs, tmpMinDiffs];
%             minDiff = [minDiff; mean(tmpMinDiffs)];
%         end
%         lastMinDiff = minDiff(end);
%         lastThreshold = thresholdList(end);
%         lastMinDiffs = minDiffs(:,end);
%         
% %         [thresholdList, sidx] = sort(thresholdList);
% %         minDiff = minDiff(sidx',1);
% %         minDiffs = minDiffs(:, sidx);
%     else
%         lastMinDiff = Nan; lastThreshold = Nan; lastMinDiffs = NaN;
%     end
end

