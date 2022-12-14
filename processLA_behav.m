function [] = processLA_behav(subjID , ttlStyle, NWBdir, NWBname , behDIRsave)

arguments

    % Required
    subjID (1,1) string
    ttlStyle (1,1) double
    % Optional
    NWBdir (1,1) string = "NA"
    NWBname (1,1) string = "NA"
    behDIRsave (1,1) string = "NA"

end


% NWB Directory
if matches(NWBdir,"NA")
    NWBdirU = uigetdir;
else
    NWBdirU = NWBdir;
end

% Behavior save Directory
if matches(behDIRsave,"NA")
    BHsavedirU = uigetdir;
else
    BHsavedirU = behDIRsave;
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

% behavioral timestamps data are in microseconds
eventStamps = tmpNWB_LA.acquisition.get('events').timestamps.load;
eventSids = tmpNWB_LA.acquisition.get('events').data.load;

% BLOCK START TTL
% Total = 5
% Each Trial has 5 TTLS
% initial display of choice options % choice
% start of response window % respWindowS
% end of response window/response % respWindowE
% start of outcome display % outDispS
% end of outcome display % outDispE
% Total of 135 Trials x 5 (5 blocks of 27 trials)
% TRIALS = 675
% TOTAL = 675;

% Clean TTL id codes
eventIDcs = cellstr(eventSids);

switch ttlStyle
    case 1

        posTTLinds = contains(eventIDcs,'(0x0001)');
        if sum(posTTLinds) == 0
            posTTLinds = contains(eventIDcs,'send_TTL');

            if sum(posTTLinds) < 675

                posTTLinds = contains(eventIDcs,'send_TTL') | ~contains(eventIDcs,'0x000');

            end
        end
        newEvts = eventStamps(posTTLinds);

    case 2

        
        [processTTL] = getNewTTLs(eventIDcs);
        newEvts = eventStamps(processTTL);

        

end



% If trim input:
% Clase001 = 51

if length(newEvts) == 675
    newEvts2use = newEvts;
else
    [newEvts2use] = getNewEvents(newEvts);
end
     
blockS = [ones(135,1) ; ones(135,1)+1 ; ones(135,1)+2 ; ones(135,1)+3;...
    ones(135,1)+4];
alltrials = zeros(675,1);
trialepID = cell(675,1);
trialepNum = zeros(675,1);
tstrt = 1;
tstop = 5;
for ti = 1:135
    alltrials(tstrt:tstop) = zeros(5,1) + ti;
    trialepNum(tstrt:tstop) = 1:5;
    trialepID(tstrt:tstop) = {'choice','respWindowS','respWindowE','outDispS',...
        'outDispE'};
    tstrt = tstop + 1;
    tstop = tstop + 5;
end
triAls = alltrials;
triAlEvsNm = trialepNum;
triAlEvsId = trialepID;


eventTABLE = table(blockS, triAls, triAlEvsNm, triAlEvsId, newEvts2use,...
    'VariableNames',{'Blocks','Trials','TrialEvNum','TrialEvID','TrialEvTm'});

cd(BHsavedirU)
saveNAME = [char(subjID) , '_BehEvTable.mat'];
save(saveNAME , "eventTABLE");


end



function [newEVENTs] = getNewEvents(newEvts)

if length(newEvts) > 675

    newEvtsd = [0 ; diff(newEvts)];
    [~,pIND] = findpeaks(newEvtsd,"MinPeakHeight", 10000000);
    if length(newEvtsd) - pIND(end) == 135
        startINDn = length(newEvtsd) - 675 + 1;
        newEVENTs = newEvts(startINDn:length(newEvtsd));
    end


else
    disp('MISCOUNT TTL!!!!!!!!!')
    return
end


end




function [processTTL] = getNewTTLs(newEvts)

hexFlagsTTL = newEvts(contains(newEvts,'TTL Input'));
hexOnly = extractBetween(hexFlagsTTL,'(',')');
decFhex = hex2dec(hexOnly);
decFhex2 = decFhex(decFhex ~= 0);
tempTab = tabulate(categorical(decFhex2));
finTab = tempTab(ismember(cell2mat(tempTab(:,2)),135),:);
finInds = str2double(finTab(:,1));


processTTL = false(length(newEvts),1);
for ni = 1:length(newEvts)
    if contains(newEvts{ni},'TTL Input')
        hexOnly = extractBetween(newEvts{ni},'(',')');
        decFhex = hex2dec(hexOnly);
        if ismember(decFhex,finInds)
            processTTL(ni) = true;
        else
            continue
        end

    else
        continue
    end


end




end