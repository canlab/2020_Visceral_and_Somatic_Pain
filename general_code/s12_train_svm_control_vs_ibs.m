clear all
s6_set_up_paths_patientcontrols

%%
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

indic = behdat.newindic(:, 4:5);
wh = any(indic, 2);

stim_vs_nostim_controlvIBS = stim_vs_nostim_all_subjects;
stim_vs_nostim_controlvIBS.dat = stim_vs_nostim_controlvIBS.dat(:, wh);
stim_vs_nostim_controlvIBS.removed_images = stim_vs_nostim_controlvIBS.removed_images(wh);
stim_vs_nostim_controlvIBS.Y = double(indic(:, 2) - indic(:, 1));
stim_vs_nostim_controlvIBS.Y = stim_vs_nostim_controlvIBS.Y(wh);
stim_vs_nostim_controlvIBS.Y_descrip = 'Patients (1) vs. Controls (-1)';

%% Define holdout set

% Define holdout sets: Leave out one subject per study/group 
nk = sum(indic);
holdout_sets = [(1:nk(1))'; (1:nk(2))'];

%% Predict - SVM

redo_predict = 0;
bootsamples = 2000;
savenamebase = 'SVM_stats_Control_v_IBS_2000bootstrap';

stats = visceral_train_SVM(stim_vs_nostim_controlvIBS, holdout_sets, redo_predict, bootsamples, resultsdir, savenamebase, o2);




