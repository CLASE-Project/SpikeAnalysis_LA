%% CLASE001

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

rawTS = outDATA.raw_rawTS;
bpTS = cell(135,width(rawTS)-1);
for rts = 1:height(rawTS)
    tmpTS = rawTS{}





end


%%


rawTS = outDATA.raw_rawTS;
for rts = 1:height(rawTS)
    tmpTS = rawTS{}





end