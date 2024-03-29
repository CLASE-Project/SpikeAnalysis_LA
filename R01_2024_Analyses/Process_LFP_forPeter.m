%% CLASE001

% bArea = 'anterior cingulate';
% curDIR = 'D:';
% subI = 'clase001';
% NWBdir = [curDIR,'\LossAversion\Patient folders\CLASE001\NWB-data\NWB_Data'];
% BEHdir = [curDIR,'\LossAversion\Patient folders\CLASE001\Behavioral-data'];
% NWBname = 'MW9_Session_6_filter.nwb';
% saveLOC = [curDIR,'\LossAversion\Patient folders\CLASE001\NeuroPhys_Processed'];
% 
% processLA_LFP_BP(bArea, subI , NWBdir, BEHdir, NWBname,"NA",saveLOC)

%% CLASE007

% bArea = 'amygdala';
% curDIR = 'D:';
% subI = 'clase007';
% NWBdir = [curDIR,'\LossAversion\Patient folders\CLASE007\NWB-data\NWB_Data'];
% BEHdir = [curDIR,'\LossAversion\Patient folders\CLASE007\Behavioral-data'];
% NWBname = 'MW13_Session_5_filter.nwb';
% saveLOC = [curDIR,'\LossAversion\Patient folders\CLASE007\NeuroPhys_Processed'];
% 
% processLA_LFP_BP(bArea, subI , NWBdir, BEHdir, NWBname,"NA",saveLOC)

%% CLASE008

% bArea = 'amygdala';
% curDIR = 'D:';
% subI = 'clase008';
% NWBdir = [curDIR,'\LossAversion\Patient folders\CLASE008\NWB-data\NWB_Data'];
% BEHdir = [curDIR,'\LossAversion\Patient folders\CLASE008\Behavioral-data'];
% NWBname = 'CLASE08_Session_2_filter.nwb';
% saveLOC = [curDIR,'\LossAversion\Patient folders\CLASE008\NeuroPhys_Processed'];
% 
% processLA_LFP_BP(bArea, subI , NWBdir, BEHdir, NWBname,"NA",saveLOC)

%% CLASE009

% bArea = 'amygdala';
% curDIR = 'D:';
% subI = 'clase009';
% NWBdir = [curDIR,'\LossAversion\Patient folders\CLASE009\NWB-data\NWB_Data'];
% BEHdir = [curDIR,'\LossAversion\Patient folders\CLASE009\Behavioral-data'];
% NWBname = 'CLASE09_Session_5_filter.nwb';
% saveLOC = [curDIR,'\LossAversion\Patient folders\CLASE009\NeuroPhys_Processed'];
% 
% processLA_LFP_BP(bArea, subI , NWBdir, BEHdir, NWBname,"NA",saveLOC)

%% CLASE018

% bArea = 'amygdala';
% curDIR = 'D:';
% subI = 'clase018';
% NWBdir = [curDIR,'\LossAversion\Patient folders\CLASE018\NWB-processing\NWB_Data'];
% BEHdir = [curDIR,'\LossAversion\Patient folders\CLASE018\Behavioral-data'];
% NWBname = 'CLASE018_Session_3_filter.nwb';
% saveLOC = [curDIR,'\LossAversion\Patient folders\CLASE018\NeuroPhys_Processed'];
% 
% processLA_LFP_BP(bArea, subI , NWBdir, BEHdir, NWBname,"NA",saveLOC)


%% 12/18/2024

curPCloc = getenv('COMPUTERNAME');
switch curPCloc
    case 'DESKTOP-FAGRV5G'  % JAT HOME PC
        mainLOC = 'G:\LA_Manuscript_2023\LossAversion'; % on the SleepLFP Sandisk with carbiner
        curDIR = 'G:\LA_Manuscript_2023';
        patDIRlco = 'G:\LA_Manuscript_2023\LossAversion\Patient folders';

    case 'DESKTOP' % JAT WORK PC
        % curDIR = 'X:\MW_JAT_Backup\LA_Manuscript_2023';


    otherwise


end

%%%% ADD MORE LOCATIONS, LEFT and RIGTH, AND CORRECT CONTACTs
% load csv
csvLOC = mainLOC;
cd(csvLOC)

patCSVtab = readtable('LA_dataLocations.xlsx');
patCSVbrainLoc = readtable('LA_brainLocations.xlsx');

nwbLOCstem = '\NWBProcessing\NWB_Data';
behLOCstem = '\Behavior';
svLOCstem = '\NeuroPhys-Processed\PSH_Summary';
svLOCprcstem = '\NeuroPhys-Processed';

for pii = 1:height(patCSVtab)


    tmpRowSubLoc = patCSVtab(pii,:);
    subI = tmpRowSubLoc.id{1};
    NWBdir = [patDIRlco,filesep,subI,nwbLOCstem];
    BEHdir = [patDIRlco,filesep,subI,behLOCstem];
    NWBname = tmpRowSubLoc.nwbfile{1};
    saveLOC = [patDIRlco,filesep,subI,svLOCstem];

    tmpSubBrains = patCSVbrainLoc(matches(patCSVbrainLoc.id,subI),:);

    tmpSubbCheck = tmpSubBrains.macLOCs{1};
    if matches(tmpSubbCheck,'nan')
        continue
    end

    bAreaSS = tmpSubBrains.macLOCs;
    bAreaHe = tmpSubBrains.hemiS;
    startchannels = tmpSubBrains.startChan;
    stopchannels = tmpSubBrains.stopChan;

    processLA_LFP_BP_PSH_v2(bAreaSS, subI , bAreaHe ,...
        NWBdir, BEHdir, NWBname,...
        startchannels,stopchannels,saveLOC)

end



%%

