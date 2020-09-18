function [behdat] = import_data_extract_info
% [behdat] = import_data_extract_info
% behdat = all data loaded from excel
% added fields with key info we will use in analysis

% behdat=importdata(which('Visceral_pain_master_sheet.xlsx'));

behdat=importdata(which('Visceral_pain_master_sheet_updated.xlsx'));%_updated - for visceral pain paper
% behdat=importdata(which('Visceral_pain_master_sheet_updatedv2.xls'));

behdat.names =behdat.textdata.Data(1, 2:end);
% behdat.names =behdat.textdata.Data.Data(1, 2:end);

behdat.subjnames =behdat.textdata.Data(2:end, 4);
behdat.study =  behdat.data.Data(:, 1);%behdat.textdata.Data(2:end, 1);
behdat.patientgroup =behdat.textdata.Data(2:end, 4);

behdat.stim_intensity = behdat.data.Data(:, 8);

behdat.stim_intensity_pressure = behdat.data.Data(:, 20);

behdat.vas_stim_vs_nostim = behdat.data.Data(:, 9) - behdat.data.Data(:, 10);

patientgroup = behdat.patientgroup;
% patientgroup(wh_remove) = [];
% 
study = behdat.study;
% %study(wh_remove, :) = [];

% [patientindic, patientnames] = condf2indic(behdat.patientgroup);
% patientindic = logical(patientindic);

% Build new condition function
newcondf = zeros(size(patientgroup));
newcondf(study == 1 & strcmp(patientgroup, 'Control')) = 1;

newcondf(study == 2 & strcmp(patientgroup, 'Control')) = 2;
newcondf(study == 2 & strcmp(patientgroup, 'CD')) = 3;

newcondf(study == 3 & strcmp(patientgroup, 'Control')) = 4;
newcondf(study == 3 & strcmp(patientgroup, 'IBS')) = 5;

newcondf(study == 4 & strcmp(patientgroup, 'Control')) = 6;
newcondf(study == 4 & strcmp(patientgroup, 'PVD')) = 7;

newcondf(study == 5 & strcmp(patientgroup, 'Control')) = 8;

newcondf(study == 7 & strcmp(patientgroup, 'Control')) = 10;

newcondf(study == 8 & strcmp(patientgroup, 'Control')) = 9;


newnames = {'Gastric-Control' 'Rectal-Control' 'Rectal-CD' 'Rectal-Control' 'Rectal-IBS' 'Vag-Control' 'Vag-PVD' 'Esoph-Control' 'Thermal-Control' 'Thermal-Control'};

newindic = condf2indic(newcondf);
newindic = logical(newindic);

% Get other outputs
behdat.newcondf = newcondf;
behdat.newnames = newnames;
behdat.newindic = newindic;

end
