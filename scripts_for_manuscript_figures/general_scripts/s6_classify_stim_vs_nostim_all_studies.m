% predict stim vs nostim from combined datasets (using averages across
% runs)
behdat=importdata(which('Visceral_pain_master_sheet.xlsx'));

behdat.names = behdat.textdata.Data(1, 2:end);
behdat.subjnames = behdat.textdata.Data(2:end, 6);
behdat.patientgroup = behdat.textdata.Data(2:end, 4);

%wh = find(stim_plus_nostim_all_subjects.removed_images); % bad images

