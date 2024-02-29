%% Processing steps

% 1. Raw CSC
% 2. Convert to MED
% 3. Convert to NWB

%% Use CSC2MED

% in command window
% .\CSC2MED 'C:\Users\Admin\CLASE_001\Event_Data' 'C:\NewLoc\CLASE_001\MED

%% READ MED

% C:\Users\Admin\DHN\read_MED
cd('C:\Users\Admin\DHN\')

%%
meddLOC = 'C:\Users\Admin\Downloads\LA_CLASE_01_MED\Event_Data.medd\';
cd(meddLOC)

tmpDIR = dir();
tmpDIR2 = {tmpDIR.name};
tmpDIR3 = tmpDIR2(~ismember(tmpDIR2,{'.','..'}));
tmpDIR4 = tmpDIR3(contains(tmpDIR3,'.ticd'));

tmpDIR5 = cellfun(@(x) [meddLOC , x], tmpDIR4,'UniformOutput',false);


%%
% session = read_MED(tmpDIR5{1})

%% FROM NWB - PROCESS TTLS for LA

%% subID = 'clase007';
nwbDi = 'C:\Users\Admin\Downloads\CLASE007\CLASE007\NWBProcessing';
nwbN = 'MW13_Session_5_filter.nwb';
behD = 'C:\Users\Admin\Downloads\CLASE007\CLASE007\Behavior\EventBehavior';
ttlID = 'send_TTL';
ttlS = 1;

processLA_behav_v3( subID , ttlS ,ttlID , nwbDi, nwbN , behD)

%% subID = 'clase009'

subID = 'clase009';
nwbDi = 'C:\Users\Admin\Downloads\CLASS009\CLASS009\NWBProcessing';
nwbN = 'CLASE09_Session_5_filter.nwb';
behD = 'C:\Users\Admin\Downloads\CLASS009\CLASS009\Behavior\EventBehavior';
ttlID = 'XXXXX';
ttlS = 3;

processLA_behav_v3( subID , ttlS ,ttlID , nwbDi, nwbN , behD)