function [] = processLA_LFP(bArea , NWBdir, BEHdir, NWBname, hemi, channels)

arguments

    % Required
    bArea (1,1) string

    % Optional
    NWBdir (1,1) string = "NA"
    BEHdir (1,1) string = "NA"
    NWBname (1,1) string = "NA"
    hemi (1,1) string = "L"
    channels (1,:) double = []

end

% NWB Directory
if matches(NWBdir,"NA")
    NWBdirU = uigetdir;
else
    NWBdirU = NWBdir;
end

% NWB file name
if matches(NWBname,"NA")
    NWBfname = uigetfile(NWBname);
else
    NWBfname = NWBname;
end

cd(NWBdirU)

nwbCHECK = which('nwbtest.m');
if isempty(nwbCHECK)
    % find the way to bring up documents folder or search for folder
    matNWB = uigetdir;
    addpath(genpath(matNWB));
end

% Change directory to NWB location
cd(NWBdirU)
% Load NWB file
tmpNWB_LA = nwbRead(NWBfname);
% MA timestamps
ma_timestamps = tmpNWB_LA.processing.get('ecephys').nwbdatainterface.get...
    ('LFP').electricalseries.get('MacroWireSeries').timestamps.load;
% MA filterd volts
ma_neuro = tmpNWB_LA.processing.get('ecephys').nwbdatainterface.get...
    ('LFP').electricalseries.get('MacroWireSeries').data.load;
% Wire number
wireID = tmpNWB_LA.general_extracellular_ephys_electrodes.vectordata.get('wireID').data.load();
% Brain area
brainRG = cellstr(tmpNWB_LA.general_extracellular_ephys_electrodes.vectordata.get('location').data.load());
% Hemisphere
hemiSph = cellstr(tmpNWB_LA.general_extracellular_ephys_electrodes.vectordata.get('hemisph').data.load());
% Channel ID
channID = tmpNWB_LA.general_extracellular_ephys_electrodes.vectordata.get('channID').data.load();

% behavioral timestamps data are in microseconds
eventStamps = tmpNWB_LA.acquisition.get('events').timestamps.load;
eventSids = tmpNWB_LA.acquisition.get('events').data.load;

% Behavior Directory
if matches(BEHdir,"NA")
    BEHdirU = uigetdir;
else
    BEHdirU = BEHdir;
end

cd(BEHdirU);

behFilAll = dir('*.mat');
behFilse = {behFilAll.name};
behFilName = behFilse{1};

% load behavioral file
load(behFilName, 'subjdata');

% First extract the rows identified as amygdala
%## IMPORTANT - in the future this may be furthered constrained by
%hemisphere, and contact number (based on which contacts are localized to
%the structure of interest with respect to VOLBRAIN or FREESURFER)

brArIND = matches(brainRG , bArea);

wireIDs = wireID(brArIND);
hemiSph = hemiSph(brArIND);
channU = channID(brArIND);

% recHeader.wireIDs = wireID(brArIND);
recHeader.infoTable = table(wireIDs , hemiSph , channU , 'VariableNames',...
    {'WireID','Hemi','Chanl'});

% Ephys
ephysData = ma_neuro(brArIND,:);

% Loop through trials
for bi = 1:length(5)
    % Loop through channels
    for ci = 1:length(channU)
        % Get voltage index





    end


end


































end