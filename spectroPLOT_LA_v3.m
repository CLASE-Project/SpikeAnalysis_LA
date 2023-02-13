function [tmpChannFixSM] = spectroPLOT_LA_v3(behDIR , ephysDIR, wire, channS, bandBlk , epochBlk)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here





%  epoch1, epoch2, wire, channS
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% epoch1 = 1;
% epoch2 = 4;
% bandOfInt = 4 low beta

% BEHdir1 = 'D:\LossAversion\Patient folders\CLASE001\Behavioral-data';
cd(behDIR)

[behFILE] = matdirget(1);
load(behFILE{1},'subjdata');

[behPrep] = prepareBEH(subjdata);

% ephs = 'D:\LossAversion\Patient folders\CLASE001\NeuroPhys_Processed';
cd(ephysDIR)
[neurophysFILE] = matdirget(2);
load(neurophysFILE{1},'outDATA')

% Do something about bipolar offsets 
% uniWire = unique(outDATA.recHeader.WireID);
bipolall = cell(height(outDATA.recHeader) - 1,1);
for ui = 1:height(outDATA.recHeader) - 1
    %     wireTab = outDATA.recHeader(ismember(outDATA.recHeader.WireID,uniWire(ui)),:);
    bipolall{ui} = [num2str(outDATA.recHeader.Chanl(ui)), '-',...
        num2str(outDATA.recHeader.Chanl(ui+1))];
end

channLOGv = ismember(outDATA.recHeader.WireID,wire) & ismember(outDATA.recHeader.Chanl, channS); 
channLOGv2 = false(size(channLOGv));
channLOGv2(find(channLOGv)+1) = true;
chanIDtab = outDATA.recHeader(channLOGv2,:);
channLOGv3 = channLOGv(1:end-1);
bipolUSED = bipolall(channLOGv3);
chanIDtab.bipolID = bipolUSED;

specTime = outDATA.Spec.T;
specFreq = outDATA.Spec.F;

lfpTrialList = transpose(matdirget(3));

% Get numbers from file names and resort
nameParts = cellfun(@(x) split(x,{'_','.'}), lfpTrialList,'UniformOutput',false);
trialNUMs = cellfun(@(x) str2double(x{4}), nameParts,'UniformOutput',true);

[newTrialSort,sortORDER] = sort(trialNUMs);
lfpListsort = lfpTrialList(sortORDER);

trial2use = behPrep.gainLOSS;
lfpListTrial = lfpListsort(trial2use);
newTriallst = newTrialSort(trial2use);

% need to determine time and contact ahead of time
tempSpecTm = specTime{newTriallst(1)};
tempOnsets = outDATA.timeData.timeIndsRel(:,newTriallst(1));
[sampleNum] = getSampConN(tempSpecTm , tempOnsets , epochBlk);

% trial x time x contact
trialBandDat = nan(height(newTriallst), sampleNum , sum(channLOGv3));
for li = 1:length(lfpListTrial)

    load(lfpListTrial{li},'trialSpecTro');

    % extract channels of interest
    trialChans = trialSpecTro(:,:,channLOGv3);

    specFreqT = specFreq{newTriallst(li)};
    specTimeT = specTime{newTriallst(li)};

    lowBetai = specFreqT > bandBlk(1) & specFreqT < bandBlk(2);

    trialChansLB = trialChans(lowBetai,:,:);

    timeOnSets = outDATA.timeData.timeIndsRel(:,newTriallst(li));
    timeONinsecs = timeOnSets/500;

    switch epochBlk
        case 1
            start2endE = specTimeT < timeONinsecs(3); % 3 for eval
        case 2
            start2endE = specTimeT > timeONinsecs(5) & specTimeT < timeONinsecs(5) + 0.75; % 3 for eval
    end

    baseLINE = specTimeT < timeONinsecs(2);   % 2 for eval

    baseLINEtr = trialChansLB(:,baseLINE,:);
    trialChansLBtm = trialChansLB(:,start2endE,:);

    for conI = 1:size(trialChansLBtm,3)

        tmpContact = trialChansLBtm(:,:,conI);
        tmpBaseline = baseLINEtr(:,:,conI);

        if length(tmpContact) > sampleNum
            tmpContact = tmpContact(:,1:sampleNum);
        end

        singleTrialVec = mean(tmpContact);
        singleBaseVec = mean(tmpBaseline);

        % (all values - mean of baseline) / std of baseline
        zscoreDtrial = (singleTrialVec - mean(singleBaseVec)) /...
            std(singleBaseVec);

        trialBandDat(li,:,conI) = zscoreDtrial;

    end

    disp(['Trial ' , num2str(li), ' out of ' , num2str(length(lfpListTrial)),  ' Done!'])
    
    % Add to multi dimension

    % Compute Average of trials
    
    % For each trial - z-score by baseline period


end

trialBandD2use = 3;

chI = trialBandD2use;

tmpChannel = trialBandDat(:,:,chI);

tmpTrialSm = zeros(size(tmpChannel));

