% Test script for LA_LFP_process

bArea = 'amygdala';
curDIR = 'J:';
NWBdir = [curDIR,'\01_Coding_Datasets\LossAversionPipeTest\CLASE006\NWB-data\NWB_Data'];
BEHdir = [curDIR,'\01_Coding_Datasets\LossAversionPipeTest\CLASE006\Behavioral-data'];
NWBname = 'MW12_Session_3_filter.nwb';


processLA_LFP(bArea , NWBdir, BEHdir, NWBname)