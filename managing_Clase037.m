%% directory

cd('Y:\LossAversion\Patient folders\CLASE037\NWB-processing\NWB_Data')

%% load first NWB

firstNWB = nwbRead('CLASE037_Session_1_filter.nwb');
secondNWB = nwbRead('CLASE037_Session_2_filter.nwb');
es1_macro = firstNWB.processing.get('ecephys').nwbdatainterface.get('LFP').electricalseries.get('MacroWireSeries');
es2_macro = secondNWB.processing.get('ecephys').nwbdatainterface.get('LFP').electricalseries.get('MacroWireSeries');

es1_micro = firstNWB.processing.get('ecephys').nwbdatainterface.get('LFP').electricalseries.get('MicroWireSeries');
es2_micro = secondNWB.processing.get('ecephys').nwbdatainterface.get('LFP').electricalseries.get('MicroWireSeries');


%%

anno1 = firstNWB.acquisition.get('events');
anno2 = secondNWB.acquisition.get('events');

%% Combine time

% Macro
data_macro_combined = [es1_macro.data.load(), es2_macro.data.load()];
timestamps_macro_combined = [es1_macro.timestamps.load(); es2_macro.timestamps.load()];

% Micro
data_micro_combined = [es1_micro.data.load(), es2_micro.data.load()];
timestamps_micro_combined = [es1_micro.timestamps.load(); es2_micro.timestamps.load()];

%% Combine Events

% Load actual data from DataStub
events_data1 = anno1.data.load();
events_data2 = anno2.data.load();

timestamps1 = anno1.timestamps.load();
timestamps2 = anno2.timestamps.load();

% Concatenate data and timestamps
combined_events_data = [events_data1; events_data2];
combined_timestamps = [timestamps1; timestamps2];

%% Save

new_nwb = NwbFile(...
    'session_description', 'Concatenated session',...
    'identifier', 'concatenated_file',...
    'session_start_time', firstNWB.session_start_time,... % You can choose either or set new
    'file_create_date', datetime('now', 'TimeZone', 'local'));

electrodes_table = firstNWB.general_extracellular_ephys_electrodes;

% Explicitly copy the vector data entries
vectordata_entries = electrodes_table.vectordata.keys();
new_vectordata = types.untyped.Set();

for i = 1:length(vectordata_entries)
    key = vectordata_entries{i};
    new_vectordata.set(key, electrodes_table.vectordata.get(key));
end

% Create new DynamicTable
new_electrodes_table = types.hdmf_common.DynamicTable(...
    'id', electrodes_table.id,...
    'colnames', electrodes_table.colnames,...
    'description', electrodes_table.description,...
    'vectordata', new_vectordata);

new_nwb.general_extracellular_ephys_electrodes = new_electrodes_table;



%%

macro_series = types.core.ElectricalSeries(...
    'data', data_macro_combined,...
    'timestamps', timestamps_macro_combined,...
    'electrodes', es1_macro.electrodes,...
    'starting_time', [],...
    'starting_time_rate', [],...
    'description', 'Concatenated macro-wire series');

micro_series = types.core.ElectricalSeries(...
    'data', data_micro_combined,...
    'timestamps', timestamps_micro_combined,...
    'electrodes', es1_micro.electrodes,...
    'starting_time', [],...
    'starting_time_rate', [],...
    'description', 'Concatenated micro-wire series');

lfp_interface = types.core.LFP(...
    'electricalseries', types.untyped.Set(...
        'MacroWireSeries', macro_series,...
        'MicroWireSeries', micro_series));

ecephys_mod = types.core.ProcessingModule(...
    'description', 'Concatenated electrophysiology data',...
    'nwbdatainterface', types.untyped.Set('LFP', lfp_interface));

new_nwb.processing.set('ecephys', ecephys_mod);

combined_annotation = types.core.AnnotationSeries(...
    'data', combined_events_data,...
    'timestamps', combined_timestamps,...
    'description', anno1.description,...
    'comments', anno1.comments,...
    'data_unit', anno1.data_unit,...
    'data_resolution', anno1.data_resolution,...
    'data_conversion', anno1.data_conversion,...
    'timestamps_unit', anno1.timestamps_unit,...
    'starting_time_rate', [],...
    'starting_time', []);

new_nwb.acquisition.set('events', combined_annotation);

%% Load and test


