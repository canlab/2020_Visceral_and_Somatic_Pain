%% Select subjects for this analysis
% -------------------------------------------------------------------
load(fullfile(resultsdir, 'stim_vs_nostim_all_subjects.mat'));

stim_vs_nostim_all_subjects = remove_empty(stim_vs_nostim_all_subjects);

stim_vs_nostim_all_subjects.dat = stim_vs_nostim_all_subjects.dat(:, behdat.wh_subjects);

stim_vs_nostim_all_subjects.removed_images = ~behdat.wh_subjects;

%% NPS responses: All and by study

all_nps = apply_nps(stim_vs_nostim_all_subjects);
all_nps = all_nps{1};


perc_correct = 100 * sum(all_nps > 0) ./ length(all_nps);
all_d = mean(all_nps) ./ std(all_nps);
fprintf('All NPS: Accuracy for Stim vs. No-stim: %3.0f%%, d = %3.2f\n', perc_correct, all_d);

%% RE-do NPS extraction and CSF covariates with ALL subjects
% -------------------------------------------------------------------

%% Relationship with white matter/CSF

[gwcsf, gwcsfcomponents] = extract_gray_white_csf(stim_vs_nostim_all_subjects);

rnames = {'NPS' 'globGM' 'globWM' 'globCSF'};
print_matrix(corr([all_nps gwcsf]), rnames, rnames);

%% Residualized NPS values: GM, WM, CSF

% Residualize with respect to mean activity in all 3 compartments:
% -----------------------------------------------------------------
all_nps_resid = resid(scale(gwcsf, 1), all_nps, true);

perc_correct = 100 * sum(all_nps_resid > 0) ./ length(all_nps_resid);
all_d = mean(all_nps_resid) ./ std(all_nps_resid);
fprintf('All NPS: Accuracy for Stim vs. No-stim: %3.0f%%, d = %3.2f\n', perc_correct, all_d);

for i = 1:k   
    nps_by_study_resid{i} = all_nps_resid(behdat.newindic(:, i));
end

%% Save

save(fullfile(resultsdir, 'NPS_by_study_patientscontrols.mat'), 'all_nps', 'all_nps_resid', 'gwcsf', 'gwcsfcomponents');

