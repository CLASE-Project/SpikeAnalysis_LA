function [statOUT , perCHANGE] = seegLA_beh_AVEpowerBASE_allPats(behDIR , ephysDIR, bandOfInt , epoch1, epoch2, wire, channS)
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
% chanIDtab = outDATA.recHeader(channLOGv,:);

% NEED TO UPDATE outDATA table with BIPOLAR IDS (NEED TO FIX in future)****
% Remove last column (NEED TO FIX in future)*******************************
% avePower = outDATA.byBand.ave_maxPow(:,:,:,1:size(outDATA.byBand.ave_maxPow,4)-1);
avePower = outDATA.byBand.ave_maxPow(:,:,:,channLOGv);

trial2use = behPrep.gainLOSS;

% 1. Extract raw epoch data
% 2. Compute mean of baseline
% 3. Compute percent change from baseline for epoch1 and epoch2
% 4. Normalize (should change to z-score?)

trials_E1 = reshape(squeeze(avePower(epoch1,bandOfInt,trial2use,:)),...
    numel(squeeze(avePower(epoch1,bandOfInt,trial2use,:))),1);
trials_E2 = reshape(squeeze(avePower(epoch2,bandOfInt,trial2use,:)),...
    numel(squeeze(avePower(epoch2,bandOfInt,trial2use,:))),1);

baselineV = reshape(squeeze(avePower(1,bandOfInt,trial2use,:)),...
    numel(squeeze(avePower(1,bandOfInt,trial2use,:))),1);

alldata = [baselineV ; trials_E2 ; trials_E1];
allgroups = [repmat({'B'},height(baselineV),1) ; repmat({'T1'},height(trials_E1),1) ;...
    repmat({'T2'},height(trials_E2),1)];

[omniPval,outStatTab,stats] = kruskalwallis(alldata,allgroups,"off");

[results,~,~,gnames] = multcompare(stats,"CriticalValueType","dunn-sidak","Display","off");

tbl = array2table(results,"VariableNames", ...
    ["GroupA","GroupB","Lower Limit","Difference","Upper Limit","P-value"]);
tbl.("GroupA") = gnames(tbl.("GroupA"));
tbl.("GroupB") = gnames(tbl.("GroupB"));

%     [~,pval1,stats1] = ttest2(baselineV,trials_E1);
%     [~,pval2,stats2] = ttest2(baselineV,trials_E2);
%     [~,pval,stats] = ttest2(trials_E1,trials_E2);

%     eleName = ['Wi ' , num2str(chanIDtab.WireID(ci)) ,' ',...
%         'He ' , lower(chanIDtab.Hemi{ci}), ' ', ...
%         'Ch ' , num2str(chanIDtab.Chanl(ci))];

% pLOC1 = quantile(trials_E1,0.9);
% pLOC2 = quantile(trials_E2,0.9);
% if tbl.("P-value")(1) < 0.05
%     text(2,pLOC1, num2str(round(tbl.("P-value")(1),5)),'Color',[1 0 0],'FontWeight','bold')
% else
%     text(2,pLOC1, num2str(round(tbl.("P-value")(1),5)),'Color',[0 0 0])
% end
statOUT.E1 = tbl.("P-value")(1);
statOUT.E2 = tbl.("P-value")(2);

perCHANGE.E1 = ((median(trials_E1) - median(baselineV)) / median(baselineV))  * 100;
perCHANGE.E2 = ((median(trials_E2) - median(baselineV)) / median(baselineV))  * 100;

% if tbl.("P-value")(2) < 0.05
%     text(3,pLOC2, num2str(round(tbl.("P-value")(2),5)),'Color',[1 0 0],'FontWeight','bold')
% else
%     text(3,pLOC2, num2str(round(tbl.("P-value")(2),5)),'Color',[0 0 0])
% end

%         yticks([0 0.5 1])
%     ylim([0 5])
% ylabel('Average LFP power')
% xticks([1 2 3])
% xticklabels({'Baseline','Evaluation','Outcome'})

% switch ggi
%     case 1
%         title([titLE , ' GainLoss'])
%     case 2
%         title([titLE , ' GainOnly'])
% end

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



