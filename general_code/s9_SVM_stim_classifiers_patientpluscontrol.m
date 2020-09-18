
%% Load and handle missing data
% ------------------------------------------------------------------
load(fullfile(resultsdir, 'stim_plus_nostim_all_subjects.mat'));

stim_plus_nostim_all_subjects = remove_empty(stim_plus_nostim_all_subjects);

% Load study IDs and outcome data

study = stim_plus_nostim_all_subjects.additional_info{1};
indic = logical(condf2indic(study));
indic(stim_plus_nostim_all_subjects.removed_images, :) = [];
studynames = {'Gastric' 'Rectal-Grenoble' 'Rectal-Sendai' 'Vaginal'};

stim_plus_nostim_all_subjects.Y(stim_plus_nostim_all_subjects.removed_images, :) = [];

% Create display
if ~exist('o2', 'var') || ~isa(o2, 'fmridisplay')
    o2 = canlab_results_fmridisplay([], 'compact2', 'noverbose');
end

% Select studies: Only 1-3
% ------------------------------------------------------------
studynames = behdat.newnames;

whomit = indic(:, 4);

stim_plus_nostim_all_subjects.dat(:, whomit) = [];
stim_plus_nostim_all_subjects.removed_images(whomit) = [];
stim_plus_nostim_all_subjects.Y(whomit) = [];

% Add behavioral data: Patient vs. control
% ------------------------------------------------------------
k = size(behdat.newindic, 2);  % Group, patient/control within study

clear subjectnum stimnostim nk % numbers of participants in each group

for i = 1:k
    tmp = [behdat.newindic(:, i) behdat.newindic(:, i)]';
    
    stim_plus_nostim_all_subjects.additional_info{3}(:, i) = tmp(:);
    
    nk(i) = sum(behdat.newindic(:, i));  % num subjects in this group
    subjectnum{i} = [(1:nk(i))'; (1:nk(i))'];
    stimnostim{i} = [ones(nk(i), 1); -ones(nk(i), 1)];
    
end

% Indicator for which group
indic = stim_plus_nostim_all_subjects.additional_info{3};

subjectnum = cat(1, subjectnum{:});
stimnostim = cat(1, stimnostim{:});

stim_plus_nostim_all_subjects.additional_info{4} = behdat.newnames;

% These are the critical variables:
%
print_matrix([subjectnum stim_plus_nostim_all_subjects.Y stimnostim indic], ...
    [{'Subj' 'Y' 'stimnostim'} behdat.newnames] , cellstr(stim_plus_nostim_all_subjects.fullpath));

% Check: These should match...
%[stim_plus_nostim_all_subjects.Y stimnostim]
% They do not...which is correct????  ****
% cverr is greater with stimnostim as output, but the others do not seem to
% match the studies in order.

%% SVM classifier: All data

% Define holdout sets: Leave out one subject per study/group 
nk = sum(indic) ./ 2;
holdoutindic = double(indic);
k = size(indic, 2);
for i = 1:k
    
    wh = find(indic(:, i));
    
    newsetnum = [(1:nk(i))'; (1:nk(i))'];
    
    holdoutindic(wh, i) = newsetnum;
    
end

holdout_sets = sum(holdoutindic, 2);

redo_predict = 0;

if redo_predict
    
    tic
    %[cverr, stats, optout] = predict(stim_plus_nostim_all_subjects, 'algorithm_name', 'cv_svm', 'nfolds', holdout_sets, 'bootweights', 'bootsamples', 50);
    [cverr, stats, optout] = predict(stim_plus_nostim_all_subjects, 'algorithm_name', 'cv_svm', 'nfolds', holdout_sets, 'bootweights', 'bootsamples', 2000);
    toc
    
    % remove to save space
    stats.function_handle = [];
    stats.function_call = [];
    stats.other_output_cv = [];
    stats = rmfield(stats, 'WTS');
    save(fullfile(resultsdir, 'SVM_stats_weightmap_2000bootstrap.mat'), 'stats');
    
