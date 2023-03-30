%% Navigate to folder with DLC file list table
dlcFileDir = 'blah.blah';
cd(dlcFileDir)
rawMatDir = 'C\matdir';

%% Load DLC file list file
dlcfileName = 'dlcfilelist.mat';
load(dlcfileName)


%% Loop through file list - it is a table
for mi = 1:height(fileTable)

    tmpFname = fileTable.FullName{mi};
    matFileInfo = matfile(tmpFname);
    matFileVars1 = whos(matFileInfo);
    matFileVars2 = {matFileVars1.name};

    %% Use matfile function to
    % 1. Find all spike files
    [outStructSPK] = getFILEinfo('CSPK');
    % 2. Find all LFP
    [outStructLFP] = getFILEinfo('CLFP');
    % 3. Find all mLFP
    [outStructMLFP] = getFILEinfo('MacroCLFP');
    % 4. Find all TTL
    [outStructTTL] = getFILEinfo('CDIG');
    % Optional Find EMG when used

    % For each
    % Save Hz, start time, end time, and raw data

    % Place into fields with Spike, MiLFP, MaLFP
    % Sub fields for trajectory


    % Save into new directory with new name




end




function [outStruct] = getFILEinfo(fTYPE)

switch fTYPE
    case 'CSPK'
        indiCES = matches(matFileVars2,'CSPK');
        % how many micro electrodes

        % cell array of stuff to save
    case 'CLFP'
        matches(matFileVars2,'CLFP');
    case 'MacroLFP'
        matches(matFileVars2,'MacroLFP');
    case 'CDIG'
        matches(matFileVars2,'CDIG');
        

end




end





