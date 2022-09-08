




colors = defineClusterColors;

rawWaveforms = newSpikesNegative;
 
rawWaveforms = rawWaveforms .* scalingFactor*1e6; %convert to uV
allTimestamps = newSpikesTimestampsNegative;
clusters = useNegative;
clusters = flipud( clusters );

nrClusters=length(clusters);


allSpikes = rawWaveforms;

spikeLength=size(allSpikes,2);

spikeColor = 'r';


cluNr=nrClusters;
spikesToDraw = allSpikes( find(assignedClusterNegative==cluNr),:);
timestamps = allTimestamps( find(assignedClusterNegative==cluNr) );

[~,~,L_R]=computeLratio( allSpikes ,assigned,cluNr,2); 

ISI_fitWindows = [200 700]; %fit gamma function and plot of ISI from 0 to this value.

[f,Pxxn,tvect,Cxx,edges1,n1,yGam1,edges2,n2,yGam2,mGlobal,m1,m2,percentageBelow,CV]  =...
    getStatsForCluster(spikesToDraw, timestamps, ISI_fitWindows);

nrSpikes = size(spikesToDraw,1);
fEstimate= nrSpikes / ((timestamps(end)-timestamps(1))/1e6);

spikePDFestimate(spikesToDraw(:,1:spikeLength));

plot(1:spikeLength, spikesToDraw', spikeColor);

hold on
avColor='k';

% plot waveform
plot(1:spikeLength, mean(spikesToDraw),avColor, 'linewidth', 2);

% plot spiketrain
plot(f,Pxxn,'r','linewidth',2);  
xlim( [0 80] );
ylim( [0 max(Pxxn)*1.5+1] );  %+1 to prevent 0
xlabel('Hz');
ylabel('(spk/s)^2/Hz');

[isOk2]= checkPowerspectrum(Pxxn,f, 20.0, 100.0); 

%autocorrelation
plot(tvect,Cxx,'r','LineWidth',2);
title('Autocorrelation (<10ms)');
ylabel('(spk/s)^2/Hz');
xlabel('[ms]');
xlim([1 10]);

%autocorrelation
subplot(3,6,10)
plot(tvect,Cxx,'r','LineWidth',2);
title('Autocorrelation (>10ms)');
ylabel('(spk/s)^2/Hz');
xlabel('[ms]');
xlim([10 80]);



% ISI 1ms
bar(edges1,n1,'histc');
title(sprintf('ISI bin=1ms, mean=%.1f, below 3ms=%.2f%% [%.2f%%]',...
    m1,percentageBelow(1),percentageBelow(3)));

ylabel( ['CV=' num2str(CV,3)] );
hold on
plot(edges1, yGam1, 'r','linewidth',2);


% Waveform amplitude at alignment
hist(spikesToDraw(:,95),50)
title('Waveform amp at alignment')
xlabel('amp [uV]');
ylabel('nr of spikes');




%% plot of firing rate and spike amplitude across time
%only taking into accout time form first and last detected spike ?


l=(allTimestamps(end)-allTimestamps(1))/100;

for i=1:100
    % fire rate
  H(i)= length(find(timestamps>allTimestamps(1)+1+l*(i-1) ...
      & timestamps<allTimestamps(1)+l*(i)));
   % amp
  H1(i)= mean(spikesToDraw(find(timestamps>allTimestamps(1)+1+l*(i-1) ...
      & timestamps<allTimestamps(1)+l*(i)),95));
  
end

H=H/(l/1000000);


% for timestampInclude
if ~isempty( timestampInclude)
    
    timestampInclude2=(timestampInclude-allTimestamps(1))/1e6;
    
    for i=1:size(timestampInclude,1)
   
temp=round(timestampInclude2(i,1):timestampInclude2(i,2));

    %plot(temp,mean(H),'.g')
    
    area(temp,(max(H1)+1)*ones(length(temp),1),min(H1)-1,'FaceColor',[0.8 0.8 0.8],...
    'EdgeColor',[0.8 0.8 0.8]);
    hold on
    end
end

[ax h1 h2]=plotyy(linspace(allTimestamps(1),allTimestamps(end),100)/1000000-allTimestamps(1)/1e6,H1,...
    linspace(allTimestamps(1),allTimestamps(end),100)/1000000-allTimestamps(1)/1e6,H);
try
ylim([min(H1) max(H1)]);
catch
 ylim([min(H1)-1 max(H1)]);   
end

set(h1,'LineW',2,'LineStyle','--');
set(h2,'LineW',2);

set(get(ax(1),'Ylabel'),'String','spike amplitude (\muV)') ;
set(get(ax(2),'Ylabel'),'String','firing rate (Hz)') ;

xlabel('time (sec)');
title('spike rate & amplitude during analyzed period');



plotSortingResultRaw(rawWaveforms, [], assignedClusterNegative, [], clusters, [], [], colors )




[pc,score,latent,tsquare] = pca(rawWaveforms);

assigned=assignedClusterNegative;

plotInds=[];
allInds=[];
for i=1:length(clusters)
    cluNr=clusters(i);
    plotInds{i} = find( assigned == cluNr );
    allInds=[allInds plotInds{i}];
end
noiseInds=setdiff(1:length(assigned),allInds);

plot( score(noiseInds,1), score(noiseInds,2), '.', 'color', [0.5 0.5 0.5]);
hold on
for i=1:nrClusters
    plot( score(plotInds{i},1), score(plotInds{i},2), [colors{i} '.']);
end
hold off

%focus on the data,not the noise; check if first argument<second to avoid
%weird xlim/ylim errors if not ordered (negative numbers)
xlims=[ 0.9*min(score(allInds,1)) 1.1*max(score(allInds,1))];
if xlims(1)<xlims(2)
    xlim(xlims);
end
ylims=[ 0.9*min(score(allInds,2)) 1.1*max(score(allInds,2))];
if ylims(1)<ylims(2)
    ylim(ylims);
end





