function [] = processLA_LFP(bArea ,subjID, NWBdir, BEHdir, NWBname,channels, saveDIR)

arguments

    % Required
    bArea (1,1) string
    subjID (1,1) string

    % Optional
    NWBdir (1,1) string = "NA"
    BEHdir (1,1) string = "NA"
    NWBname (1,1) string = "NA"
    channels (1,:) double = []
    saveDIR (1,1) string = "NA"

end

%%%% TO DO 
% ADD bipolar reference or common average reference XXXXXXXX

% OutPut Save Directory
if matches(saveDIR,"NA")
    saveDIRu = uigetdir;
else
    saveDIRu = saveDIR;
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
% down sample ma_timestamps from 4000Hz to 500Hz
ma_ts_dn = downsample(ma_timestamps,round(4000/500));

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

% Select only macrowires
microWireID = ~(channID > 200);
wireID = wireID(microWireID);
brainRG = brainRG(microWireID);
hemiSph = hemiSph(microWireID);
channID = channID(microWireID);

% behavioral timestamps data are in microseconds
% eventStamps = tmpNWB_LA.acquisition.get('events').timestamps.load;
% eventSids = tmpNWB_LA.acquisition.get('events').data.load;

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

% load behavioralEvent table
behTabLoc = [char(BEHdirU) , filesep , 'EventBehavior'];
cd(behTabLoc);
behTabAll = dir('*.mat');
behTabse = {behTabAll.name};
behTabName = behTabse{1};

% load event behavioral file
load(behTabName, 'eventTABLE');

% First extract the rows identified as amygdala
%## IMPORTANT - in the future this may be furthered constrained by
%hemisphere, and contact number (based on which contacts are localized to
%the structure of interest with respect to VOLBRAIN or FREESURFER)

brArIND = matches(brainRG , bArea);

wireIDs = wireID(brArIND);
hemiSph = hemiSph(brArIND);
channU = channID(brArIND);

% recHeader.wireIDs = wireID(brArIND);
infoTable = table(wireIDs , hemiSph , channU , 'VariableNames',...
    {'WireID','Hemi','Chanl'});

% Ephys
ephysData = ma_neuro(brArIND,:);

% Loop through trials
ave_uPv = zeros(135,7,length(channU));
peak_uPv = zeros(135,7,length(channU));
freq_aP_uPv = zeros(135,7,length(channU));
raw_uPv = cell(135,length(channU));
raw_Pxx = cell(135,length(channU));
for bi = 1:135
    % Loop through channels
    % Identify time index and determine choice start to output end
    trialIND = ismember(eventTABLE.Trials,bi);
    timeEveTmp = eventTABLE.TrialEvTm(trialIND);
    trSTART = timeEveTmp(1);
    trEND = timeEveTmp(5);
    % Get MA-time vector index for trial block
    trSTARTind = getMAind(ma_ts_dn, trSTART); 
    trENDind = getMAind(ma_ts_dn, trEND);
    for ci = 1:length(channU)
        % Get voltage index
        chanTriND = ephysData(ci,trSTARTind:trENDind);
        % Process LFP - 
        % 1. Compute PSD
        % 2. Extract mean power bands of interest
        % 3. Compute uPv for each freqeuncy band of interest
        % 4. Determine peak freqeuncy for uPv for each frequency band of
        % interest
        % 1.
        [Pxx , Fxx] = pwelch(double(chanTriND), hanning(500), 250, 256, 500, 'onesided');
        uVp_t = sqrt(Pxx).*rms(hanning(500)).*sqrt(2).*2.*500/256;
        PxxP = 10*log10(Pxx);

        raw_uPv{bi,ci} = uVp_t;
        raw_Pxx{bi,ci} = [PxxP ; Fxx];

        bandStget = [0 , 4 ; 4 , 8 ; 8 , 13 ; 13 , 21.5 ; 21.5 , 30 ;...
            30 , 90; 90 , 250];

        for boi = 1:height(bandStget)

            freqRegion = Fxx >= bandStget(boi,1) & Fxx <= bandStget(boi,2);
            tmpFreqs = Fxx(freqRegion);
            powData = uVp_t(freqRegion);
            [maxPow, maxLoc] = max(powData);
  
            maxFq = tmpFreqs(maxLoc);

            ave_uPv(bi,boi,ci) = mean(powData);
            peak_uPv(bi,boi,ci) = maxPow;
            freq_aP_uPv(bi,boi,ci) = maxFq; 
   
        end
    end
end

outDATA.ave_uPv = ave_uPv;
outDATA.peak_uPv = peak_uPv;
outDATA.freq_aP_uPv = freq_aP_uPv;
outDATA.recHeader = infoTable;
outDATA.raw_uPv = raw_uPv;
outDATA.raw_Pxx = raw_Pxx;
outDATA.dataproc = datetime("now");


% Save Location
cd(saveDIRu)

% Save Name
saveNAME = [char(subjID) , '_LFPprocessByTrial.mat'];

% Save Data
save(saveNAME , "outDATA");



end








function [neuroTMind] = getMAind(neuroTimestmps, eventTime)


[~ , neuroTMind] = min(abs(eventTime - neuroTimestmps));


end