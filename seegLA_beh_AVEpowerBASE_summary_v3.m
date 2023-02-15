function [] = seegLA_beh_AVEpowerBASE_summary_v3(behDIR , ephysDIR, bandOfInt , epoch1, epoch2, wire, channS, titLE, yLLIM)
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

    trials_E1 = reshape(squeeze(avePower(epoch1,bandOfInt,trial2use,:)),...
        numel(squeeze(avePower(epoch1,bandOfInt,trial2use,:))),1);
    trials_E2 = reshape(squeeze(avePower(epoch2,bandOfInt,trial2use,:)),...
        numel(squeeze(avePower(epoch2,bandOfInt,trial2use,:))),1);

    baselineV = reshape(squeeze(avePower(1,bandOfInt,trial2use,:)),...
        numel(squeeze(avePower(1,bandOfInt,trial2use,:))),1);

    %     trials_E1_bLine = ((trials_E1 - baselineV) /baselineV ) * 100;
    %     trials_E2_bLine = ((trials_E2 - baselineV) /baselineV ) * 100;

    %     bothEpochs = [trials_E1 ; trials_E2 ; baselineV];
    %     bothEpochsN = normalize(bothEpochs,'scale');
    %     bothEpochsNup = reshape(bothEpochsN,height(trials_E1),3);


    xAXes1 = ones(numel(baselineV),1);
    hold on

    % [0.9290 0.6940 0.1250] yellow
    swarmchart(xAXes1  ,log10(baselineV),20,[0.9290 0.6940 0.1250],'filled','XJitterWidth',0.2)
    boxchart(xAXes1 , log10(baselineV),'BoxFaceColor',[0.9290 0.6940 0.1250],'MarkerStyle','none')

    % [0 0.4470 0.7410] blue
    xAXes2 = ones(numel(trials_E1),1)*2;
    swarmchart(xAXes2, log10(trials_E1),20,[0 0.4470 0.7410],'filled','XJitterWidth',0.2)
    boxchart(xAXes2 , log10(trials_E1),'BoxFaceColor',[0 0.4470 0.7410],'MarkerStyle','none')

    % [0.8500 0.3250 0.0980] red
    xAXes3 = ones(numel(trials_E2),1)*3;
    swarmchart(xAXes3,log10(trials_E2),20,[0.8500 0.3250 0.0980],'filled','XJitterWidth',0.2)
    boxchart(xAXes3 , log10(trials_E2),'BoxFaceColor',[0.8500 0.3250 0.0980],'MarkerStyle','none')
    hold off

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

    pLOC1 = quantile(log10(trials_E1),0.9);
    pLOC2 = quantile(log10(trials_E2),0.9);
    if tbl.("P-value")(1) < 0.05
        text(2,pLOC1, num2str(round(tbl.("P-value")(1),5)),'Color',[1 0 0],'FontWeight','bold')
    else
        text(2,pLOC1, num2str(round(tbl.("P-value")(1),5)),'Color',[0 0 0])
    end

    if tbl.("P-value")(2) < 0.05
        text(3,pLOC2, num2str(round(tbl.("P-value")(2),5)),'Color',[1 0 0],'FontWeight','bold')
    else
        text(3,pLOC2, num2str(round(tbl.("P-value")(2),5)),'Color',[0 0 0])
    end

    %         yticks([0 0.5 1])
    ylim(yLLIM)
    ylabel('Log average LFP power')
    xticks([1 2 3])
    xticklabels({'Baseline','Evaluation','Outcome'})

    switch ggi
        case 1
            title([titLE , ' GainLoss'])
        case 2
            title([titLE , ' GainOnly'])
    end

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



