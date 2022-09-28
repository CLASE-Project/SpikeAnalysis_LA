function [] = computeSpkPlot_metrics(inputARgs)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    arguments
        inputARgs.fileLOC
        inputARgs.fileName
    end
    % r = myFunction(Name1=3,Name2=7)


    cd(inputARgs.fileLOC);


    % all colors
    colors = [211, 169, 147 ;
        232, 186, 162 ;
        255, 205, 178;
        255, 180, 162;
        229, 152, 155;
        181, 131, 141
        109, 104, 117
        122, 118, 130
        134, 130, 141];

    % Compute stuff
    load(inputARgs.fileName, 'newSpikesNegative',...
        'assignedNegative','scalingFactor','newTimestampsNegative',...
        'useNegative')

    rawWaves = newSpikesNegative .* scalingFactor*1e6;
    rawClusts = assignedNegative;
    allTimestamps = newTimestampsNegative;
    useClusts = useNegative;
    numUclusts = length(useClusts); 

    spikeLength = size(rawWaves,2);

    allcluststr = struct;

    for cli = 1:numUclusts

        cluNr = useClusts(cli);
        spikesToDraw = rawWaves( rawClusts == cluNr,:);
        timestamps = allTimestamps( rawClusts == cluNr);

        [L_R,~,Isoldist]=computeLratio(rawWaves ,...
            rawClusts,cluNr,2);

        ISI_fitWindows = [200 700];

        [~,~,tvect,Cxx,edges1,n1,yGam1,...
            ~,~,~,~,~,~,percentageBelow,CV]  =...
            getStatsForCluster(spikesToDraw, timestamps, ISI_fitWindows);

        allcluststr.(['C',num2str(cli)]).ID = cluNr;
        allcluststr.(['C',num2str(cli)]).LR = L_R;
        allcluststr.(['C',num2str(cli)]).IsoDis = Isoldist;
        allcluststr.(['C',num2str(cli)]).spkColor = colors(cli,:);
        % Figure 1
        allcluststr.(['C',num2str(cli)]).F1.spikesToDraw = spikesToDraw;
        allcluststr.(['C',num2str(cli)]).F1.spikeLength = spikeLength;
        allcluststr.(['C',num2str(cli)]).F1.colorMAP =  [1 1 1;0.9677 0.9677 1;...
                 0.9354 0.9354 1; 0.9032 0.9032 1; 0.8709 0.8709 1;...
                 0.8387 0.8387 1; 0.8064 0.8064 1;...
                 0.7741 0.7741 1; 0.7419 0.7419 1; 0.7096 0.7096 1;...
                 0.6774 0.6774 1; 0.6451 0.6451 1; 0.6129 0.6129 1;...
                 0.5806 0.5806 1; 0.5483 0.5483 1; 0.5161 0.5161 1;...
                 0.4838 0.4838 1; 0.4516 0.4516 1; 0.4193 0.4193 1;...
                 0.3870 0.3870 1; 0.3548 0.3548 1; 0.3225 0.3225 1;...
                 0.2903 0.2903 1; 0.2580 0.2580 1; 0.2258 0.2258 1;...
                 0.1935 0.1935 1; 0.1612 0.1612 1; 0.1290 0.1290 1;...
                 0.0967 0.0967 1; 0.0645 0.0645 1; 0.0322 0.0322 1;...
                 0 0 1; 0 0.015625 1; 0 0.03125 1; 0 0.046875 1;...
                 0 0.0625 1; 0 0.078125 1; 0 0.09375 1; 0 0.109375 1;...
                 0 0.125 1; 0 0.140625 1; 0 0.15625 1; 0 0.171875 1;...
                 0 0.1875 1; 0 0.203125 1; 0 0.21875 1; 0 0.234375 1;...
                 0 0.25 1; 0 0.265625 1; 0 0.28125 1; 0 0.296875 1;...
                 0 0.3125 1;0 0.328125 1;0 0.34375 1;0 0.359375 1;...
                 0 0.375 1;0 0.390625 1;0 0.40625 1;0 0.421875 1;...
                 0 0.4375 1;0 0.453125 1;0 0.46875 1;0 0.484375 1;...
                 0 0.5 1;0 0.515625 1;0 0.53125 1;0 0.546875 1;0 0.5625 1;...
                 0 0.578125 1;0 0.59375 1;0 0.609375 1;0 0.625 1;...
                 0 0.640625 1;0 0.65625 1;0 0.671875 1;0 0.6875 1;...
                 0 0.703125 1;0 0.71875 1;0 0.734375 1;0 0.75 1;...
                 0 0.765625 1;0 0.78125 1;0 0.796875 1;0 0.8125 1;...
                 0 0.828125 1;0 0.84375 1;0 0.859375 1;0 0.875 1;...
                 0 0.890625 1;0 0.90625 1;0 0.921875 1;0 0.9375 1;...
                 0 0.953125 1;0 0.96875 1;0 0.984375 1;0 1 1;...
                 0.015625 1 0.984375;0.03125 1 0.96875;0.046875 1 0.953125;...
                 0.0625 1 0.9375;0.078125 1 0.921875;0.09375 1 0.90625;...
                 0.109375 1 0.890625;0.125 1 0.875;0.140625 1 0.859375;...
                 0.15625 1 0.84375;0.171875 1 0.828125;0.1875 1 0.8125;...
                 0.203125 1 0.796875;0.21875 1 0.78125;0.234375 1 0.765625;...
                 0.25 1 0.75;0.265625 1 0.734375;0.28125 1 0.71875;...
                 0.296875 1 0.703125;0.3125 1 0.6875;0.328125 1 0.671875;...
                 0.34375 1 0.65625;0.359375 1 0.640625;0.375 1 0.625;...
                 0.390625 1 0.609375;0.40625 1 0.59375;0.421875 1 0.578125;...
                 0.4375 1 0.5625;0.453125 1 0.546875;0.46875 1 0.53125;...
                 0.484375 1 0.515625;0.5 1 0.5;0.515625 1 0.484375;0.53125 1 0.46875;...
                 0.546875 1 0.453125;0.5625 1 0.4375;0.578125 1 0.421875;...
                 0.59375 1 0.40625;0.609375 1 0.390625;0.625 1 0.375;...
                 0.640625 1 0.359375;0.65625 1 0.34375;0.671875 1 0.328125;...
                 0.6875 1 0.3125;0.703125 1 0.296875;0.71875 1 0.28125;...
                 0.734375 1 0.265625;0.75 1 0.25;0.765625 1 0.234375;...
                 0.78125 1 0.21875;0.796875 1 0.203125;0.8125 1 0.1875;...
                 0.828125 1 0.171875;0.84375 1 0.15625;0.859375 1 0.140625;...
                 0.875 1 0.125;0.890625 1 0.109375;0.90625 1 0.09375;...
                 0.921875 1 0.078125;0.9375 1 0.0625;0.953125 1 0.046875;...
                 0.96875 1 0.03125;0.984375 1 0.015625;1 1 0;1 0.984375 0;...
                 1 0.96875 0;1 0.953125 0;1 0.9375 0;1 0.921875 0;1 0.90625 0;...
                 1 0.890625 0;1 0.875 0;1 0.859375 0;1 0.84375 0;1 0.828125 0;...
                 1 0.8125 0;1 0.796875 0;1 0.78125 0;1 0.765625 0;1 0.75 0;...
                 1 0.734375 0;1 0.71875 0;1 0.703125 0;1 0.6875 0;1 0.671875 0;...
                 1 0.65625 0;1 0.640625 0;1 0.625 0;1 0.609375 0;1 0.59375 0;...
                 1 0.578125 0;1 0.5625 0;1 0.546875 0;1 0.53125 0;1 0.515625 0;...
                 1 0.5 0;1 0.484375 0;1 0.46875 0;1 0.453125 0;1 0.4375 0;...
                 1 0.421875 0;1 0.40625 0;1 0.390625 0;1 0.375 0;1 0.359375 0;...
                 1 0.34375 0;1 0.328125 0;1 0.3125 0;1 0.296875 0;1 0.28125 0;...
                 1 0.265625 0;1 0.25 0;1 0.234375 0;1 0.21875 0;1 0.203125 0;...
                 1 0.1875 0;1 0.171875 0;1 0.15625 0;1 0.140625 0;1 0.125 0;...
                 1 0.109375 0;1 0.09375 0;1 0.078125 0;1 0.0625 0;1 0.046875 0;...
                 1 0.03125 0;1 0.015625 0;1 0 0;0.984375 0 0;0.96875 0 0;...
                 0.953125 0 0;0.9375 0 0;0.921875 0 0;0.90625 0 0;...
                 0.890625 0 0;0.875 0 0;0.859375 0 0;0.84375 0 0;...
                 0.828125 0 0;0.8125 0 0;0.796875 0 0;0.78125 0 0;...
                 0.765625 0 0;0.75 0 0;0.734375 0 0;0.71875 0 0;0.703125 0 0;...
                 0.6875 0 0;0.671875 0 0;0.65625 0 0;0.640625 0 0;0.625 0 0;...
                 0.609375 0 0;0.59375 0 0;0.578125 0 0;0.5625 0 0;...
                 0.546875 0 0;0.53125 0 0;0.515625 0 0;0.5 0 0];
        % Figure 2
        allcluststr.(['C',num2str(cli)]).F2.spikeLength = spikeLength;
        allcluststr.(['C',num2str(cli)]).F2.spikesToDraw = spikesToDraw;
        % Figure 3
        allcluststr.(['C',num2str(cli)]).F3.tvect = tvect;
        allcluststr.(['C',num2str(cli)]).F3.Cxx = Cxx;
        % Figure 4
        allcluststr.(['C',num2str(cli)]).F4.edges1 = edges1;
        allcluststr.(['C',num2str(cli)]).F4.n1 = n1;
        allcluststr.(['C',num2str(cli)]).F4.percbelow = percentageBelow;
        allcluststr.(['C',num2str(cli)]).F4.CV = CV;
        allcluststr.(['C',num2str(cli)]).F4.yGam1 = yGam1;

        % Figure 5
        xAxtimes = (allTimestamps(end)-allTimestamps(1))/100;

        firrateYax = zeros(1,100);
        ampYax = zeros(1,100);

        for tmpi = 1:100
            % fire rate
            firrateYax(tmpi)= length(find(timestamps>allTimestamps(1)+1+xAxtimes*(tmpi-1) ...
                & timestamps<allTimestamps(1)+xAxtimes*(tmpi)));
            % amp
            ampYax(tmpi)= mean(spikesToDraw(timestamps>allTimestamps(1)+1+xAxtimes*(tmpi-1) ...
                & timestamps<allTimestamps(1)+xAxtimes*(tmpi),95));
        end

        firrateYax = firrateYax/(xAxtimes/1000000);

        allcluststr.(['C',num2str(cli)]).F5.allTimestamps = allTimestamps;
        allcluststr.(['C',num2str(cli)]).F5.firrateYax = firrateYax;
        allcluststr.(['C',num2str(cli)]).F5.ampYax = ampYax;


    end

    save(inputARgs.fileName,"allcluststr",'-append')

    


end