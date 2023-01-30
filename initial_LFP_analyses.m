




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


%% CLASE007

behDIR = 'D:\LossAversion\Patient folders\CLASE007\Behavioral-data';
ephysDIR = 'D:\LossAversion\Patient folders\CLASE007\NeuroPhys_Processed';
bandOfInt = 4;
epoch1 = 2;
epoch2 = 5;
wire = 7;
channS = 67:72;
titLE = 'Putative amy contacts';

% Add channel number and wire number


% seegLA_beh_AVEpower(behDIR , ephysDIR, bandOfInt , epoch1, epoch2)
seegLA_beh_AVEpowerBASE_summary_v2(behDIR , ephysDIR, bandOfInt , epoch1, epoch2, wire, channS, titLE)

%% NON AMy contacts



channS = 73:79;
titLE = 'Putative non-amy contacts';

% Add channel number and wire number


% seegLA_beh_AVEpower(behDIR , ephysDIR, bandOfInt , epoch1, epoch2)
seegLA_beh_AVEpowerBASE_summary_v(behDIR , ephysDIR, bandOfInt , epoch1, epoch2, wire, channS, titLE)


%% CLASE 008

close all
behDIR = 'D:\LossAversion\Patient folders\CLASE008\Behavioral-data';
ephysDIR = 'D:\LossAversion\Patient folders\CLASE008\NeuroPhys_Processed';
bandOfInt = 4;
epoch1 = 2;
epoch2 = 5;
wire = 11; % 11 and 1
channS = 120:125; % 120:131 and 1:12
titLE = 'Putative amy contacts';

% Add channel number and wire number


% seegLA_beh_AVEpowerBASE_v2(behDIR , ephysDIR, bandOfInt , epoch1, epoch2, wire, channS)
seegLA_beh_AVEpowerBASE_summary_v2(behDIR , ephysDIR, bandOfInt , epoch1, epoch2, wire, channS, titLE)

%% 

wire = 1; % 11 and 1
channS = 6:12; % 120:131 and 1:12
titLE = 'Putative non-amy contacts';

% Add channel number and wire number


% seegLA_beh_AVEpower(behDIR , ephysDIR, bandOfInt , epoch1, epoch2)
seegLA_beh_AVEpowerBASE_summary_v(behDIR , ephysDIR, bandOfInt , epoch1, epoch2, wire, channS, titLE)



%% CLASE 009

close all
behDIR = 'D:\LossAversion\Patient folders\CLASE009\Behavioral-data';
ephysDIR = 'D:\LossAversion\Patient folders\CLASE009\NeuroPhys_Processed';
bandOfInt = 4;
epoch1 = 2;
epoch2 = 5;
wire = 1; % 1 and 4
channS = 4:8; % 4:8 and 39:45
titLE = 'Putative amy contacts';

% Add channel number and wire number


% seegLA_beh_AVEpowerBASE_v2(behDIR , ephysDIR, bandOfInt , epoch1, epoch2, wire, channS)
seegLA_beh_AVEpowerBASE_summary_v2(behDIR , ephysDIR, bandOfInt , epoch1, epoch2, wire, channS, titLE)


%% CLASE 006

close all
behDIR = 'D:\LossAversion\Patient folders\CLASE006\Behavioral-data';
ephysDIR = 'D:\LossAversion\Patient folders\CLASE006\NeuroPhys_Processed';
bandOfInt = 4;
epoch1 = 2;
epoch2 = 5;
wire = 7; % 
channS = 95:100; % 
titLE = 'Putative amy contacts';

% Add channel number and wire number


% seegLA_beh_AVEpowerBASE_v2(behDIR , ephysDIR, bandOfInt , epoch1, epoch2, wire, channS)
seegLA_beh_AVEpowerBASE_summary_v2(behDIR , ephysDIR, bandOfInt , epoch1, epoch2, wire, channS, titLE)

%% CLASE 018

close all
behDIR = 'D:\LossAversion\Patient folders\CLASE018\Behavioral-data';
ephysDIR = 'D:\LossAversion\Patient folders\CLASE018\NeuroPhys_Processed';
bandOfInt = 4;
epoch1 = 2;
epoch2 = 5;
wire = 2; % 
channS = 11:16; % 
titLE = 'Putative amy contacts';

% Add channel number and wire number


% seegLA_beh_AVEpowerBASE_v2(behDIR , ephysDIR, bandOfInt , epoch1, epoch2, wire, channS)
seegLA_beh_AVEpowerBASE_summary_v2(behDIR , ephysDIR, bandOfInt , epoch1, epoch2, wire, channS, titLE)

%% CLASE 019

close all
behDIR = 'D:\LossAversion\Patient folders\CLASE019\Behavioral-data';
ephysDIR = 'D:\LossAversion\Patient folders\CLASE019\NeuroPhys_Processed';
bandOfInt = 4;
epoch1 = 2;
epoch2 = 5;
wire = 3; % 
channS = 26:30; % 
titLE = 'Putative amy contacts';

% Add channel number and wire number


% seegLA_beh_AVEpowerBASE_v2(behDIR , ephysDIR, bandOfInt , epoch1, epoch2, wire, channS)
seegLA_beh_AVEpowerBASE_summary_v2(behDIR , ephysDIR, bandOfInt , epoch1, epoch2, wire, channS, titLE)

