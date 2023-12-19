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
%%%% ADD MORE LOCATIONS, LEFT and RIGTH, AND CORRECT CONTACTs
% load csv
csvLOC = 'X:\MW_JAT_Backup\LA_Manuscript_2023\LossAversion';
cd(csvLOC)


patCSVtab = readtable('LA_dataLocations.xlsx');
patCSVbrainLoc = readtable('LA_brainLocations.xlsx');

curDIR = 'X:\MW_JAT_Backup\LA_Manuscript_2023';

for pi = 1:5

    tmpRowSubLoc = patCSVtab(pi,:);
    subI = tmpRowSubLoc.id{1};
    NWBdir = [curDIR,tmpRowSubLoc.nwbloc{1}];
    BEHdir = [curDIR,tmpRowSubLoc.behloc{1}];
    NWBname = tmpRowSubLoc.nwbfile{1};
    saveLOC = [curDIR,tmpRowSubLoc.saveLOC{1}];

    tmpSubBrains = patCSVbrainLoc(matches(patCSVbrainLoc.id,subI),:);

    bAreaSS = tmpSubBrains.macLOCs;
    bAreaHe = tmpSubBrains.hemiS;
    chanKeep1 = tmpSubBrains.startChan;
    chanKeep2 = tmpSubBrains.stopChan;

    processLA_LFP_BP_PSH_v2(bArea, subI , NWBdir, BEHdir, NWBname,"NA",saveLOC)

end



%%

