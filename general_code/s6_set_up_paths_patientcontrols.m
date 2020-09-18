%clear all

masterdir = '/Users/tor/Dropbox/SHARED_DATASETS/V_Michiko_Lukas_Giao_VisceralPain';

% The names of the study folders and the "common" folder should be the same
% across computers to make things easier.
commondir = fullfile(masterdir, 'V_visceral_common');
commonscriptsdir = fullfile(commondir, 'scripts');
g = genpath(commonscriptsdir); addpath(g)

[basedir, resultsdir, figsavedir, scriptsdir, pubdir] = set_up_dirs('nps_visceral',masterdir);


%% Load master data and pull out subjects we want for this paper

[behdat] = import_data_extract_info;

disp(behdat.newnames)

wh_groups = 1:5; % all but vaginal (this includes patients)
%wh_groups = [1 2 4]; % all but vaginal (this includes Controls ONLY)

behdat.wh_subjects = logical(sum(behdat.newindic(:, wh_groups), 2));

%                   data: [1x1 struct]
%               textdata: [1x1 struct]
%                  names: {1x16 cell}
%              subjnames: {129x1 cell}
%                  study: [129x1 double]
%           patientgroup: {129x1 cell}
%         stim_intensity: [129x1 double]
%     vas_stim_vs_nostim: [129x1 double]
%               newcondf: [129x1 double]
%               newnames: {1x7 cell}
%               newindic: [129x7 logical]

behdat.study = behdat.study(behdat.wh_subjects);
behdat.patientgroup = behdat.patientgroup(behdat.wh_subjects);
behdat.stim_intensity = behdat.stim_intensity(behdat.wh_subjects);
behdat.stim_intensity_pressure = behdat.stim_intensity_pressure(behdat.wh_subjects);

behdat.vas_stim_vs_nostim = behdat.vas_stim_vs_nostim(behdat.wh_subjects);

behdat.newcondf = behdat.newcondf(behdat.wh_subjects);

behdat.newindic = behdat.newindic(behdat.wh_subjects, wh_groups);
behdat.newnames = behdat.newnames(wh_groups);


%% Set up contrast codes

% Set up contrast codes
%'Gastric-Control'    'Rectal-Control'    'Rectal-CD'    'Rectal-Control'  'Rectal-IBS'

studynames = behdat.newnames;

contrasts = [   1 -.25 -.25 -.25 -.25
                0  1    -1   0    0
                0  0     0   1    -1
                0  .5    .5  -.5  -.5];

connames = {'Gastric vs. Other' 'Rectal 1 Control vs. CD' 'Rectal 2 Control vs. IBS' 'Rectal 1 vs. 2'};

contrastcodes = behdat.newindic * contrasts';

 