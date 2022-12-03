% basepath
% -- This should be the outer folder you created in STEP 2
% basepath = 'F:\01_Coding_Datasets\LossAversionPipeTest\CLASE006\NWB-data\Spike_Data\';
% patientID = 'CLASE_6';
% nwbFname = 'MW12_Session_3_filter.nwb';
% Select wires
channS = {[262,264],257:264 ,259:264};

dirLet = 'H';

basepaths = {[dirLet,':\Patient folders\CLASE001\NWB-data\Spike_Data\'],...
    [dirLet,':\Patient folders\CLASE007\NWB-data\Spike_Data\'],...
    [dirLet,':\Patient folders\CLASE009\NWB-data\Spike_Data\']};
patientID = {'CLASE001','CLASE007','CLASE009'};
nwbFname = {'MW9_Session_6_filter.nwb',...
    'MW13_Session_5_filter.nwb','CLASE09_Session_5_filter.nwb'};

%% Step 6 Run the main Function


for i1 = 1:length(patientID)

    alignS = [1, 2];
    for i2 = 1:2

        OSort_RunFun_css("basePath",basepaths{i1},...
            "patientID",patientID{i1},...
            "nwbFILE",nwbFname{i1},...
            "chann",channS{i1},...
            "defaultAlignM",alignS(i2)) % min, 2 = max

    end
end

%% Single case check -
channS = [257, 259, 262, 264];

dirLet = 'D';

basepaths = {[dirLet,':\LossAversionHomeTest\CLASE006\NWB-data\Spike_Data\']};
patientID = {'CLASE006'};
nwbFname = {'MW12_Session_3_filter.nwb'};

alignS = [1, 2];
for i2 = 1:2

    OSort_RunFun_css("basePath",basepaths{1},...
        "patientID",patientID{1},...
        "nwbFILE",nwbFname{1},...
        "chann",channS,...
        "defaultAlignM",alignS(i2)) % min, 2 = max

end

