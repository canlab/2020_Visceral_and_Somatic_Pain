%clear all

masterdir = '/Users/tor/Dropbox/SHARED_DATASETS/V_Michiko_Lukas_Giao_VisceralPain';

% The names of the study folders and the "common" folder should be the same
% across computers to make things easier.
commondir = fullfile(masterdir, 'V_visceral_common');
commonscriptsdir = fullfile(commondir, 'scripts');
g = genpath(commonscriptsdir); addpath(g)

[basedir, resultsdir, figsavedir, scriptsdir, pubdir] = set_up_dirs('nps_visceral',masterdir);

dosurfaces = 1;

%% Load master data and pull out subjects we want for this paper

[behdat] = import_data_extract_info;

disp(behdat.newnames)

%wh_groups = 1:5; % all but vaginal (this includes patients)
wh_groups = [1 2 4]; % all but vaginal (this includes Controls ONLY)
% wh_groups = [1 2 4 6]; % all but vaginal (this includes Controls ONLY)

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
behdat.vas_stim_vs_nostim = behdat.vas_stim_vs_nostim(behdat.wh_subjects);

behdat.newcondf = behdat.newcondf(behdat.wh_subjects);

behdat.fullindic = behdat.newindic;
behdat.newindic = behdat.newindic(behdat.wh_subjects, wh_groups);
behdat.newnames = behdat.newnames(wh_groups);

% Contrasts

contrasts = [   1 -.5 -.5 
                 0  1 -1];

connames = {'Gastric vs. Rectal Controls' 'Rectal 1 vs. Rectal 2 Controls' 'All_Controls_adjusted_for_study'};

contrastcodes = behdat.newindic * contrasts';

%% Full list of data to match with stim_plus_nostim data
% ------------------------------------------------------------
k = size(behdat.fullindic, 2);  % Group, control within study

clear subjectnum stimnostim nk indic % numbers of participants in each group

for i = 1:k
    wh = behdat.fullindic(:, i);
    
    tmp = [wh wh]';
        
    nk(i) = sum(wh);  % num subjects in this group
    subjectnum{i} = [(1:nk(i))'; (1:nk(i))'];
    stimnostim{i} = [ones(nk(i), 1); -ones(nk(i), 1)];
    
    % build full stim + nostim indicator matrix.
    % concatenate.
    
    indic{i} =  [behdat.fullindic(wh, :); behdat.fullindic(wh, :)];
    
end

subjectnum = cat(1, subjectnum{:});
stimnostim = cat(1, stimnostim{:});
indic = cat(1, indic{:});

% These are the critical variables:
%
print_matrix([subjectnum stimnostim indic], ...
    [{'Subj' 'stimnostim'} behdat.newnames]);

% Check: These should match...
%[stim_plus_nostim_all_subjects.Y stimnostim]
% They do not...which is correct????  ****
% cverr is greater with stimnostim as output, but the others do not seem to
% match the studies in order.

%% Select  groups
wh_cases_stimplusnostim = any(indic(:, wh_groups), 2);

reduced_indic = indic(wh_cases_stimplusnostim, wh_groups);


