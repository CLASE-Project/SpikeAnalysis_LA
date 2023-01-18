%% CLASE 001

subID = 'clase001';
nwbDi = 'D:\LossAversion\Patient folders\CLASE001\NWB-data\NWB_Data';
nwbN = 'MW9_Session_6_filter.nwb';
behD = 'D:\LossAversion\Patient folders\CLASE001\Behavioral-data\EventBehavior';
ttlS = 1;

processLA_behav_v3( subID , ttlS ,'NA' , nwbDi, nwbN , behD)

%% CLASE 006

subID = 'clase006';
nwbDi = 'H:\Patient folders\CLASE006\NWB-data\NWB_Data';
nwbN = 'MW12_Session_3_filter.nwb';
behD = 'H:\Patient folders\CLASE006\Behavioral-data\EventBehavior';
ttlS = 1;

% processLA_behav( subID , ttlS  , nwbDi, nwbN , behD)

processLA_behav_v3( subID , ttlS  , nwbDi, nwbN , behD)


%% CLASE 007

subID = 'clase007';
nwbDi = 'H:\Patient folders\CLASE007\NWB-data\NWB_Data';
nwbN = 'MW13_Session_5_filter.nwb';
behD = 'H:\Patient folders\CLASE007\Behavioral-data\EventBehavior';
ttlID = 'send_TTL';
ttlS = 1;

% processLA_behav( subID , ttlS  , nwbDi, nwbN , behD)

processLA_behav_v3( subID , ttlS ,ttlID , nwbDi, nwbN , behD)


%% CLASE 008

subID = 'clase008';
nwbDi = 'H:\Patient folders\CLASE008\NWB-data\NWB_Data';
nwbN = 'CLASE08_Session_2_filter.nwb';
behD = 'H:\Patient folders\CLASE008\Behavioral-Data\EventBehavior';
ttlID = 'XXXXX';
ttlS = 1;

processLA_behav_v3( subID , ttlS ,ttlID , nwbDi, nwbN , behD)

%% CLASE 009

subID = 'clase009';
nwbDi = 'H:\Patient folders\CLASE009\NWB-data\NWB_Data';
nwbN = 'CLASE09_Session_5_filter.nwb';
behD = 'H:\Patient folders\CLASE009\Behavioral-data\EventBehavior';
ttlID = 'XXXXX';
ttlS = 1;

processLA_behav_v3( subID , ttlS ,ttlID , nwbDi, nwbN , behD)

%% CLASE 018

subID = 'clase018';
nwbDi = 'F:\01_Coding_Datasets\LossAversionPipeTest\CLASE018\NWB_processing\NWB_Data';
nwbN = 'CLASE018_Session_3_filter.nwb';
behD = 'F:\01_Coding_Datasets\LossAversionPipeTest\CLASE018\Behavioral-data\EventBehavior';
ttlID = 'XXXXX';
ttlS = 1;

processLA_behav_v3( subID , ttlS ,ttlID , nwbDi, nwbN , behD)

%% CLASE 019

subID = 'clase019';
nwbDi = 'F:\01_Coding_Datasets\LossAversionPipeTest\CLASE019\NWB-Data\NWB_Data';
nwbN = 'CLASE019_Session_2_filter.nwb';
behD = 'F:\01_Coding_Datasets\LossAversionPipeTest\CLASE019\behavior\EventBehavior';
ttlID = 'XXXXX';
ttlS = 1;

processLA_behav_v3( subID , ttlS ,ttlID , nwbDi, nwbN , behD)

%% 001

bAr = 'anterior insula';
subID = 'clase001';
nwbDi = 'H:\Patient folders\CLASE001\NWB-data\NWB_Data';
behD = 'H:\Patient folders\CLASE001\Behavioral-data\';
nwbN = 'MW9_Session_6_filter.nwb';
svDIR = 'H:\Patient folders\CLASE001\NeuroPhys_Processed';

processLA_LFP(bAr ,subID, nwbDi, behD, nwbN,[],svDIR)

% 006

bAr = 'amygdala';
subID = 'clase006';
nwbDi = 'H:\Patient folders\CLASE006\NWB-data\NWB_Data';
behD = 'H:\Patient folders\CLASE006\Behavioral-data\';
nwbN = 'MW12_Session_3_filter.nwb';
svDIR = 'H:\Patient folders\CLASE006\NeuroPhys_Processed';

processLA_LFP(bAr ,subID, nwbDi, behD, nwbN,[],svDIR)

% 007

bAr = 'amygdala';
subID = 'clase007';
nwbDi = 'H:\Patient folders\CLASE007\NWB-data\NWB_Data';
behD = 'H:\Patient folders\CLASE007\Behavioral-data\';
nwbN = 'MW13_Session_5_filter.nwb';
svDIR = 'H:\Patient folders\CLASE007\NeuroPhys_Processed';

processLA_LFP(bAr ,subID, nwbDi, behD, nwbN,[],svDIR)

% 008

bAr = 'amygdala';
subID = 'clase008';
nwbDi = 'H:\Patient folders\CLASE008\NWB-data\NWB_Data';
behD = 'H:\Patient folders\CLASE008\Behavioral-Data\';
nwbN = 'CLASE08_Session_2_filter.nwb';
svDIR = 'H:\Patient folders\CLASE008\NeuroPhys_Processed';

processLA_LFP(bAr ,subID, nwbDi, behD, nwbN,[],svDIR)

% 009
bAr = 'amygdala';
subID = 'clase009';
nwbDi = 'H:\Patient folders\CLASE009\NWB-data\NWB_Data';
behD = 'H:\Patient folders\CLASE009\Behavioral-data\';
nwbN = 'CLASE09_Session_5_filter.nwb';
svDIR = 'H:\Patient folders\CLASE009\NeuroPhys_Processed';

processLA_LFP(bAr ,subID, nwbDi, behD, nwbN,[],svDIR)









