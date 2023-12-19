function [] = processLA_LFP_BP_PSH_v2(bArea ,subjID, NWBdir, BEHdir,...
    NWBname,startchannels,stopchannels, saveDIR)

arguments

    % Required
    bArea (1,1) string
    subjID (1,1) string

    % Optional
    NWBdir (1,1) string = "NA"
    BEHdir (1,1) string = "NA"
    NWBname (1,1) string = "NA"
    startchannels (1,:) double = []
    stopchannels (1,:) double = []
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

% channel ID
chanLabels = cellstr(tmpNWB_LA.general_extracellular_ephys_electrodes.vectordata.get('label').data.load()); %use MA only!
MAchan = find(contains(chanLabels,'MA_'));
chanID = cellstr(tmpNWB_LA.general_extracellular_ephys_electrodes.vectordata.get('location').data.load());
hemisphere = cellstr(tmpNWB_LA.general_extracellular_ephys_electrodes.vectordata.get('hemisph').data.load());
shortBnames = cellstr(tmpNWB_LA.general_extracellular_ephys_electrodes.vectordata.get('shortBAn').data.load());
%%% INDEX and add to VAR
chanID_ME = chanID(MAchan);
chanHemi_ME = hemisphere(MAchan);
chanSname_ME = shortBnames(MAchan);


% Channel ID
channID = tmpNWB_LA.general_extracellular_ephys_electrodes.vectordata.get('channID').data.load();
channID_ME = channID(MAchan);
% Select only macrowires
wireID = wireID(MAchan);


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

% behFilAll = dir('*.mat');
% behFilse = {behFilAll.name};
% behFilName = behFilse{1};

% load behavioral file
% load(behFilName, 'subjdata');

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

%%%% LOOP through
% 1. Brain region
% 2. Hemisphere
% 3. Channels of interest
% 4. Frequency bands 

% Extract table and matrix

% Use info to bi polar reference






brArIND = matches(chanID_ME , bArea);

wireIDs = wireID(brArIND);
chanHemi_ME = chanHemi_ME(brArIND);
channU = channID_ME(brArIND);

% recHeader.wireIDs = wireID(brArIND);
infoTable = table(repmat(bArea,size(wireIDs)), wireIDs , chanHemi_ME , channU , 'VariableNames',...
    {'BrainROI','WireID','Hemi','Chanl'});

% Ephys
ephysData = ma_neuro(brArIND,:);


% Mean Hz Band 
% Median Hz Band 
% AUC Hz Band 
% STD Hz Band 
% Max Power per Hz Band
% Peak frequency of Max power per Hz Band

% Loop through trials
ave_maxPow = zeros(6,7,135,length(channU));
std_maxPow = zeros(6,7,135,length(channU));
max_pow    = zeros(6,7,135,length(channU));
freq_atMP  = zeros(6,7,135,length(channU));
raw_uPv = cell(135,length(channU)-1);
raw_Pxx = cell(135,length(channU)-1);
raw_PxxPS = cell(135,length(channU)-1);
raw_rawTS = cell(135,length(channU)-1);
raw_Spec = cell(135,length(channU)-1);
raw_SpecT = cell(135,1);
raw_SpecF = cell(135,1);
raw_CWT = cell(135,length(channU)-1);
timeIndsRaw = nan(7,135);
timeIndsRel = nan(7,135);
timeMarkID = {'500ms_Bef', 'choiceShow', 'respWinStart','respWinEnd','outDispStart',...
              'outDispEnd','500ms_Aft'};
