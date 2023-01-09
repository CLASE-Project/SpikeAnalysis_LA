PCname = getenv('COMPUTERNAME'); 

switch PCname
    case 'DESKTOP-95LU6PO' % JAT home pc
        nwbLOC = 'F:\01_Coding_Datasets\LossAversionPipeTest\CLASE007\NWB-data\20220526a\NWB_Data';
    case 'DESKTOP-I5CPDO7' % Office pc
        nwbLOC = 'Z:\LossAversion\Patient folders\CLASE007\NWB-data\20220526a\NWB_Data';

end



%% 1 reprocess nwb macro
% 1/9/23 - copy NeuroWork to home pc [spike]

%% 3 final spike sort last case
% clas19

%% 4 Check macro data quality
% 1. Pick one wire
% 2. Pick 3 bipolar contacts
% 3. Plot raw voltage / PSD / spectrogram
%    a. nwb filter
%    b. nwb raw
%    c. CSC 



%% 4a. Use CLASE007

% Brain Area: amygdala
% Hemisphere: Left
% Wire number: 1
% Number of contacts: 8
% CSC# / Rows: CSC 1:8 / matrix rows 1:8

%% 4b. Load in NWB filtered
% nwbLOC = 'F:\01_Coding_Datasets\LossAversionPipeTest\CLASE007\NWB-data\20220526a\NWB_Data';
cd(nwbLOC);
tmpLoad = nwbRead("MW13_Session_5_filter.nwb");
eleCtable = tmpLoad.general_extracellular_ephys_electrodes.vectordata;

chanID = eleCtable.get('channID').data.load();
hemis = cellstr(eleCtable.get('hemisph').data.load());
label = cellstr(eleCtable.get('label').data.load());
location = cellstr(eleCtable.get('location').data.load());
wireID = eleCtable.get('wireID').data.load();

macroROWS = contains(label,'MA_');
macro_hemi = hemis(macroROWS);
macro_location = location(macroROWS);
macro_wire = wireID(macroROWS);

% load macrodata
macroDATA = tmpLoad.processing.get('ecephys').nwbdatainterface.get('LFP').electricalseries.get('MacroWireSeries').data.load();

% Get channels of interest
amyData_filter = macroDATA(1:8,:);

%% Plot Filtered Macro data
% Raw voltage stack plot
amyData_filter = macroDATA(1:8,:);
