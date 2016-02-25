function dist = getDistance(pDist, N, i)
    e = N*i - sum(1:1:i);
    s = N*(i-1) - sum(1:1:i-1) + 1;
    a = (i-1) + [0:1:i-2] .* (N - [3:1:i+1]/2);
    dist = [pDist(a), pDist(s:e)];
end