%% All patients gain / loss


caseIDs = {'CLASE007','CLASE008','CLASE009','CLASE018','CLASE019'};
behDIRs = {'D:\LossAversion\Patient folders\CLASE007\Behavioral-data',...
           'D:\LossAversion\Patient folders\CLASE008\Behavioral-data',...
           'D:\LossAversion\Patient folders\CLASE009\Behavioral-data',...
           'D:\LossAversion\Patient folders\CLASE018\Behavioral-data',...
           'D:\LossAversion\Patient folders\CLASE019\Behavioral-data'};
ephysDIRs = {'D:\LossAversion\Patient folders\CLASE007\NeuroPhys_Processed',...
           'D:\LossAversion\Patient folders\CLASE008\NeuroPhys_Processed',...
           'D:\LossAversion\Patient folders\CLASE009\NeuroPhys_Processed',...
           'D:\LossAversion\Patient folders\CLASE018\NeuroPhys_Processed',...
           'D:\LossAversion\Patient folders\CLASE019\NeuroPhys_Processed'};
bandOfInt = 4;
epoch1 = 2;
epoch2 = 5;
wireSS = [7 , 11 , 1 , 2 , 3];
channSal = {67:72 , 120:125, 4:8 , 11:16, 26:30};

allpatsSt = cell(1,5);
allpatsPc = cell(1,5);
for si = 1:length(channSal)

    [allpatsSt{si} , allpatsPc{si}] = seegLA_beh_AVEpowerBASE_allPats(behDIRs{si} ,...
        ephysDIRs{si}, bandOfInt , epoch1, epoch2, wireSS(si), channSal{si});

end



for plotSi = 1:5

    e1point = allpatsPc{plotSi}.E1;
    e2point = allpatsPc{plotSi}.E2;
    hold on
    if allpatsSt{plotSi}.E1 < 0.5
        scatter(1, e1point , 50,[0 0.4470 0.7410],'filled')
    else
        scatter(1, e1point , 50,[0 0.4470 0.7410])
    end

    if allpatsSt{plotSi}.E2 < 0.5
        scatter(2, e2point , 50,[0.8500 0.3250 0.0980],'filled')
    else
        scatter(2, e2point , 50,[0.8500 0.3250 0.0980])
    end

end

xlim([0.5 2.5])
xticks([1 2])
xticklabels({'Evaluation','Outcome'})
ylabel('Percent difference from baseline')





%%


caseIDs = {'CLASE007','CLASE008','CLASE009','CLASE018','CLASE019'};
behDIRs = {'D:\LossAversion\Patient folders\CLASE007\Behavioral-data',...
           'D:\LossAversion\Patient folders\CLASE008\Behavioral-data',...
           'D:\LossAversion\Patient folders\CLASE009\Behavioral-data',...
           'D:\LossAversion\Patient folders\CLASE018\Behavioral-data',...
           'D:\LossAversion\Patient folders\CLASE019\Behavioral-data'};
ephysDIRs = {'D:\LossAversion\Patient folders\CLASE007\NeuroPhys_Processed',...
           'D:\LossAversion\Patient folders\CLASE008\NeuroPhys_Processed',...
           'D:\LossAversion\Patient folders\CLASE009\NeuroPhys_Processed',...
           'D:\LossAversion\Patient folders\CLASE018\NeuroPhys_Processed',...
           'D:\LossAversion\Patient folders\CLASE019\NeuroPhys_Processed'};
bandOfInt = 4;
epoch1 = 2;
epoch2 = 5;
wireSS = [7 , 11 , 1 , 2 , 3];
channSal = {67:72 , 120:125, 4:8 , 11:16, 26:30};

allpatsSt = cell(1,5);
allpatsPc = cell(1,5);
for si = 1:length(channSal)

    for bi = 1:7

        [allpatsSt{si,bi} , allpatsPc{si,bi}] = seegLA_beh_AVEpowerBASE_allPats(behDIRs{si} ,...
            ephysDIRs{si}, bi , epoch1, epoch2, wireSS(si), channSal{si});

    end

end

allSigcounts = zeros(7,2);
for bandi = 1:7
    for plotSi = 1:5


        e1point = allpatsSt{plotSi,bandi}.E1;
        e2point = allpatsSt{plotSi,bandi}.E2;

        if e1point < 0.05
            allSigcounts(bandi,1) = allSigcounts(bandi,1) + 1;
        end

        if e2point < 0.05
            allSigcounts(bandi,2) = allSigcounts(bandi,2) + 1;
        end

    end
end

bar(allSigcounts)
yticks([0 1 2 3 4 5])
ylabel('# subjects with significant difference from baseline')
xticklabels({'delta','theta','alpha','low beta','high beta','low gamma','high gamma'})
legend('Evaluation','Outcome')

xlim([0.5 2.5])
xticks([1 2])
xticklabels({'Evaluation','Outcome'})
ylabel('Percent difference from baseline')






%% spectro analysis
behDIR = 'D:\LossAversion\Patient folders\CLASE007\Behavioral-data';
ephysDIR = 'D:\LossAversion\Patient folders\CLASE007\NeuroPhys_Processed';

wire = 7;
channS = 67:72;

spectroPLOT_LA_v1(behDIR , ephysDIR, wire, channS)










