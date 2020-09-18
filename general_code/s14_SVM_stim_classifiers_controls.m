s0_set_up_paths_controls


% Create display
if ~exist('o2', 'var') || ~isa(o2, 'fmridisplay')
    o2 = canlab_results_fmridisplay([], 'compact2', 'noverbose');
else
    o2 = removeblobs(o2);
end


%% Load and handle missing data
% ------------------------------------------------------------------
% wh_cases_stimplusnostim is defined in s0 script.
% it is an index into the full list of subjects.

load(fullfile(resultsdir, 'stim_plus_nostim_all_subjects.mat'));

stim_plus_nostim_all_subjects.dat(:, ~wh_cases_stimplusnostim) = [];
stim_plus_nostim_all_subjects.Y(~wh_cases_stimplusnostim, :) = [];

%    stim_plus_nostim_all_subjects.removed_images(:, ~wh_cases_stimplusnostim) = [];


%% SVM classifier: All data

% Define holdout sets: Leave out one subject per study/group 
% reduced_indic is defined in s0

nk = sum(reduced_indic) ./ 2;
holdoutindic = double(reduced_indic);
k = size(reduced_indic, 2);
for i = 1:k
    
    wh = find(reduced_indic(:, i));
    
    newsetnum = [(1:nk(i))'; (1:nk(i))'];
    
    holdoutindic(wh, i) = newsetnum;
    
end

holdout_sets = sum(holdoutindic, 2);

%% Predict - SVM

redo_predict = 0;
bootsamples = 2000;
savenamebase = 'SVM_stats_Control_stim_v_nostim_2000bootstrap';

[stats, within_subject_svm_dist] = visceral_train_SVM(stim_plus_nostim_all_subjects, holdout_sets, redo_predict, bootsamples, resultsdir, savenamebase, o2, reduced_indic);


%% Correlate relative SVM distance from hyperplane with pain

description = 'SVM distance correlations with indiv diffs in pain report';
x = within_subject_svm_dist;
y = behdat.vas_stim_vs_nostim; % vas
covariates = contrastcodes;
covnames = connames;
study_indicator = behdat.newindic; % in s0: newindic is reduced for sub-sample, fullindic is all.
markername = 'SVMdist';
savename = 'SVMdist_VAS_correlation';

brain_marker_behavior_correlation_controlling_study(x, y, covariates, covnames, description, study_indicator, studynames, markername);
drawnow;snapnow;

saveas(gcf, fullfile(figsavedir, ['SVM_controls_corr_with_pain.png']));
title(' '); legend off; axis auto, axis tight; set(gca, 'FontSize', 28);
saveas(gcf, fullfile(figsavedir, ['SVM_controls_corr_with_pain_clean.png']));

