%% CLASE 001 --- complete

subID = 'clase001';
nwbDi = 'D:\LossAversion\Patient folders\CLASE001\NWB-data\NWB_Data';
nwbN = 'MW9_Session_6_filter.nwb';
behD = 'D:\LossAversion\Patient folders\CLASE001\Behavioral-data\EventBehavior';
ttlS = 1;

processLA_behav_v3( subID , ttlS ,'NA' , nwbDi, nwbN , behD)

%% CLASE 006 --- complete

subID = 'clase006';
nwbDi = 'D:\LossAversion\Patient folders\CLASE006\NWB-data\NWB_Data';
nwbN =  'MW12_Session_3_filter.nwb';
behD =  'D:\LossAversion\Patient folders\CLASE006\Behavioral-data\EventBehavior';
ttlS = 1;

% processLA_behav( subID , ttlS  , nwbDi, nwbN , behD)

processLA_behav_v3( subID , ttlS,'NA'  , nwbDi, nwbN , behD)


%% CLASE 007 --- complete

subID = 'clase007';
nwbDi = 'D:\LossAversion\Patient folders\CLASE007\NWB-data\NWB_Data';
nwbN = 'MW13_Session_5_filter.nwb';
behD = 'D:\LossAversion\Patient folders\CLASE007\Behavioral-data\EventBehavior';
ttlID = 'send_TTL';
ttlS = 1;

% processLA_behav( subID , ttlS  , nwbDi, nwbN , behD)

processLA_behav_v3( subID , ttlS ,ttlID , nwbDi, nwbN , behD)


%% CLASE 008 --- complete

subID = 'clase008';
nwbDi = 'D:\LossAversion\Patient folders\CLASE008\NWB-data\NWB_Data';
nwbN = 'CLASE08_Session_2_filter.nwb';
behD = 'D:\LossAversion\Patient folders\CLASE008\Behavioral-Data\EventBehavior';
ttlID = 'XXXXX';
ttlS = 1;

processLA_behav_v3( subID , ttlS ,ttlID , nwbDi, nwbN , behD)

%% CLASE 009 --- complete

subID = 'clase009';
nwbDi = 'D:\LossAversion\Patient folders\CLASE009\NWB-data\NWB_Data';
nwbN = 'CLASE09_Session_5_filter.nwb';
behD = 'D:\LossAversion\Patient folders\CLASE009\Behavioral-data\EventBehavior';
ttlID = 'XXXXX';
ttlS = 1;

processLA_behav_v3( subID , ttlS ,ttlID , nwbDi, nwbN , behD)

%% CLASE 018 --- complete

subID = 'clase018';
nwbDi = 'D:\LossAversion\Patient folders\CLASE018\NWB-processing\NWB_Data';
nwbN = 'CLASE018_Session_3_filter.nwb';
behD = 'D:\LossAversion\Patient folders\CLASE018\Behavioral-data\EventBehavior';
ttlID = 'XXXXX';
ttlS = 1;

processLA_behav_v3( subID , ttlS ,ttlID , nwbDi, nwbN , behD)

%% CLASE 019 --- complete

subID = 'clase019';
nwbDi = 'D:\LossAversion\Patient folders\CLASE019\NWB-Data\NWB_Data';
nwbN = 'CLASE019_Session_2_filter.nwb';
behD = 'D:\LossAversion\Patient folders\CLASE019\Behavioral-data\EventBehavior';
ttlID = 'XXXXX';
ttlS = 1;

processLA_behav_v3( subID , ttlS ,ttlID , nwbDi, nwbN , behD)

%% CLASE 020 --- complete

subID = 'clase020';
nwbDi = 'Z:\MW_JAT_Backup\LA_Manuscript_2023\LossAversion\Patient folders\CLASE020\NWBProcessing\NWB_Data';
nwbN = 'CLASE020_Session_2_filter.nwb';
behD = 'Z:\MW_JAT_Backup\LA_Manuscript_2023\LossAversion\Patient folders\CLASE020\Behavior\EventBehavior';
ttlID = 'XXXXX';
ttlS = 1;

processLA_behav_v3( subID , ttlS ,ttlID , nwbDi, nwbN , behD)

%% CLASE 021 --- complete

subID = 'clase021';
nwbDi = 'Z:\MW_JAT_Backup\LA_Manuscript_2023\LossAversion\Patient folders\CLASE021\NWBProcessing\NWB_Data';
nwbN = 'CLASE021_Session_1_filter.nwb';
behD = 'Z:\MW_JAT_Backup\LA_Manuscript_2023\LossAversion\Patient folders\CLASE021\Behavior\EventBehavior';
ttlID = 'XXXXX';
ttlS = 1;

processLA_behav_v3( subID , ttlS ,ttlID , nwbDi, nwbN , behD)

%% CLASE 022 -------------------ERROR

subID = 'clase022';
nwbDi = 'Z:\MW_JAT_Backup\LA_Manuscript_2023\LossAversion\Patient folders\CLASE022\NWBProcessing\NWB_Data';
nwbN = 'CLASE022_Session_2_filter.nwb';
behD = 'Z:\MW_JAT_Backup\LA_Manuscript_2023\LossAversion\Patient folders\CLASE022\Behavior\EventBehavior';
ttlID = 'XXXXX';
ttlS = 3;

processLA_behav_v3( subID , ttlS ,ttlID , nwbDi, nwbN , behD)

%% CLASE 023 --- complete

subID = 'clase023';
nwbDi = 'Z:\MW_JAT_Backup\LA_Manuscript_2023\LossAversion\Patient folders\CLASE023\NWBProcessing\NWB_Data';
nwbN = 'MW23_CLASE23_Session_1_filter.nwb';
behD = 'Z:\MW_JAT_Backup\LA_Manuscript_2023\LossAversion\Patient folders\CLASE023\Behavior\EventBehavior';
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










