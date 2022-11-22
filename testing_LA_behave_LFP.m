subID = 'clase006';
nwbDi = 'F:\Patient folders\CLASE006\NWB-data\NWB_Data';
nwbN = 'MW12_Session_3_filter.nwb';
behD = 'F:\Patient folders\CLASE006\Behavioral-data\EventBehavior';
ttlS = 1;

% processLA_behav( subID , ttlS  , nwbDi, nwbN , behD)


processLA_behav_v2( subID , ttlS  , nwbDi, nwbN , behD)

%%% FIX CLASE006 and CLASE007 

%%

bAr = 'anterior insula';
subID = 'clase001';
nwbDi = 'Z:\LossAversion\Patient folders\CLASE001\NWB-data\NWB_Data';
behD = 'Z:\LossAversion\Patient folders\CLASE001\Behavioral-data';
nwbN = 'MW9_Session_6_filter.nwb';

processLA_LFP(bAr ,subID, nwbDi, behD, nwbN)