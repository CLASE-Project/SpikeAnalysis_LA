%% CLASE001

% load behavioral data
BEHdir1 = 'D:\LossAversion\Patient folders\CLASE001\Behavioral-data';
cd(BEHdir1)
load("clase_behavior_CLASE001_738528.6375.mat")
% Risky Gain
subjdata.cs.riskyGain;
% Risky Loss
subjdata.cs.riskyLoss;
% altnerative
subjdata.cs.alternative;
% Choice
subjdata.cs.choice;
% Outcome
subjdata.cs.outcome;


bArea = 'anterior cingulate';
curDIR = 'D:';
subI = 'clase001';
mainLOC = [curDIR,'\LossAversion\Patient folders\CLASE001\NeuroPhys_Processed'];
cd(mainLOC)

% PSDs of entire trial - not great..

% Rerun through raw TS and chop out periods and run PSD

%% 

load('clase001_LFPprocessByTrial.mat','outDATA')

%% Create bipolar offset

% rawTS = outDATA.raw_rawTS;
% bpTS = cell(135,width(rawTS)-1);
% 
% for rts = 1:height(rawTS)
%     for bpi = 1:width(rawTS)-1
%         tmpTS1 = double(rawTS{rts,bpi});
%         tmpTSmean = mean(cell2mat(reshape(rawTS(rts,bpi:bpi+1),2,1)));
%         bpTS{rts,bpi} = tmpTS1 - tmpTSmean;
%     end
% end


%% Recompute PSD for time bins
timedata = outDATA.timeData.timeIndsRel;
load("clase001_LFPprocessByTrial_Spec.mat")
% 1. loop through each row and column and compute psd -

allBetaSpec = cell(135,1);
for ei = 1:height(raw_Spec)

    tmpSpec = raw_Spec{ei,1};
    betaSpec = tmpSpec.S(tmpSpec.F >= 13 & tmpSpec.F <= 30,:);
    meanBetaSpec = mean(betaSpec);
    uSTd = std(betaSpec) + meanBetaSpec;
    dSTD = meanBetaSpec - std(betaSpec);

    allBetaSpec{ei} = meanBetaSpec;

end