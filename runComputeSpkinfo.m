

flU = 'F:\01_Coding_Datasets\LossAversionPipeTest\CLASE006\NWB-data\Spike_Data\sort\5';
cd(flU)
matDIR1 = dir('*.mat');
matDIR2 = {matDIR1.name};

for fi = 1:length(matDIR2)

    fni = matDIR2{fi};

    computeSpkPlot_metrics(fileLOC = flU,...
        fileName = fni)

end


