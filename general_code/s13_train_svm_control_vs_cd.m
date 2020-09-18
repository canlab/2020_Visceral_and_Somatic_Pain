clear all
s6_set_up_paths_patientcontrols

%% Load and handle missing/excluded data
% ------------------------------------------------------------------
load(fullfile(resultsdir, 'stim_vs_nostim_all_subjects.mat'));

stim_vs_nostim_all_subjects = remove_empty(stim_vs_nostim_all_subjects);

o2 = canlab_results_fmridisplay([], 'compact2', 'noverbose');

% Select subjects for this analysis
stim_vs_nostim_all_subjects.dat = stim_vs_nostim_all_subjects.dat(:, behdat.wh_subjects);
stim_vs_nostim_all_subjects.additional_info{1} = stim_vs_nostim_all_subjects.additional_info{1}(behdat.wh_subjects);

stim_vs_nostim_all_subjects.removed_images = ~behdat.wh_subjects;

%% Select IBS vs. Control Rectal 2 (Study 3)

indic = behdat.newindic(:, 2:3);
wh = any(indic, 2);

stim_vs_nostim_controlvCD = stim_vs_nostim_all_subjects;
stim_vs_nostim_controlvCD.dat = stim_vs_nostim_controlvCD.dat(:, wh);
stim_vs_nostim_controlvCD.removed_images = stim_vs_nostim_controlvCD.removed_images(wh);
stim_vs_nostim_controlvCD.Y = double(indic(:, 2) - indic(:, 1));
stim_vs_nostim_controlvCD.Y = stim_vs_nostim_controlvCD.Y(wh);
stim_vs_nostim_controlvCD.Y_descrip = 'Patients (1) vs. Controls (-1)';

%% Define holdout set

% Define holdout sets: Leave out one subject per study/group 
nk = sum(indic);
holdout_sets = [(1:nk(1))'; (1:nk(2))'];

%% Predict - SVM

redo_predict = 0;
bootsamples = 50;
savenamebase = 'SVM_stats_Control_v_CD_50bootstrap_notsig';

stats = visceral_train_SVM(stim_vs_nostim_controlvCD, holdout_sets, redo_predict, bootsamples, resultsdir, savenamebase, o2);




