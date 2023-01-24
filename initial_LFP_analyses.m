




%% CLASE001

% load behavioral data
BEHdir1 = 'D:\LossAversion\Patient folders\CLASE001\Behavioral-data';
cd(BEHdir1)
load("clase_behavior_CLASE001_738528.6375.mat")


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

%%

bArea = 'anterior cingulate';
curDIR = 'D:';
subI = 'clase001';
mainLOC = [curDIR,'\LossAversion\Patient folders\CLASE001\NeuroPhys_Processed'];
cd(mainLOC)

% PSDs of entire trial - not great..

% Rerun through raw TS and chop out periods and run PSD

%% 

load('clase001_LFPprocessByTrial.mat','outDATA')



%% Look at ave power

avePower = outDATA.byBand.ave_maxPow(:,:,:,1:size(outDATA.byBand.ave_maxPow,4)-1);

%%

% alltrials_e1_thetaBP = squeeze(avePower(1,2,:,:));
% alltrials_e4_thetaBP = squeeze(avePower(4,2,:,:));

% alltrials_e1_thetaBP_con3t4 = squeeze(avePower(1,3,gainONLY_trials,3));
% alltrials_e4_thetaBP_con3t4 = squeeze(avePower(4,3,gainONLY_trials,3));

% Band of interest
bOI = 3; % beta
% Epochs to compare
epoch1 = 1;
epoch2 = 4;
% Contacts to use

% Loop through contacts
%%
for ggi = 1:2
    figure;

    switch ggi
        case 1
            trial2use = gainONLY_trials;
        case 2
            trial2use = gainLOSS_trials;
    end

    tiledlayout(4,4)
    for ci = 1:size(avePower,4)

        trials_E1 = squeeze(avePower(epoch1,bOI,trial2use,ci));
        trials_E2 = squeeze(avePower(epoch2,bOI,trial2use,ci));

        bothEpochs = [trials_E1 ; trials_E2];
        bothEpochsN = normalize(bothEpochs,'range');
        bothEpochsNup = reshape(bothEpochsN,height(trials_E1),2);

        nexttile
        xAXes = ones(numel(bothEpochsNup(:,1)),1);
        swarmchart(xAXes  ,bothEpochsNup(:,1),20,[0 0.4470 0.7410],'filled','XJitterWidth',0.2)
        hold on
        boxchart(xAXes , bothEpochsNup(:,1),'BoxFaceColor',[0 0.4470 0.7410],'MarkerStyle','none')
        swarmchart(xAXes*2,bothEpochsNup(:,2),20,[0.8500 0.3250 0.0980],'filled','XJitterWidth',0.2)
        boxchart(xAXes*2 , bothEpochsNup(:,2),'BoxFaceColor',[0.8500 0.3250 0.0980],'MarkerStyle','none')
        hold off

        [~,pval,stats] = ttest2(trials_E1,trials_E2);

        if pval < 0.05
            title(['pvalue = ' , num2str(round(pval, 3))], 'Color',[1 0 0],'FontWeight','bold')
        else
            title(['pvalue = ' , num2str(round(pval, 3))],'Color',[0 0 0])
        end

        yticks([0 0.5 1])
        xticks([1 2])
        xticklabels({'Evaluation','Outcome'})

    end
end


%%
behDIR = 'D:\LossAversion\Patient folders\CLASE001\Behavioral-data';
ephysDIR = 'D:\LossAversion\Patient folders\CLASE001\NeuroPhys_Processed';
bandOfInt = 4;
epoch1 = 1;
epoch2 = 4;

seegLA_beh_AVEpower(behDIR , ephysDIR, bandOfInt , epoch1, epoch2)











