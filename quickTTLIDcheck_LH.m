% MAKE SURE NLX read functions are on your PATH!


% [~,~,~,~,eventIDS,~] =...
%     Nlx2MatEV('Events.nev', [1 1 1 1 1], 1, 1, [] );
% this is for the raw event.nev files. But we have already done this 

%%
% eventIDs is from the AccessDataFromSynology script

% eventIDs = cellstr(eventIDs);
% hexFlagsTTL = eventIDs(contains(eventIDs,'TTL Input'));
% hexOnly = extractBetween(hexFlagsTTL,'(',')');
% decFhex = hex2dec(hexOnly);
% decFhex2 = decFhex(decFhex ~= 0);

eventIDs = cellstr(eventIDs);
hexFlagsTTL = contains(eventIDs,'TTL Input'); % keeps this now as a logical vector 
% hexOnly = extractBetween(hexFlagsTTL,'(',')');
% decFhex = hex2dec(hexOnly);
% decFhex2 = decFhex(decFhex ~= 0);

behvFlagsTTL = hexFlagsTTL;
importNum = [60 62 64 70 74];
behvFlagID = [];
behvIDcount = 1; 

for hi = 1: length(hexFlagsTTL)
    if hexFlagsTTL(hi)
        tmpRow = eventIDs{hi};
        hexOnly = extractBetween(tmpRow,'(',')');
        decFhex = hex2dec(hexOnly);
        tempMem = ismember(decFhex, importNum);
        behvFlagsTTL(hi) = tempMem;
        
        if tempMem
            behvFlagID(behvIDcount) = decFhex;
            behvIDcount = behvIDcount + 1;
        end 
        
    end % if hexFlagsTTL
end % for 


% Colunm 1 is the TTL Flag ID 
% Column 2 is the number of times the TTL Flag ID occurs
% Column 3 is the percent of times the TTL Flag ID occurs (for entire
% block)

% tempTab = tabulate(categorical(decFhex2))

% first column is the integers that have the meanings 
% 60, 62, 64, 70, and 74 means that this is LA and that there are 135
%trials (second column) that also say this is LA 

% 60 is when the screen comes on to show the gamble - very first screen the
% evaluation phase 
% 62 is when the screen changes to let them know to respond. there should
% be 2 seconds between 60 and 62. if they respond before the 62 screen
% onset that is a failed trial 
% 64 is the response, this is a button press. either picked the safe or
% gamble 
% 70 is the feedback to see what the outcome was. screen comes on to show
% if they won or loss 
% 74 is when the screen goes away and this is the end of the trial 




