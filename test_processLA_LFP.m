%% CLASE001

bArea = 'anterior cingulate';
curDIR = 'D:';
subI = 'clase001';
NWBdir = [curDIR,'\LossAversion\Patient folders\CLASE001\NWB-data\NWB_Data'];
BEHdir = [curDIR,'\LossAversion\Patient folders\CLASE001\Behavioral-data'];
NWBname = 'MW9_Session_6_filter.nwb';
saveLOC = [curDIR,'\LossAversion\Patient folders\CLASE001\NeuroPhys_Processed'];

processLA_LFP_BP(bArea, subI , NWBdir, BEHdir, NWBname,"NA",saveLOC)

%%

% load csv
csvLOC = 'Z:\LossAversion';
cd(csvLOC)
patCSVtab = readtable('la_patientLocs.xlsx');
curDIR = 'Z:';

for pi = 1:height(patCSVtab)

    tmpRow = patCSVtab(pi,:);

    bArea = tmpRow.brainRegion{1};

    subI = tmpRow.id{1};
    NWBdir = [curDIR,tmpRow.nwbloc{1}];
    BEHdir = [curDIR,tmpRow.behloc{1}];
    NWBname = tmpRow.nwbfile{1};
    saveLOC = [curDIR,tmpRow.saveloc{1}];

    processLA_LFP(bArea, subI , NWBdir, BEHdir, NWBname,"NA",saveLOC)

end



%%

