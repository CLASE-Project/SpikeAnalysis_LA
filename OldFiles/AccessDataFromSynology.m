%% Ephys timestamps

% Ensure that you have matnwb folder downloaded and on your path
% https://github.com/NeurodataWithoutBorders/matnwb/releases

nwbLOC = '\LossAversion\Patient folders\CLASE006\NWB-data\NWB_Data';

% change for your computer
userLOC = 'Z:';

cd([userLOC , nwbLOC])
tmp_LA = nwbRead('MW12_Session_3_filter.nwb');

%% ephys timestamps data are in microseconds
mi_timestamps = tmp_LA.processing.get('ecephys').nwbdatainterface.get...
    ('LFP').electricalseries.get('MicroWireSeries').timestamps.load;

%% behavioral timestamps data are in microseconds
eventStamps = tmp_LA.acquisition.get('events').timestamps.load;


%% spike timestamps
spkLOC = '\LossAversion\Patient folders\CLASE006\NWB-data\Spike_Data\sort\5';

cd([userLOC , spkLOC])

% Single wire [wire #257]
load("A257_sorted_new.mat")

% clustsOFinterest = useNegative % cluster IDs were idenified as useful ; n = 5
% all_spike_clusters = assignedNegative % all spike cluster IDs ; n = number of
%                      threshold crossings - within vector cluster IDs
%
% timestamps = newTimeStampsNegative % time vector in NLX clock =
%              length(assignedNegative)
%
% spkTimes_cl1 =
% timestamps(ismember(all_spike_clusters,clustsOFinterest(1)));



%% Behavioral event ids

behLOC = '\LossAversion\Patient folders\CLASE006\Behavioral-data\EventBehavior';

cd([userLOC , behLOC])

%load("clase006_BehEvTable.mat","eventTABLE");



