

flU = 'Z:\LossAversion\Patient folders\CLASE001\NWB-data\Spiking_Data\sort\5';

matDIR1 = dir('*.mat');
matDIR2 = {matDIR1.name};

for fi = 1:length(matDIR2)

    fni = matDIR2{fi};

    computeSpkPlot_metrics(fileLOC = flU,...
        fileName = fni)

end

