function [] = regionSEEGamyAnalysis()


cd('E:\Dropbox\CLASE Project 2021')
load('locationSEEG.mat')

% DL

dl_all = allSubs_Dor(~isnan(allSubs_Dor) & ~isnan(allSubs_Lat);


% DM

dm_all = sum(~isnan(allSubs_Dor) & ~isnan(allSubs_Med));

% VL

vl_all = sum(~isnan(allSubs_Ven) & ~isnan(allSubs_Lat));

% VM

vm_all = sum(~isnan(allSubs_Ven) & ~isnan(allSubs_Med));






end