%% Load in all mat files available in Folder 
% Assumtion that files are in MAX

mainDIR = 'W:\LossAversion\Patient folders\CLASE001\NWB-data\Spiking_Data\sort\5.001';
% cd to Main directory
cd(mainDIR)
% localize all possible mat files
matDIR1 = dir('*.mat');
matDIR2 = {matDIR1.name};
% extract wire name
nameList1 = split(matDIR2,'_');
nameList2 = nameList1(:,:,1);

% Store relevant files in or struct/cell
allWires = struct;
for ni = 1:length(matDIR2)

    tmpNAME = nameList2{ni};
    tmpFILE = matDIR2{ni};
    load(tmpFILE)
    allWires.(tmpNAME).clustID2use = useNegative;
    allWires.(tmpNAME).allclusters = assignedNegative;
    allWires.(tmpNAME).timestamps = newTimestampsNegative;
    allWires.(tmpNAME).waveForms = newSpikesNegative;

end

%% Loop through and compare clusters


for oi = 1:length(nameList2)

    grID = nameList2{oi};
    grSTRUCT = allWires.(grID);
    [grWforms] = getWaveForms(grSTRUCT);

    [ grTruth ] = extractFeatures( waveforms, spkFS, normFlag );
    opts = statset('MaxIter',10);
    YL100k = tsne(grTruth,'Algorithm','barneshut','NumPCAComponents',50,'LearnRate',100,...
        'NumPrint',1,'Verbose',1,'Options',opts);

    for ii = 1:length(nameList2) - 1

        [ tmpComp ] = extractFeatures( waveforms, spkFS, normFlag );




    end
end









function [waveFORMs] = getWaveForms(spikeSTRUCT)

    clustIDu = spikeSTRUCT.clustID2use;
    allClusters = spikeSTRUCT.allclusters;
    waveForms = spikeSTRUCT.waveForms;

    clusIDlocs = ismember(allClusters,clustIDu);

    waveFORMs = waveForms(clusIDlocs,:);

end

















function [ outfeats ] = extractFeatures( waveforms, spkFS, normFlag )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

tempWaves = transpose(waveforms);

features = struct;

% Peak
features.Peak = max(tempWaves,[],2);
% Valley
features.Valley = min(tempWaves,[],2);
% Energy
features.Energy = trapz(abs(tempWaves),2);
% Combine for WavePCA analysis

% Peak to Peak width
[pVal, pInd] = max(tempWaves,[],2);
[vVal, vInd] = min(tempWaves,[],2);

features.widthMS = (abs(pInd-vInd)/round(spkFS))*1000;
features.Amp = pVal - vVal;

% features.WavePC1 = pcScores(:,1);

features.FSDE_Values =...
    FSDE_Method_d2(tempWaves);

intialX = [features.Peak , abs(features.Valley) ,...
    features.Energy , features.widthMS,...
    features.FSDE_Values.FDmax , features.FSDE_Values.SDmax ,...
    features.Amp];

% Eliminate negative values

if normFlag
    
    ridNegX = abs(intialX);
    
    % Normalize to 0-1
    outfeats = bsxfun(@rdivide, ridNegX, max(ridNegX));
    
else
    
    outfeats = intialX;
    
end


end