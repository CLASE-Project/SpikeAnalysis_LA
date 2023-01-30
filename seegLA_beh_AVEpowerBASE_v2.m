function [] = seegLA_beh_AVEpowerBASE_v2(behDIR , ephysDIR, bandOfInt , epoch1, epoch2, wire, channS)
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

channLOGv = ismember(outDATA.recHeader.WireID,wire) & ismember(outDATA.recHeader.Chanl, channS); 
chanIDtab = outDATA.recHeader(channLOGv,:);

% NEED TO UPDATE outDATA table with BIPOLAR IDS (NEED TO FIX in future)****
% Remove last column (NEED TO FIX in future)*******************************
% avePower = outDATA.byBand.ave_maxPow(:,:,:,1:size(outDATA.byBand.ave_maxPow,4)-1);
avePower = outDATA.byBand.ave_maxPow(:,:,:,channLOGv);

for ggi = 1:2
    figure;

    switch ggi
        case 1
            trial2use = behPrep.gainLOSS;
        case 2
            trial2use = behPrep.gainONLY;
    end

    % 1. Extract raw epoch data
    % 2. Compute mean of baseline 
    % 3. Compute percent change from baseline for epoch1 and epoch2
    % 4. Normalize (should change to z-score?)

    tiledlayout(4,ceil(size(outDATA.byBand.ave_maxPow,4)/4))
    for ci = 1:size(avePower,4)

        trials_E1 = squeeze(avePower(epoch1,bandOfInt,trial2use,ci));
        trials_E2 = squeeze(avePower(epoch2,bandOfInt,trial2use,ci));

        baselineV = mean(squeeze(avePower(1,bandOfInt,trial2use,ci)));

        trials_E1_bLine = ((trials_E1 - baselineV) /baselineV ) * 100;
        trials_E2_bLine = ((trials_E2 - baselineV) /baselineV ) * 100;

        bothEpochs = [trials_E1_bLine ; trials_E2_bLine];
        bothEpochsN = normalize(bothEpochs,'zscore');
        bothEpochsNup = reshape(bothEpochsN,height(trials_E1_bLine),2);

        nexttile
        xAXes = ones(numel(bothEpochsNup(:,1)),1);
        swarmchart(xAXes  ,bothEpochsNup(:,1),20,[0 0.4470 0.7410],'filled','XJitterWidth',0.2)
        hold on
        boxchart(xAXes , bothEpochsNup(:,1),'BoxFaceColor',[0 0.4470 0.7410],'MarkerStyle','none')
        swarmchart(xAXes*2,bothEpochsNup(:,2),20,[0.8500 0.3250 0.0980],'filled','XJitterWidth',0.2)
        boxchart(xAXes*2 , bothEpochsNup(:,2),'BoxFaceColor',[0.8500 0.3250 0.0980],'MarkerStyle','none')
        hold off

        [~,pval,stats] = ttest2(trials_E1_bLine,trials_E2_bLine);

        eleName = ['Wi ' , num2str(chanIDtab.WireID(ci)) ,' ',...
                   'He ' , lower(chanIDtab.Hemi{ci}), ' ', ...
                   'Ch ' , num2str(chanIDtab.Chanl(ci))];

        if pval < 0.05
            title(['p = ' , num2str(round(pval, 3)) , ' ' , eleName], 'Color',[1 0 0],'FontWeight','bold')
        else
            title(['p = ' , num2str(round(pval, 3)) , ' ' , eleName],'Color',[0 0 0])
        end

%         yticks([0 0.5 1])
        ylabel('Z-scored percent of basline')
        xticks([1 2])
        xticklabels({'Evaluation','Outcome'})

    end
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



