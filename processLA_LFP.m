function [] = processLA_LFP(inarg)

arguments

    inarg.NWBdir (1,1) string = "NA"
    inarg.BEHdir (1,1) string = "NA"
    inarg.NWBname (1,1) string = "NA"

end

% NWB Directory
if matches(inarg.NWBdir,"NA")
    NWBdirU = uigetdir;
else
    NWBdirU = inarg.NWBdir;
end

% NWB file name
if matches(inarg.NWBname,"NA")
    NWBfname = uigetfile(inarg.NWBname);
else
    NWBfname = inarg.NWBname;
end

cd(NWBdirU)

if isempty(test = which('nwbtest.m'))
    % find the way to bring up documents folder or search for folder
    matNWB = uigetdir;
    addpath(genpath(matNWB));
end

% Change directory to NWB location
cd(NWBdirU)
% Load NWB file
tmpNWB_LA = nwbRead(NWBfname);

% Behavior Directory
if matches(inarg.BEHdir,"NA")
    BEHdirU = uigetdir;
else
    BEHdirU = inarg.BEHdir;
end

cd(BEHdirU);

behFilAll = dir('*.mat');
behFilse = {behFilAll.name};
behFilName = behFilse{1};

% load behavioral file
load(behFilName);

































end