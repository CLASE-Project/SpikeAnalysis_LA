% This is for finding peaks 

% Find big offsets
[~,peakLOCS,~] = findpeaks(diff(eventStamps),'MinPeakDistance',100,'MinPeakHeight',11000000);

blocKS = zeros(4,2);

for bi = 1:5
    if bi == 1
        blocKS(bi,1) = 1;
        blocKS(bi,2) = peakLOCS(bi);
    elseif bi == 5
        blocKS(bi,1) = peakLOCS(bi - 1) + 1;
        blocKS(bi,2) = blocKS(bi,1) + 269;
    else
        blocKS(bi,1) = peakLOCS(bi - 1) + 1;
        blocKS(bi,2) = peakLOCS(bi);
    end
end

ttlCOUNT = zeros(5,1);
for tTC = 1:5

    testBlockID = eventIDcs(blocKS(tTC,1):blocKS(tTC,2));
    ttlCOUNT(tTC) = sum(contains(testBlockID,'(0x0001)'));

end




%%


testBlockTS = eventStamps(270:539);

testBlockID = eventIDcs(270:539);

posTTLinds = sum(contains(testBlockID,'(0x0001)'))