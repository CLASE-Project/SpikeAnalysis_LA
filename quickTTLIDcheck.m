% MAKE SURE NLX read functions are on your PATH!


[~,~,~,~,eventIDS,~] =...
    Nlx2MatEV('Events.nev', [1 1 1 1 1], 1, 1, [] );

%%

hexFlagsTTL = eventIDS(contains(eventIDS,'TTL Input'));
hexOnly = extractBetween(hexFlagsTTL,'(',')');
decFhex = hex2dec(hexOnly);
decFhex2 = decFhex(decFhex ~= 0);

% Colunm 1 is the TTL Flag ID 
% Column 2 is the number of times the TTL Flag ID occurs
% Column 3 is the percent of times the TTL Flag ID occurs (for entire
% block)
tempTab = tabulate(categorical(decFhex2))

