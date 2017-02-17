function out = attentionDecrease( totalPoints, maxV, minV, stablePointsB, stablePointsE )

if ~exist('stablePointsE', 'var')
    stablePointsE = 0;
end

step = (1.5*pi-pi/2)/(totalPoints-stablePointsB-stablePointsE-1);
ampli = maxV - minV; %Amplitude da função
funcSin = sin(pi/2:step:1.5*pi)*(ampli/2) + (maxV-ampli/2);
out = [repmat(maxV,1,stablePointsB) funcSin repmat(minV,1,stablePointsE)];

end

