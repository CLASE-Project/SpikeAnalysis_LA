newfile = nwbRead("MW3_Session_12_filter.nwb");

NmacroData = newfile.processing.get('ecephys').nwbdatainterface.get('LFP')...
        .electricalseries.get('MacroWireSeries').data.load();

%%

oldfile = nwbRead("MW3_Session_12_filter.nwb");

OmacroData = oldfile.processing.get('ecephys').nwbdatainterface.get('LFP')...
        .electricalseries.get('MacroWireSeries').data.load();

%%

danfile = nwbRead("MW3_Session_12_filter.nwb");

DmacroData = danfile.processing.get('ecephys').nwbdatainterface.get('LFP')...
        .electricalseries.get('MacroWireSeries').data.load();


events = danfile.acquisition.get('events').data.load()


%%

filfile = nwbRead("MW3_Session_11_filter.nwb");

FmacroData = filfile.processing.get('ecephys').nwbdatainterface.get('LFP')...
        .electricalseries.get('MacroWireSeries').data.load();

%%

rawfile = nwbRead("MW3_Session_11_raw.nwb");

RmacroData = rawfile.acquisition.get('MacroWireSeries').data.load();

%%

cmaPP = [0 0.4470 0.7410;
    0.8500 0.3250 0.0980;
    0.9290 0.6940 0.1250];
trowF = FmacroData(5,1:15000);
trowR = RmacroData(5,1:15000);
% trowD = DmacroData(5,1:10000);

plot(trowF,'Color',cmaPP(1,:))
hold on
plot(trowR,'Color',cmaPP(2,:))
% plot(trowD,'Color',cmaPP(3,:))