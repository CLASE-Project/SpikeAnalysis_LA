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

%% Behavioral event ids

behLOC = '\LossAversion\Patient folders\CLASE006\Behavioral-data';

cd([userLOC , spkLOC])

load("clase_behavior_CLASE006_738632.4781.mat","subjdata");

behaviorDATA = subjdata.cs;

