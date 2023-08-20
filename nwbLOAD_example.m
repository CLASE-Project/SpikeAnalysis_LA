
%% RAW data file 8kHz

nwbNameRaw = 'MW23_CLASE23_Session_1_raw.nwb';
testNwbRaw = nwbRead(nwbNameRaw);

%%

wireType = testNwbRaw.general_extracellular_ephys_electrodes.vectordata.get('label').data.load();
macroWIRE = contains(cellstr(wireType),'MA');
channNum = testNwbRaw.general_extracellular_ephys_electrodes.vectordata.get('channID').data.load();
channID = testNwbRaw.general_extracellular_ephys_electrodes.vectordata.get('location').data.load();

macroNUM =  channNum(macroWIRE);
macroID = channID(macroWIRE);

%%

% sampling frequency 8kHz
% 5 minutes of data
recordIndex = 1:8000*60*5;

rawEphys = testNwbRaw.acquisition.get('MacroWireSeries').data(1:167,1:length(recordIndex));

%% Filtered data file 500Hz

nwbNameFilt = 'MW23_CLASE23_Session_1_filter.nwb';
testNwbFilt = nwbRead(nwbNameFilt);

filtEphys = testNwbFilt.processing.get('ecephys').nwbdatainterface.get('LFP').electricalseries.get('MacroWireSeries').data.load();

% Labels from above will be consistent with respect to the filtered data