%%%%%%%%%%%%%%%% MARKERS -----------------------!!!!!!!!!!!!!!!!
for bi = 1:135
    % Loop through channels
    % Identify time index and determine choice start to output end
    trialIND = ismember(eventTABLE.TrialiNum,bi);
    timeEveTmp = eventTABLE.TrialEvTm(trialIND);
    %     trialEVtmp = eventTABLE.TrialEvNum(trialIND);
    if sum(trialIND) ~= 5
        for ci = 1:length(channU)-1
            ave_maxPow(:,:,bi,ci) = nan(6,7);
            std_maxPow(:,:,bi,ci) = nan(6,7);
            max_pow(:,:,bi,ci) = nan(6,7);
            freq_atMP(:,:,bi,ci) = nan(6,7);

            raw_SpecF{bi} = nan;
            raw_SpecT{bi} = nan;
            raw_Spec{bi, ci} = nan;
            raw_CWT{bi , ci} = nan;
            raw_uPv{bi,ci} = nan;
            raw_Pxx{bi,ci} = nan;
            raw_PxxPS{bi,ci} = nan;
            raw_rawTS{bi,ci} = nan;
  
        end

        continue
    else

        trSTART_m500 = timeEveTmp(1) - 500000; % - 500 ms
        trEND_p500 = timeEveTmp(5) + 500000; % + 500 ms
        % Get MA-time vector index for trial block
        trSTARTind = getMAind(ma_ts_dn, trSTART_m500);
        trENDind = getMAind(ma_ts_dn, trEND_p500);
        allTimesTS = [trSTART_m500 ; timeEveTmp ; trEND_p500];
        for ati = 1:length(allTimesTS)

            timeIndsRaw(ati,bi) = getMAind(ma_ts_dn, allTimesTS(ati));

        end

        timeIndsRel(:,bi) = [1 ; cumsum(diff(timeIndsRaw(:,bi)))+1];
        for ci = 1:length(channU)-1
            % Get voltage index
            chanTriND_1 = double(ephysData(ci,trSTARTind:trENDind));

            % Get bipolar reference
            chanTriND_2 = double(ephysData(ci+1,trSTARTind:trENDind));
            tmpTSmean = mean([chanTriND_1 ; chanTriND_2]);
            chanTriND = chanTriND_1 - tmpTSmean;

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

            [PxxTps , FxxPS] = pspectrum(double(chanTriND),500,'FrequencyResolution',2);
            PxxPS = pow2db(PxxTps);

            % JAT old
            %       [S,F,T] = pspectrum(double(chanTriND),500,'spectrogram',TimeResolution = 0.1,...
            %             Leakage = 0.85, OverlapPercent=95);

            [S,F,T] = pspectrum(double(chanTriND),500,'spectrogram',...
                TimeResolution = 0.1,...
                Leakage = 0.85,...
                OverlapPercent = 95);
            % DAN
            %         [S, F, T] = pspectrum(double(chanTriND), 500, "spectrogram",...
            %             TimeResolution= .200, OverlapPercent=95);

            [cfs,frq] = cwt(double(chanTriND),500);
            abCFS = abs(cfs);
            timeCFS = (0:numel(double(chanTriND))-1)/500;

            raw_SpecS = S;
            raw_SpecF{bi} = F;
            raw_SpecT{bi} = T;
            raw_Spec{bi, ci} = raw_SpecS;
            raw_CWTS.CFS = abCFS;
            raw_CWTS.F = frq;
            raw_CWTS.T = timeCFS;

            raw_CWT{bi , ci} = raw_CWTS;

            raw_uPv{bi,ci} = uVp_t;
            raw_Pxx{bi,ci} = [PxxP ; Fxx];
            raw_PxxPS{bi,ci} = [PxxPS ; FxxPS];
            raw_rawTS{bi,ci} = chanTriND;

            timeBins = timeIndsRel(:,bi);
            
            
            
            
            [tp_ave_pow , tp_std_pow , tp_max_pow, ...
                tp_freq_atMP] = getFreqBinData(S,F,T,timeBins);

            ave_maxPow(:,:,bi,ci) = tp_ave_pow;
            std_maxPow(:,:,bi,ci) = tp_std_pow;
            max_pow(:,:,bi,ci) = tp_max_pow;
            freq_atMP(:,:,bi,ci) = tp_freq_atMP;

            %         troubleshootPSD(chanTriND, PxxP , uVp_t , Fxx)
            %         pause
            %         close all

            disp(['Channel ', num2str(ci), ' of ', num2str(length(channU))])
        end
        disp(['Trial ', num2str(bi), ' of 135'])
    end
end


raw_SpecMatAll = cell(135,1);
for rsi = 1:height(raw_Spec)
    tmpTrial = raw_Spec(rsi,:);
    rawSpecMatT = zeros(1024,width(tmpTrial{1}),width(tmpTrial));
    for chti = 1:width(tmpTrial)
        rawSpecMatT(:,:,chti) = tmpTrial{chti};
    end
    raw_SpecMatAll{rsi} = rawSpecMatT;
