%% Ephys timestamps

% Ensure that you have matnwb folder downloaded and on your path
nwbMatCD = 'D:\Documents\MATLAB';
cd(nwbMatCD)

%nwbLOC = '\LossAversion\Patient folders\CLASE006\NWB-data\NWB_Data'; 

paths = [];
uiwait(msgbox('Navigate to and select the patient folder'))
paths.basePath = uigetdir;
paths.NWBdata = [strcat(paths.basePath, '\', 'NWB-data','\', 'NWB_Data', '\')];

% nwbLOC = '\LossAversion\LH_test\NWB-data\NWB_Data';

% change for your computer
% userLOC = 'Y:';

% cd([userLOC , nwbLOC])
%tmp_LA = nwbRead('MW12_Session_3_filter.nwb');

cd(paths.NWBdata)
tmp_LA = nwbRead('CLASE018_Session_3_filter.nwb');

%% ephys timestamps data are in microseconds
% mi_timestamps = tmp_LA.processing.get('ecephys').nwbdatainterface.get...
%     ('LFP').electricalseries.get('MicroWireSeries').timestamps.load; %
%    this is for micro 

% Loads in Macrowire timestamps 
ma_timestamps = tmp_LA.processing.get('ecephys').nwbdatainterface.get...
    ('LFP').electricalseries.get('MacroWireSeries').timestamps.load;


% Voltage data for all macrowires and their channels 
ma_data = tmp_LA.processing.get('ecephys').nwbdatainterface.get...
    ('LFP').electricalseries.get('MacroWireSeries').data.load;

% To get sampling frequency info you get it from the description 
ma_sampFreq = tmp_LA.processing.get('ecephys').nwbdatainterface.get...
    ('LFP').electricalseries.get('MacroWireSeries');

% the sampling rate for the filtered data is downsampled to 500 Hz. My
% sampling freq is 500 Hz. 
% use this to create power spectral denisty plots 

%% behavioral timestamps data are in microseconds
eventStamps = tmp_LA.acquisition.get('events').timestamps.load;
eventIDs = tmp_LA.acquisition.get('events').data.load;


%% spike timestamps - Don't worry about this right now
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

%behLOC = '\LossAversion\Patient folders\CLASE006\Behavioral-data\EventBehavior';

paths.behLoc = [strcat(paths.basePath, '\', 'Behavioral-data', '\')];

%behLOC = '\LossAversion\LH_test\Behavioral-data';

%cd([userLOC , behLOC])

cd(paths.behLoc)

%load("clase006_BehEvTable.mat","eventTABLE");

eventTab = load("clase_behavior_CLASE018_738812.7161.mat");

