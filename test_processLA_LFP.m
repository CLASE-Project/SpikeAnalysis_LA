% Test script for LA_LFP_process

bArea = 'amygdala';
curDIR = 'J:';
subI = 'clase006';
NWBdir = [curDIR,'\01_Coding_Datasets\LossAversionPipeTest\CLASE006\NWB-data\NWB_Data'];
BEHdir = [curDIR,'\01_Coding_Datasets\LossAversionPipeTest\CLASE006\Behavioral-data'];
NWBname = 'MW12_Session_3_filter.nwb';
saveLOC = [curDIR,'\01_Coding_Datasets\LossAversionPipeTest\CLASE006\NeuroPhys_Processed'];

processLA_LFP(bArea, subI , NWBdir, BEHdir, NWBname,"NA","NA",saveLOC)

%%


curDIR = 'J:';
NWBdir = [curDIR,'\01_Coding_Datasets\LossAversionPipeTest\CLASE006\NWB-data\NWB_Data'];
BEHdir = [curDIR,'\01_Coding_Datasets\LossAversionPipeTest\CLASE006\Behavioral-data'];
NWBname = 'MW12_Session_3_filter.nwb';
behaDIR = [curDIR ,'\01_Coding_Datasets\LossAversionPipeTest\CLASE006\Behavioral-data\EventBehavior'];
subI = 'clase006';
processLA_behav(subI , NWBdir, NWBname, BEHdir)



%%