end

% outDATA.ave_uPv = ave_uPv;
% outDATA.peak_uPv = peak_uPv;
% outDATA.freq_aP_uPv = freq_aP_uPv;
outDATA.recHeader = infoTable;
outDATA.raw_uPv = raw_uPv;
outDATA.raw_Pxx = raw_Pxx;
% outDATA.raw_CWT = raw_CWT;
outDATA.raw_PxxPS = raw_PxxPS;
outDATA.raw_rawTS = raw_rawTS;
% outDATA.raw_Spec = raw_Spec;
outDATA.dataproc = datetime("now");
outDATA.timeData.timeIndsRaw = timeIndsRaw;
outDATA.timeData.timeIndsRel = timeIndsRel;
outDATA.timeData.timeMarkID = timeMarkID;
outDATA.byBand.ave_maxPow = ave_maxPow;
outDATA.byBand.std_maxPow = std_maxPow;
outDATA.byBand.max_pow = max_pow;
outDATA.byBand.freq_at_maxPow = freq_atMP;
outDATA.Spec.T = raw_SpecT;
outDATA.Spec.F = raw_SpecF;


% Save Location
cd(saveDIRu)

% Save Name
saveNAME1 = [char(subjID) , '_LFPprocessByTrial.mat'];
% saveNAME2 = [char(subjID) , '_LFPprocessByTrial_Spec.mat'];
saveNAME3 = [char(subjID) , '_LFPprocessByTrial_CWT.mat'];

% Save Data
save(saveNAME1 , "outDATA",'-v7.3');
% save(saveNAME2 , "raw_Spec",'-v7.3');
save(saveNAME3 , "raw_CWT",'-v7.3');

for svSp = 1:height(raw_SpecMatAll)
    saveNameT = [char(subjID) , '_LFPByTrial_Spec_', num2str(svSp) '.mat'];
    trialSpecTro = raw_SpecMatAll{svSp};
    save(saveNameT , "trialSpecTro",'-v7.3');
    disp(['Saved ' , num2str(svSp)])
end


end



function [tmp_ave_pow , tmp_std_pow , tmp_max_pow, ...
    tmp_freq_atMP] = getFreqBinData(S,F,T,timeBins)

bandStget = [0 , 4 ; 4 , 8 ; 8 , 13 ; 13 , 21.5 ; 21.5 , 30 ;...
    30 , 90; 90 , 250];
ts_inSecs = timeBins/500;
% ts_2use = round(ts_inSecs(2:6),3);
ts_2use = round(ts_inSecs,3);
% NEED timeBINS
tmp_ave_pow = zeros(6,7);
tmp_std_pow = zeros(6,7);
tmp_max_pow = zeros(6,7);
tmp_freq_atMP = zeros(6,7);
for ti = 1:6
    tmp_TP = T > ts_2use(ti) & T < ts_2use(ti+1); % Use T
    if sum(tmp_TP) < 5
        tmp_ave_pow(ti,:) = nan;
        tmp_std_pow(ti,:) = nan;
        tmp_max_pow(ti,:) = nan;
        tmp_freq_atMP(ti,:) = nan;
    else
        tmp_S_T = S(:,tmp_TP);
        for boi = 1:height(bandStget)
            freqRegion = F >= bandStget(boi,1) & F <= bandStget(boi,2);
            tmpFreqs = F(freqRegion);
            powData = tmp_S_T(freqRegion,:);
            maxByFreq = max(powData,[],2);
            [maxPow, maxLoc] = max(maxByFreq);

            maxFq = tmpFreqs(maxLoc);

            tmp_ave_pow(ti,boi) = mean(powData,"all");
            tmp_std_pow(ti,boi) = std(powData,[],"all");
            tmp_max_pow(ti,boi) = maxPow;
            tmp_freq_atMP(ti,boi) = maxFq;
        end
    end
end


end




function [neuroTMind] = getMAind(neuroTimestmps, eventTime)


[~ , neuroTMind] = min(abs(eventTime - neuroTimestmps));


end



