%% Ephys timestamps

% Ensure that you have matnwb folder downloaded and on your path
% https://github.com/NeurodataWithoutBorders/matnwb/releases

nwbLOC = '\LossAversion\Patient folders\CLASE001\NWB-data\NWB_Data';

% change for your computer
userLOC = 'Z:';

cd([userLOC , nwbLOC])
tmp_LA = nwbRead('MW9_Session_6_filter.nwb');

%%
mi_timestamps = tmp_LA.processing.get('ecephys').nwbdatainterface.get...
    ('LFP').electricalseries.get('MicroWireSeries').timestamps.load;


%% spike timestamps

spkLOC = '\LossAversion\Patient folders\CLASE001\NWB-data\Spiking_Data\sort\5';
cd([userLOC , spkLOC])

load("A257_sorted_new.mat")