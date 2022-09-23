subID = 'clase001';
nwbDi = 'Z:\LossAversion\Patient folders\CLASE008\NWB-data\NWB_Data';
nwbN = 'CLASE08_Session_2_filter.nwb';
behD = 'Z:\LossAversion\Patient folders\CLASE008\Behavioral-Data\EventBehavior';
ttlS = 1;

processLA_behav( subID , ttlS  , nwbDi, nwbN , behD)

%%

bAr = 'anterior insula';
subID = 'clase001';
nwbDi = 'Z:\LossAversion\Patient folders\CLASE001\NWB-data\NWB_Data';
behD = 'Z:\LossAversion\Patient folders\CLASE001\Behavioral-data';
nwbN = 'MW9_Session_6_filter.nwb';

processLA_LFP(bAr ,subID, nwbDi, behD, nwbN)