else
    load(fullfile(resultsdir, 'SVM_stats_weightmap_2000bootstrap.mat'), 'stats');
end

% w = statistic_image('dat', stats.weight_obj.dat, ...
%     'volInfo', stats.weight_obj.volInfo, ...
%     'p', stats.WTS.wP', ...
%     'ste', stats.WTS.wste', ...
%     'dat_descrip', stats.function_call, ...
%     'removed_voxels', stats.weight_obj.removed_voxels);
%
% stats.w = w;

w = stats.weight_obj;

o2 = removeblobs(o2);
o2 = addblobs(o2, region(w), 'trans', 'splitcolor', {[0 0 1] [0 1 1] [1 .5 0] [1 1 0]});

axes(o2.montage{2}.axis_handles(1))
savename = 'SVM_stim_vs_nostim_montage_nothreshold';
saveas(gcf, fullfile(figsavedir, [savename '.png']));

w = threshold(w, .05, 'unc');

o2 = removeblobs(o2);
o2 = addblobs(o2, region(w), 'trans', 'splitcolor', {[0 0 1] [0 1 1] [1 .5 0] [1 1 0]});
o2 = addblobs(o2, region(w), 'color', 'k', 'outline');

axes(o2.montage{2}.axis_handles(1))
savename = 'SVM_stim_vs_nostim_montage_unc05';
saveas(gcf, fullfile(figsavedir, [savename '.png']));



w = threshold(w, .05, 'fdr');

o2 = removeblobs(o2);
o2 = addblobs(o2, region(w), 'trans', 'splitcolor', {[0 0 1] [0 1 1] [1 .5 0] [1 1 0]});
o2 = addblobs(o2, region(w), 'color', 'k', 'outline');

axes(o2.montage{2}.axis_handles(1))
savename = 'SVM_stim_vs_nostim_montage_fdr05';
saveas(gcf, fullfile(figsavedir, [savename '.png']));


create_figure('surface'); 
surface(region(w), 'foursurfaces', 'color_upperboundpercentile', 85, 'color_lowerboundpercentile', 15);

savename = 'SVM_stim_vs_nostim_surface_fdr05';
saveas(gcf, fullfile(figsavedir, [savename '.png']));

%% ROC plot for combined cross-study SVM: Results overall and by study

create_figure('ROC', 1, 2);

ROC = roc_plot(stats.dist_from_hyperplane_xval, stats.Y > 0); %, 'color', 'r', 'twochoice');
title('SVM Stim vs. No-stim, single-interval', 'FontSize', 18);

clear svm_dist_by_study y_by_study all_lineh
for i = 1:k
    
    svm_dist_by_study{i} = stats.dist_from_hyperplane_xval(indic(:, i));
    y_by_study{i} = stats.Y(indic(:, i)) > 0;
    
end

subplot(1, 2, 2);
mycolors = {[.2 .7 .2] [.8 0 .8] [.6 0 .4] [.2 .2 1] [.2 .5 .7]};

% This will only work if the images in each set have equal numbers of stim
% and no-stim outcomes, with a block of stim followed by a block of no-stim
% and subjects in the same order in each block.  This format is required by
% the 'twochoice' option.

clear accuracy nsubj

for i = 1:k
    
    ROC = roc_plot(svm_dist_by_study{i}, y_by_study{i}, 'color', mycolors{i}, 'twochoice');
    
    all_lineh(i) = ROC.line_handle(2);
    
    % accuracy
    accuracy(i) = ROC.accuracy;
    nsubj(i) = length(y_by_study{i}) ./ 2;
    
    % distances, for correlations
    d = reshape(svm_dist_by_study{i}, nsubj(i), 2);
    d = d(:, 1) - d(:, 2);
    svmdist_by_study{i} = d;
    
end

title('SVM Stim vs. No-stim, forced choice', 'FontSize', 18);
legend(all_lineh, studynames, 'Location', 'Best');

