% basepath
% -- This should be the outer folder you created in STEP 2
% basepath = 'F:\01_Coding_Datasets\LossAversionPipeTest\CLASE006\NWB-data\Spike_Data\';
% patientID = 'CLASE_6';
% nwbFname = 'MW12_Session_3_filter.nwb';
% Select wires
channS = {257:272 };

dirLet = 'J';

basepaths = {[dirLet,':\01_Coding_Datasets\LossAversionPipeTest\']};
patientID = {'CLASE018'};
nwbFname = {'CLASE018_Session_3_filter.nwb'};

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
channS = 257:272;

dirLet = 'J';

basepaths = {[dirLet,':\01_Coding_Datasets\LossAversionPipeTest\CLASE019\NWB-Data\Spike_Data\']};
patientID = {'CLASE019'};
nwbFname = {'CLASE019_Session_1_filter.nwb'};

alignS = [1, 2];
for i2 = 1:2

    OSort_RunFun_css("basePath",basepaths{1},...
        "patientID",patientID{1},...
        "nwbFILE",nwbFname{1},...
        "chann",channS,...
        "defaultAlignM",alignS(i2)) % min, 2 = max

end

