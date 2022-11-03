function [] = runOSORTproblem()
%% Load in all mat files available in Folder 
% Assumtion that files are in MAX

mainDIR = 'W:\LossAversion\Patient folders\CLASE006\NWB-data\Spike_Data\sort\5.001';
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

    [ grFeats ] = extractFeatures( grWforms, 32, 0 );

    [~,grPCA,~,~,~] = pca(grFeats);



    allVAls = 1:length(nameList2);
    noTID = find(~ismember(allVAls,oi));

    for ii = 1:length(noTID)
        scatter(grPCA(:,1),grPCA(:,2),'red','filled')
        tmpNOid = noTID(ii);

        compID = nameList2{tmpNOid};
        compSTRUCT = allWires.(compID);
        [compWforms] = getWaveForms(compSTRUCT);
        % Invert Waveforms
        compWformsI = compWforms*-1;


        [ compFeats ] = extractFeatures( compWformsI, 32, 0 );
        [~,compPCA,~,~,~] = pca(compFeats);

        hold on
        scatter(compPCA(:,1),compPCA(:,2),'green','filled')

        grClust = grFeats(:,[1,4]);
        compClust = compFeats(:,[1,4]);
        allCclust = [grClust ; compClust];
        cidIX = [ones(height(grClust),1) ; ones(height(compClust),1)+1];

        [silh2] = silhouette(allCclust,cidIX,'sqEuclidean');

        qualSep = mean(silh2);

        disp(['Wire ' grID ' compared ' compID ' : ' num2str(qualSep) ])

        pause(2)
        close all



    end
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

tempWaves = waveforms;

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

features.widthMS = (abs(pInd-vInd));
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