savename = 'SVM_stim_vs_nostim_ROC';
saveas(gcf, fullfile(figsavedir, [savename '.png']));

drawnow;snapnow;
%% SVM accuracy

total_acc = sum(accuracy .* nsubj) ./ sum(nsubj);  % per subject

fprintf('Forced-choice accuracy: Balanced: %3.0f%%, Total: %3.0f%%\n', 100*mean(accuracy), 100*total_acc);

%% Correlate relative SVM distance from hyperplane with pain

all_svm_dist = cat(1, svmdist_by_study{:});

description = 'SVM distance correlations with indiv diffs in pain report';
x = all_svm_dist;
y = behdat.vas_stim_vs_nostim; % vas
covariates = contrastcodes;
covnames = connames;
study_indicator = behdat.newindic;
markername = 'SVMdist';
savename = 'SVMdist_VAS_correlation';

brain_marker_behavior_correlation_controlling_study(x, y, covariates, covnames, description, study_indicator, studynames, markername);
drawnow;snapnow;


%% SVMdist diffs by patient group
% =========================================================================

%% Get normalized NPS values

% groups 2, 3:  Controls, CD patients (Grenoble)
% groups 4, 5:  Controls, IBS patients (Sendai)

vol = behdat.stim_intensity;  % mL

k = size(behdat.newindic, 2);

for i = 1:k    
    vol_by_study{i} = vol(behdat.newindic(:, i));
    
    svmdist_per_mL{i} = svmdist_by_study{i} ./ vol_by_study{i};

    % only exists for 4:5, Sendai data
    pressure_by_study{i} = behdat.stim_intensity_pressure(behdat.newindic(:, i));

    svmdist_per_mmHg{i} = svmdist_by_study{i} ./ pressure_by_study{i};

end

%%
y = all_svm_dist;
indic = behdat.newindic(:, 2:3);
covs = [vol behdat.vas_stim_vs_nostim];
covnames = {'Volume' 'Pain ratings'};
ydescrip = 'SVMdist with CSF denoising';
plotcolors = mycolors(2:3);
plotstudynames = studynames(2:3);

visceral_compare_groups(y, indic, covs, ydescrip, plotstudynames, plotcolors, covnames);
%%
y = all_svm_dist;
indic = behdat.newindic(:, 4:5);
covs = [vol behdat.vas_stim_vs_nostim];
covnames = {'Volume' 'Pain ratings'};
ydescrip = 'SVMdist with CSF denoising';
plotcolors = mycolors(4:5);
plotstudynames = studynames(4:5);

visceral_compare_groups(y, indic, covs, ydescrip, plotstudynames, plotcolors, covnames);

%% SVMdist by patient group, normalized by stimulus volume

%%
y = cat(1, svmdist_per_mL{:});
indic = behdat.newindic(:, 2:3);
covs = behdat.vas_stim_vs_nostim;
covnames = {'Pain ratings'};
ydescrip = 'SVMdist per mL with CSF denoising';
plotcolors = mycolors(2:3);
plotstudynames = studynames(2:3);

visceral_compare_groups(y, indic, covs, ydescrip, plotstudynames, plotcolors, covnames);
%%
y = cat(1, svmdist_per_mL{:});
indic = behdat.newindic(:, 4:5);
covs = behdat.vas_stim_vs_nostim;
covnames = {'Pain ratings'};
ydescrip = 'SVMdist per mL with CSF denoising';
plotcolors = mycolors(4:5);
plotstudynames = studynames(4:5);

visceral_compare_groups(y, indic, covs, ydescrip, plotstudynames, plotcolors, covnames);

%%
y = cat(1, svmdist_per_mmHg{:});
indic = behdat.newindic(:, 4:5);
covs = [];
ydescrip = 'SVMdist per mm Hg pressure with CSF denoising';
plotcolors = mycolors(4:5);
plotstudynames = studynames(4:5);

visceral_compare_groups(y, indic, covs, ydescrip, plotstudynames, plotcolors);
