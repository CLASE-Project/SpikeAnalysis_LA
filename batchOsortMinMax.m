% basepath 
% -- This should be the outer folder you created in STEP 2
% basepath = 'F:\01_Coding_Datasets\LossAversionPipeTest\CLASE006\NWB-data\Spike_Data\';
% patientID = 'CLASE_6';
% nwbFname = 'MW12_Session_3_filter.nwb';
% Select wires
channS = 257:264;

basepaths = {'Z:\LossAversion\Patient folders\CLASE001\NWB-data\Spiking_Data\',...
    'Z:\LossAversion\Patient folders\CLASE006\NWB-data\Spike_Data\',...
    'Z:\LossAversion\Patient folders\CLASE007\NWB-data\20220526a\Spike_Data\',...
    'Z:\LossAversion\Patient folders\CLASE009\NWB-data\Spike_Data\'};
patientID = {'CLASE001','CLASE006','CLASE007','CLASE009'};
nwbFname = {'MW9_Session_6_filter.nwb','MW12_Session_3_filter.nwb',...
    'MW13_Session_5_filter.nwb','CLASE09_Session_5_filter.nwb'};

%% Step 6 Run the main Function


for i1 = 1:length(patientID)

    alignS = [1, 2];
    for i2 = 1:2

        OSort_RunFun_css("basePath",basepaths{i1},...
            "patientID",patientID{i1},...
            "nwbFILE",nwbFname{i1},...
            "chann",channS,...
            "defaultAlignM",alignS(i2)) % min, 2 = max


    end
end