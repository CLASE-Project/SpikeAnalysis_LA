% location F:\01_Coding_Datasets\LossAversionPipeTest\CLASE019\NWB-Data\Spike_Data\sort
PCname = getenv('COMPUTERNAME'); 

switch PCname
    case 'DESKTOP-FAGRV5G' % JAT home pc
        spkLOC = 'F:\01_Coding_Datasets\LossAversionPipeTest\CLASE007\NWB-data\Spike_Data\sort\5.002';
    case 'DESKTOP-I5CPDO7' % Office pc
        spkLOC = 'Z:\LossAversion\Patient folders\CLASE007\NWB-data\20220526a\NWB_Data';

end

%% 1 
% CD to positive threshold folder
cd(spkLOC)

%% 2
% Loop through each wire and Cross Correlation spike times between wires

spkmat1 = dir("*.mat");
spkmat2 = {spkmat1.name};

alllen = nan(length(spkmat2),1);
for si = 1:length(spkmat2)
    load(spkmat2{si},"finalCheck");
    tmpIDs = sum(~ismember(finalCheck.clustIND,99999999));
    alllen(si) = tmpIDs;

end

figure;
a257 = load('A257_sorted_new.mat','finalCheck');
histogram(a257.finalCheck.clustTS)

figure;
a264 = load('A264_sorted_new.mat','finalCheck');
histogram(a264.finalCheck.clustTS)

figure;
a258 = load('A258_sorted_new.mat','finalCheck');
histogram(a258.finalCheck.clustTS)