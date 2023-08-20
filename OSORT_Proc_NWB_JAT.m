 
curPC = getenv('COMPUTERNAME');

switch curPC
    case 'DESKTOP-I5CPDO7'
        matNWBdir = 'C:\Users\Admin\Documents\MATLAB\matnwb-2.5.0.0';
        addpath(genpath(matNWBdir));

        mainOSORT = 'C:\Users\Admin\Documents\Github\OSort_NWB';
        addpath(mainOSORT)

        osortRel4 = 'C:\Users\Admin\Documents\Github\OSort_NWB\osort-v4-rel';
        addpath(genpath(osortRel4))

        subDir = 'Z:\MW_JAT_Backup\LA_Manuscript_2023\LossAversion\Patient folders\CLASE023\NWBProcessing';
        curSpikeDir = [subDir , '\Spike_Data\'];


    case 'otherwise'



end


%%

cd(curSpikeDir)
matfindN = dir('*.mat');
matfindN2 = {matfindN.name};
load(matfindN2{1},'channStoOsort','sessionID')

nwbFname = sessionID;
tmpNWBspkDir = [curSpikeDir ,  'nwb'];
if ~exist(tmpNWBspkDir,'dir')
    mkdir(tmpNWBspkDir)

    oldir = [subDir , filesep , 'NWB_Data' ];
    cd(oldir)

    nwbDIRn = dir('*.nwb');
    nwbDIRn2 = {nwbDIRn.name};
    nwbDIRn2f = nwbDIRn2{contains(nwbDIRn2,'filter')};

    newDIRfm = [tmpNWBspkDir , filesep , nwbDIRn2f];
    oldDIRfm = [oldir , filesep , nwbDIRn2f];

    copyfile(oldDIRfm , newDIRfm)
end





%% Inputs

basepath = curSpikeDir;
patientID = 'CLASE23';
% Select wires
channS = channStoOsort;

%% Run the main Function

OSort_RunFun_css("basePath",basepath,...
                 "patientID",patientID,...
                 "nwbFILE",nwbFname,...
                 "chann",channS,...
                 "defaultAlignM",1)
