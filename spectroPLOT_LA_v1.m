function [] = spectroPLOT_LA_v1(behDIR , ephysDIR, wire, channS)
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

% For each trial - z-score by baseline period

for li = 1:length(lfpListTrial)

    load(lfpListTrial{li},'trialSpecTro');

    % extract channels of interest
    trialChans = trialSpecTro(:,:,channLOGv3);

    specFreqT = specFreq{newTriallst(li)};
    specTimeT = specTime{newTriallst(li)};

    lowBetai = specFreqT > 13 & specFreqT < 22;

    trialChansLB = trialChans(lowBetai,:,:);

    timeOnSets = outDATA.timeData.timeIndsRel(:,newTriallst(li));
    timeONinsecs = timeOnSets/500;

    start2endE = specTimeT < timeONinsecs(3);

    trialChansLBtm = trialChansLB(:,start2endE,:);

    test = 1;
    

%     meanLB = transpose(mean(squeeze(mean(trialChansLB)),2));
%     meanLB = squeeze(mean(trialChansLB))

    % Add to multi dimension

    % Compute Average of trials




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
