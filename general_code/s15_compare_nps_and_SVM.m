% Load SVM map and responses
% 
% stats.weight_map is map
% stats.within_subject_svm_dist is responses

savenamebase = 'SVM_stats_Control_stim_v_nostim_50bootstrap';
statssavefilename = fullfile(resultsdir, [savenamebase '.mat']);
load(statssavefilename, 'stats');

svmdist = stats.within_subject_svm_dist;  % special added in visceral_train_SVM
svmw = stats.weight_obj;

% Load NPS

npsmap = fmri_data(which('weights_NSF_grouppred_cvpcr.img'));

clear all_nps
load(fullfile(resultsdir, 'NPS_by_study.mat'), 'all_nps', 'all_nps_resid', 'gwcsf', 'gwcsfcomponents');

%% Get contrast images for each group 
% ==================================================================

%% Load contrast data and handle missing/excluded data
% ------------------------------------------------------------------
load(fullfile(resultsdir, 'stim_vs_nostim_all_subjects.mat'));

stim_vs_nostim_all_subjects = remove_empty(stim_vs_nostim_all_subjects);

% Select subjects for this analysis
stim_vs_nostim_all_subjects.dat = stim_vs_nostim_all_subjects.dat(:, behdat.wh_subjects);

stim_vs_nostim_all_subjects.removed_images = ~behdat.wh_subjects;

%% Put in same space

npsmap = resample_space(npsmap, stim_vs_nostim_all_subjects); 
svmw = resample_space(svmw, stim_vs_nostim_all_subjects); 

svmw = replace_empty(svmw);

%% Separate by group

groupindic = behdat.newindic; % (behdat.wh_subjects, :);

k = size(groupindic, 2);

clear stim_vs_nostim_by_group meancontrast mtx

for i = 1:k
    
    stim_vs_nostim_by_group{i} = stim_vs_nostim_all_subjects;
    
    wh = logical(groupindic(:, i));
    
    stim_vs_nostim_by_group{i}.dat = stim_vs_nostim_by_group{i}.dat(:, wh);
    stim_vs_nostim_by_group{i}.removed_images = zeros(sum(wh), 1);
    
    meancontrast{i} = replace_empty(mean(stim_vs_nostim_by_group{i}));
   
    mtx(:, i) = meancontrast{i}.dat;
end

%% Double-check: Same
% for i = 1:3
%     create_figure('sim plot');
%     stats = image_similarity_plot(stim_vs_nostim_by_group{i}, 'average');
%     drawnow, snapnow
% end

%% Similarity matrix: NPS SVM mean con for each of 3 studies

mtx = [npsmap.dat svmw.dat mtx];

%% Predict individual differences in pain report

stim_vs_nostim_all_subjects.Y = behdat.vas_stim_vs_nostim;
stim_vs_nostim_all_subjects.Y_descrip = 'Individual diffs in pain';

% Define holdout set

% Define holdout sets: Leave out one subject per study/group 
nk = sum(groupindic);
holdout_sets = [(1:nk(1))'; (1:nk(2))'; (1:nk(3))'];

[cverr, stats] = predict(stim_vs_nostim_all_subjects, 'cv_lassopcr', 'nfolds', holdout_sets);

fprintf('Prediction-outcome correlation: r = %3.2f\n', stats.pred_outcome_r);

% Prediction-outcome correlation: r = 0.03

%% Remove extreme cases with low pain and re-do prediction

whout = stim_vs_nostim_all_subjects.Y < 2; sum(whout)

stim_vs_nostim_cleaned = stim_vs_nostim_all_subjects;

stim_vs_nostim_cleaned.Y(whout) = [];
stim_vs_nostim_cleaned.dat(:, whout) = [];
stim_vs_nostim_cleaned.removed_images = 0;

holdout_sets(whout) = [];

[cverr, stats] = predict(stim_vs_nostim_cleaned, 'cv_lassopcr', 'nfolds', holdout_sets);

fprintf('Prediction-outcome correlation: r = %3.2f\n', stats.pred_outcome_r);

create_figure('scatter', 1, 2); 
plot_correlation_samefig(all_nps_resid(~whout), stats.Y);
xlabel('NPS'); ylabel('Pain report');

subplot(1, 2, 2);
plot_correlation_samefig(stats.yfit, stats.Y);
xlabel('Predicted from new model'); ylabel('Pain report');

%% Rank within study


%% Predict test suite: fewer components

predict_test_suite(stim_vs_nostim_cleaned, 'nfolds', 3);
 

%%  Masking / feature selection


%% 
stim_vs_nostim_all_subjects.X = behdat.vas_stim_vs_nostim;

out = regress(stim_vs_nostim_all_subjects, 'nodisplay');

t = threshold(out.t, .01, 'unc');

%o2 = removeblobs(o2);

%o2 = addblobs(o2, region(t), 'trans', 'splitcolor', {[0 0 1] [.3 .8 1] [1 .5 0] [1 1 0]});
%%
k = size(out.t.dat, 2);

for i = 1:k
    
    o2 = removeblobs(o2);
    
    t = out.t;
    t.dat = t.dat(:, i);
    t.ste = t.ste(:, i);
    t.p = t.p(:, i);
    t.sig = t.sig(:, i);
    t.threshold = t.threshold(:, i);
    
    t = threshold(t, .05, 'fdr', 'k', 10);
    
    fprintf('%s\n%s\n%s\n', z, connames{i}, z);

    o2 = addblobs(o2, region(t), 'trans', 'splitcolor', {[0 0 1] [.3 .8 1] [1 .5 0] [1 1 0]});
    
    % label and save image
    saveas(gcf, fullfile(figsavedir, ['map_' strrep(strrep(connames{i}, ' ', '_'), '.', '') '.png']));

    % make table
    r = region(t);
    table(r);
    
    % add brain surfaces
    if i == 1 && dosurfaces

        surface(r, 'foursurfaces', 'color_upperboundpercentile', 85, 'color_lowerboundpercentile', 15);
        
    end
    
    drawnow, snapnow
    
    %a = input('press space');
    
end