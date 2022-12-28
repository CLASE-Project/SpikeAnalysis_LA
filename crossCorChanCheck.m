



dirLet = 'D';

basepaths = {[dirLet,':\LossAversion\Patient folders\CLASE001\NWB-data\NWB_Data\'],...
    [dirLet,':\LossAversion\Patient folders\CLASE006\NWB-data\NWB_Data\'],...
    [dirLet,':\LossAversion\Patient folders\CLASE007\NWB-data\NWB_Data\'],...
    [dirLet,':\LossAversion\Patient folders\CLASE009\NWB-data\NWB_Data\']};
patientID = {'CLASE001','CLASE006','CLASE007','CLASE009'};
nwbFname = {'MW9_Session_6_filter.nwb','MW12_Session_3_filter.nwb',...
    'MW13_Session_5_filter.nwb','CLASE09_Session_5_filter.nwb'};


allRho = cell(1,length(basepaths));
allpvals = cell(1,length(basepaths));
allTabs = cell(1,length(basepaths));
for pii = 1:length(basepaths)

    cd(basepaths{pii})
    nwbFilEE = nwbRead(nwbFname{pii});

    microDATA = nwbFilEE.processing.get('ecephys').nwbdatainterface.get('LFP')...
        .electricalseries.get('MicroWireSeries').data.load();

    % Conduct correlation
    % get 5 seconds
    rhoS = nan(8,8);
    pvAls = nan(8,8);
    fiveSecs = 26000:27500;
    for r1 = 1:8
        testChan = double(transpose(microDATA(r1,fiveSecs)));
        for c1 = 1:8
            comparChan = double(transpose(microDATA(c1,fiveSecs)));

            [r,p] = corr(testChan,comparChan);
            rhoS(r1,c1) = round(r,2);
            pvAls(r1,c1) = p;

        end
    end

    disp(['Case ', num2str(pii), 'done'])

    rhoS2 = abs(rhoS);
    rhoS2(rhoS2 < 0.5) = 0;

    mat1 = transpose(microDATA(:,26000:27500));
    tab1 = array2table(mat1);
%     stackedplot(tab1)

    allRho{pii} = rhoS2;
    allpvals{pii} = pvAls;
    allTabs{pii} = tab1;


end

