%displays the raw waveforms of all spikes that were assigned to a valid
%cell.
%
%urut/april04
function plotSortingResultRaw_LA(spikesPos, spikesNeg, assignedPos, assignedNeg, toUsePos, toUseNeg, label, colors )
nrDataPoints=size(spikesPos,2);

%raw , sorted
for k=1:2
    allSpikes=[];
    assigned=[];
    toUse=[];
    if k==1
        allSpikes=spikesPos;
        assigned=assignedPos;
        toUse=toUsePos;
    else
        allSpikes=spikesNeg;
        assigned=assignedNeg;
        toUse=toUseNeg;
    end

    if size(allSpikes,1)==0
        continue;
    end

    figure;
    hold on
    for i=1:length(toUse)
        cluNr = toUse(i);
        spikesToDraw = allSpikes( find(assigned==cluNr),:);

        color=colors(i,:);
        if size(spikesToDraw,1)>500
            %dont plot every spike,to save space
    		plot(1:nrDataPoints, spikesToDraw(1:10:end,:)', color);
    	else
            plot(1:nrDataPoints, spikesToDraw', 'Color',color/255);
    	end

    end
    hold off
    xlim( [1 nrDataPoints] );
    if k==1
        title([ label ' raw positive spikes']);
    else
        title([ label ' raw negative spikes']);
    end

    figure;
    hold on
    for i=1:length(toUse)
        cluNr = toUse(i);
        m = mean ( allSpikes( find(assigned==cluNr),:));

        color=colors(i,:);
        plot(1:nrDataPoints, m, 'Color',color/255,'linewidth',2);
    end
    hold off
    xlim( [1 nrDataPoints] );

    title([ label ' average waveforms of all clusters ']);




end

