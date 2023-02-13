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
seegLA_beh_AVEpowerBASE_summary_v3(behDIR , ephysDIR, bandOfInt , epoch1, epoch2, wire, channS, titLE)

%% Rep plot 
% CLASE 018
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
seegLA_beh_AVEpowerBASE_summary_v3(behDIR , ephysDIR, bandOfInt , epoch1, epoch2, wire, channS, titLE)

%% All plot

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
        scatter(1, e1point , 80,[0 0.4470 0.7410],'filled')
    else
        scatter(1, e1point , 80,[0 0.4470 0.7410])
    end

    if allpatsSt{plotSi}.E2 < 0.5
        scatter(2, e2point , 80,[0.8500 0.3250 0.0980],'filled')
    else
        scatter(2, e2point , 80,[0.8500 0.3250 0.0980])
    end

end

xlim([0.5 2.5])
xticks([1 2])
xticklabels({'Evaluation','Outcome'})
ylabel('Percent difference from baseline')
yline(0,'--')
axis square


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

bandNs = {'d','t','a','lb','hb','lg','hg'};
allpatsSt = struct;
allpatsPc = struct;
for bandI = 1:7
    for si = 1:length(channSal)

        [allpatsSt.(bandNs{bandI}){si} , allpatsPc.(bandNs{bandI}){si}] =...
            seegLA_beh_AVEpowerBASE_allPats(behDIRs{si} ,...
            ephysDIRs{si}, bandI , epoch1, epoch2, wireSS(si), channSal{si});

    end
end


for banddi = 1:7
    for plotSi = 1:5

        e1point = allpatsPc.(bandNs{banddi}){plotSi}.E1;
        e2point = allpatsPc.(bandNs{banddi}){plotSi}.E2;
        hold on
        if allpatsSt.(bandNs{banddi}){plotSi}.E1 < 0.5
            scatter(banddi - 0.2, e1point , 50,[0 0.4470 0.7410],'filled')
        else
            scatter(banddi - 0.2, e1point , 50,[0 0.4470 0.7410])
        end

        if allpatsSt.(bandNs{banddi}){plotSi}.E2 < 0.5
            scatter(banddi + 0.2, e2point , 50,[0.8500 0.3250 0.0980],'filled')
        else
            scatter(banddi + 0.2, e2point , 50,[0.8500 0.3250 0.0980])
        end

    end
end


xlim([0.5 7.5])
xticks(1:7)
xticklabels({'Delta','Theta','Alpha','L Beta','H Beta','L Gamma','H Gamma'})
ylabel('Percent difference from baseline')
yline(0,'--')

%%

curname = getenv('COMPUTERNAME');

switch curname
    case 'DESKTOP-FAGRV5G' % home pc

        behDIR = 'D:\LossAversion\Patient folders\CLASE007\Behavioral-data';
        ephysDIR = 'D:\LossAversion\Patient folders\CLASE007\NeuroPhys_Processed';

    case 'DESKTOP-I5CPDO7' % work pc

        behDIR = 'E:\LossAversionPipeTest\CLASE007\Behavioral-data';
        ephysDIR = 'E:\LossAversionPipeTest\CLASE007\NeuroPhys_Processed';

end



wire = 7;
channS = 67:72;
% HARD coded to low beta and pre trial 0.5s to end of evaluation
spectroPLOT_LA_v2(behDIR , ephysDIR, wire, channS)


%%

curname = getenv('COMPUTERNAME');

switch curname
    case 'DESKTOP-FAGRV5G' % home pc

        behDIR = 'D:\LossAversion\Patient folders\CLASE007\Behavioral-data';
        ephysDIR = 'D:\LossAversion\Patient folders\CLASE007\NeuroPhys_Processed';

    case 'DESKTOP-I5CPDO7' % work pc

        behDIR = 'E:\LossAversionPipeTest\CLASE007\Behavioral-data';
        ephysDIR = 'E:\LossAversionPipeTest\CLASE007\NeuroPhys_Processed';

end



wire = 7;
channS = 67:72;
bandblk = [13 22];
% HARD coded to low beta and pre trial 0.5s to end of evaluation
bS = [1 , 4 , 8 , 13 , 22 , 31 , 50];
bE = [4 , 8 , 13 , 22 , 31 , 50 , 125];

epochBlk = 2;

% allBandS = cell(1,7);
% for bi = 1:length(bS)
%     bandblk = [bS(bi) bE(bi)];
%     allBandS{bi} = spectroPLOT_LA_v3(behDIR , ephysDIR, wire, channS, bandblk, epochBlk);
% end




spectroPLOT_LA_v3(behDIR , ephysDIR, wire, channS, bandblk, epochBlk);


% save('LA_evaluation_LFP.mat','allBandS')
%%
close all
cd('D:\LossAversion\FigureData_LA')
load('LA_outcome_LFP.mat','allBandS')
for bpi = 1:7

    hold on
    tmpM = mean(allBandS{bpi});
    tmpMs = smoothdata(tmpM,'gaussian',60);
    plot(tmpMs)


end

xlim([0 390])

xline(70,'k')
yline(0,'--')
ylabel('Average z-score change from baseline')

legend('delta','theta','alpha','l beta','h beta','l gamma','h gamma')

xticks([70 230 390])
xticklabels([0 1 2])
xlabel('Time from start of Evaluation screen (s)')

%% Outcome