for tti = 1:size(tmpChannel,1)
    blockCount = 0;
    tmpTrial = tmpChannel(tti,:);

    for ssI = 1:length(tmpTrial)

        if tmpTrial(ssI) > 4 || tmpTrial(ssI) < -4

            if ssI == 1
                blockCount = blockCount + 1;
                tmpTrialSm(tti, ssI) =  blockCount;
            elseif tmpTrialSm(tti, ssI - 1) == 0 || ssI == 1
                blockCount = blockCount + 1;
                tmpTrialSm(tti, ssI) =  blockCount;
            else
                tmpTrialSm(tti, ssI) =  tmpTrialSm(tti, ssI-1);
            end

        end
    end
end

tmpChannFix = tmpChannel;
% Loop through trials and interpolate (fill with mean)
for tti = 1:size(tmpChannel,1)
    tmpTrialFix = tmpTrialSm(tti,:);
    curTrial = tmpChannel(tti,:);
    uniBlocks = unique(tmpTrialFix(tmpTrialFix ~= 0));
    for uii = 1:length(uniBlocks)

        try
            blockIndex = find(tmpTrialFix == uniBlocks(uii));
            if blockIndex(1) <= 2
                blockIndex(1) = 3;
            elseif blockIndex(end) >= size(tmpChannel,2) - 1
                blockIndex(end) = size(tmpChannel,2) - 2;
            end
            fillmean = mean([curTrial(blockIndex(1)-2:blockIndex(1)-1) ,...
                curTrial(blockIndex(end)+1:blockIndex(end)+2)]);
            tmpChannFix(tti,blockIndex) = fillmean;
        catch
            keyboard
        end
    end
end

% Smooth data
tmpChannFixSM = tmpChannFix;
for tcS = 1:size(tmpChannFixSM,1)

    tmpTrialsm = tmpChannFix(tcS,:);
    tmpTrialsm2 = smoothdata(tmpTrialsm,'sgolay',35);
    tmpChannFixSM(tcS,:) = tmpTrialsm2;

end

switch epochBlk
    case 1
        figure;
        imagesc(tmpChannFixSM)
        colorbar
        xline(70,'k')
        figure;
        plot(mean(tmpChannFixSM))
        xlim([0 406])
        xline(70,'k')
        yline(0,'--')
        ylabel('Average z-score change from baseline')

    case 2


        time2plot = specTimeT(start2endE);

        % Reset around onset of choice
        time2plott = time2plot - time2plot(1);

        [~,point2five] = min(abs(time2plott - 0.25));

        [~,pointfive] = min(abs(time2plott - 0.5));

        xtick2use = [1 , point2five, pointfive ,length(time2plott)];

        figure;
        imagesc(tmpChannFixSM)
        xticks(xtick2use)
        xticklabels([0 0.25 0.5 0.75])
        colorbar
        axis square
        figure;
        plot(mean(tmpChannFixSM))
        xticks(xtick2use)
        xticklabels([0 0.25 0.5 0.75])
        xlim([0 125])
        yline(0,'--')
        ylabel('Average z-score change from baseline')
        axis square


end








end






function [fileDIR] = matdirget(instance)

switch instance
    case 1
        matdir1 = dir('*.mat');
        matdir2 = {matdir1.name};
        fileDIR = matdir2;
    case 2
        matdir1 = dir('*.mat');
        matdir2 = {matdir1.name};
        step1 = matdir2(contains(matdir2,'processByTrial'));
        fnameLeng = cellfun(@(x) length(x), step1, 'UniformOutput',true);
        [~,shortName] = min(fnameLeng);
        fileDIR = step1(shortName);
    case 3
        matdir1 = dir('*.mat');
        matdir2 = {matdir1.name};
        step1 = matdir2(contains(matdir2,'LFPByTrial_Spec'));
        fileDIR = step1;
end

end










function [behPrep] = prepareBEH(subjdata)

% index for check trials
checkIndex = subjdata.cs.ischecktrial;
% riskyloss < 0 = gain/loss trial :: either gain X or lose Y
% riskyloss == 0 = gain only :: either gain X or lose 0
% choice 1 = gamble, 0 = alternative

% Gain/loss trials
gainLOSS_trials = subjdata.cs.riskyLoss < 0 & ~checkIndex;
% Gain only trials
gainONLY_trials = subjdata.cs.riskyLoss == 0 & ~checkIndex;
% Gamble
gamble_trials = subjdata.cs.choice == 1 & ~checkIndex;
% Alternative
alternative_trials = subjdata.cs.choice == 0 & ~checkIndex;
% Outcome Loss
outcomeLoss = subjdata.cs.outcome < 0 & ~checkIndex;
% Outcome no change
outcomeNeutral = subjdata.cs.outcome == 0 & ~checkIndex;
% Outcome gain
outcomeGain = subjdata.cs.outcome > 0 & ~checkIndex;

ttr.gainLOSS = gainLOSS_trials;
ttr.gainONLY = gainONLY_trials;
ttr.gamble = gamble_trials;
ttr.alternat = alternative_trials;
ttr.outLOSS = outcomeLoss;
ttr.outNEUTRAL = outcomeNeutral;
ttr.outGAIN = outcomeGain;

behPrep = ttr;

end




function [sampleNum] = getSampConN(tempSpec , tmpTime, epochblk)

timeONinsecs = tmpTime/500;

switch epochblk
    case 1

        start2endE = tempSpec < timeONinsecs(3);

    case 2
        start2endE = tempSpec > timeONinsecs(5) & tempSpec < timeONinsecs(5) + 0.75;

end

sampleNum = sum(start2endE);

end
