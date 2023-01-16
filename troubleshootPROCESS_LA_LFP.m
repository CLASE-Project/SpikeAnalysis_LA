% stop line 137 - processLA_LFP
% [pxx_test,fs_test] = pspectrum(double(chanTriND),500);
subplot(1,3,1)
pspectrum(double(chanTriND),500,'FrequencyResolution',2)
subplot(1,3,2)
plot(Fxx,PxxP)
subplot(1,3,3)
plot(Fxx,uVp_t)
