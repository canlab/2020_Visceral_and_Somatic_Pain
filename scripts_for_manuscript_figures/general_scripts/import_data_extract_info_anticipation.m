function [behdat] = import_data_extract_info_anticipation(masterdir)
% [behdat] = import_data_extract_info
% behdat = all data loaded from prep_1b code
% added fields with key info we will use in analysis

% behdat=importdata(which('Visceral_pain_master_sheet.xlsx'));
% behdat=importdata(which('Visceral_pain_master_sheet_updated.xlsx'));

%load anticipation data from each study
behav_files=dir([masterdir '\**\behav_data.mat']);
studynames = {'Gastric-Control' 'Rectal-Control' 'Rectal-Control' 'Vag-Control' };

subjnames=[];
study=[];
patientgroup={};
vas_anx=[];
vas_pain=[];
behdat.exclude=[];
for i=1:length(behav_files)
   load([behav_files(i).folder filesep behav_files(i).name])
   if i==4
       for i=1:length(Group); Group{i}=Group{i}{1}; end
       behdat.exclude=[behdat.exclude; strcmp(Group,'vulvodynia')];
       exclude=strcmp(Group,'vulvodynia');
   else
       behdat.exclude=[behdat.exclude; false(size(mean_VAS_pain_percond,1),1)];
    exclude= false(size(mean_VAS_pain_percond,1),1);
   end
   
      mean_VAS_pain_percond=mean_VAS_pain_percond(~exclude,:);
      mean_VAS_anx_percond=mean_VAS_anx_percond(~exclude,:);
      
      nsub=size(mean_VAS_pain_percond,1);
      study=[study; i*ones(nsub,1)];
      patientgroup=[patientgroup; repmat({'control'},nsub,1)];
      vas_anx=[vas_anx; mean_VAS_anx_percond];
      vas_pain=[vas_pain; mean_VAS_pain_percond];
      subjnames=[subjnames; (1:nsub)'];
      
end


behdat.names = studynames;
behdat.subjnames = subjnames;
behdat.study = study;
behdat.patientgroup = patientgroup;
% behdat.stim_intensity = behdat.data.Data(:, 8);

% behdat.stim_intensity_pressure = behdat.data.Data(:, 20);

behdat.vas_anx = vas_anx;
behdat.vas_pain = vas_pain;

newindic = condf2indic(study);
newindic = logical(newindic);

% Get other outputs
behdat.newcondf = study;
behdat.newnames = studynames;
behdat.newindic = newindic;

end
