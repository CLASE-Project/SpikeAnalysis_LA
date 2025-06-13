% DEAL WITH CLASE 037


% Change directory to NWB location
cd('Y:\LossAversion\Patient folders\CLASE037\NWB-processing\NWB_Data')
% Load NWB file
tmpNWB_LA_1 = nwbRead('CLASE037_Session_1_filter.nwb');
tmpNWB_LA_2 = nwbRead('CLASE037_Session_2_filter.nwb');



% behavioral timestamps data are in microseconds
eventStamps_1 = tmpNWB_LA_1.acquisition.get('events').timestamps.load;
eventSids_1 = tmpNWB_LA_1.acquisition.get('events').data.load;
eventIDcs_1 = cellstr(eventSids_1);

eventStamps_2 = tmpNWB_LA_2.acquisition.get('events').timestamps.load;
eventSids_2 = tmpNWB_LA_2.acquisition.get('events').data.load;
eventIDcs_2 = cellstr(eventSids_1);

eventIDcs = [eventIDcs_1; eventIDcs_2];
eventStamps = [eventStamps_1; eventStamps_2];

[eventTABLE] = getNewTTLs(eventIDcs,eventStamps);


test = 1





function [outTable] = getNewTTLs(newEvts , newEvtTS)

hexFlagsTTL = newEvts(contains(newEvts,'TTL Input'));
hexOnly = extractBetween(hexFlagsTTL,'(',')');
decFhex = hex2dec(hexOnly);
decFhex2 = decFhex(decFhex ~= 0);
tempTab = tabulate(categorical(decFhex2));
finTab = tempTab(ismember(cell2mat(tempTab(:,2)),135),:);
finInds = str2double(finTab(:,1));

% uniqueIDS = cellfun(@(x) str2double(x), finTab(:,1));
tmpblockIND = repmat(transpose(1:5),135,1);

if height(finTab) == 5 && all(cell2mat(finTab(:,2)) == 135)

    alltrials = [];
    trialepID = {};
    trialepNum = [];
    allblocks = [];
    newEvts2use = zeros(675,1);
    for bbi = 1:5
        tmpBlck = 135;

        decFhexIND = decFhex2 == finInds(bbi);
        tmpTS2use = newEvtTS(decFhexIND);

        %         tmpTS2use = eventTS(eventS{bbi});
        newEvts2use(tmpblockIND == bbi) = tmpTS2use;
        trialepNumi = repmat(transpose(1:5),27,1);
        alltrialsi = transpose(1:tmpBlck);
        trialepIDi = repmat(transpose({'choiceShow','respWindowS','respWindowE','outDispS',...
            'outDispE'}),27,1);

        blockTi = repmat(bbi,tmpBlck,1);
        alltrials = [alltrials ; alltrialsi];
        trialepID = [trialepID ; trialepIDi];
        trialepNum = [trialepNum ; trialepNumi];
        allblocks = [allblocks ; blockTi];


    end

    %     newEvts2use = [newEvts2use ; tmpTS2use];

end

% compute offset
offsetCk = [diff(newEvts2use/1000000) ; nan];


outTable = table(allblocks, alltrials, trialepNum, trialepID, newEvts2use,...
    offsetCk,'VariableNames',{'Blocks','Trials','TrialEvNum','TrialEvID',...
    'TrialEvTm','OffsetSecs'});

end