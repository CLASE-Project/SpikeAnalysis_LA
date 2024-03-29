function [] = troubleshootPSD(rawTS, pwel , uVpP , fXXall)


subplot(3,3,1)
[PxxPt , FxxPS] = pspectrum(double(rawTS),500,'FrequencyResolution',2);
PxxPS = pow2db(PxxPt);
plot(FxxPS, PxxPS)
title('Pspectrum - 2Hz resolution')
subplot(3,3,2)
xlim([0 250])
plot(fXXall,pwel)
title('PWelch')
xlim([0 250])
subplot(3,3,3)
plot(fXXall,uVpP)
title('uPv')
xlim([0 250])

subplot(3,3,4:6)
% figure;
% pspectrum(double(rawTS),500,'spectrogram',TimeResolution = 0.1,...
%     Leakage = 0.85);
Fs = 500;
% figure;
[S,F,T] = pspectrum(double(rawTS),500,'spectrogram',TimeResolution = 0.1,...
    Leakage = 0.85);
surface(T, F, pow2db(S), 'EdgeColor', 'none');
colormap("parula")
xlim([0.05 5])
colorbar
ylim([0 250])



subplot(3,3,7:9)
[cfs,frq] = cwt(double(rawTS),Fs);
tms = (0:numel(double(rawTS))-1)/Fs;
% figure;
surface(tms,frq,abs(cfs))
axis tight
shading flat
xlabel("Time (s)")
ylabel("Frequency (Hz)")
colorbar





set(gcf, 'Position', [1156 773 1034 420]);

end