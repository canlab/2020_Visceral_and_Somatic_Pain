%% Reload

load(fullfile(resultsdir, 'NPS_by_study.mat'), 'all_nps', 'all_nps_resid', 'gwcsf', 'gwcsfcomponents');


%% Relationship with white matter/CSF
do_rerun = 0;

if do_rerun
    [gwcsf, gwcsfcomponents] = extract_gray_white_csf(stim_vs_nostim_all_subjects);
end

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

% Plot means and effect sizes:
% -----------------------------------------------------------------
axh = plot_NPS_by_study(nps_by_study_resid, studynames, mycolors);

axes(axh(1))
title('NPS by study: GM/WM/CSF resid');
saveas(gcf, fullfile(figsavedir, 'NPS_by_study_GMWMCSFresid.png'));
drawnow, snapnow

% Individual differences: NPS - VAS correlation
% -----------------------------------------------------------------
description = 'NPS correlations with indiv diffs in pain report';
x = cat(1, nps_by_study_resid{:});
y = behdat.vas_stim_vs_nostim; % vas
covariates = contrastcodes;
covnames = connames(1:2);
study_indicator = behdat.newindic;
markername = 'NPS';
savename = 'NPS_VAS_correlation';

brain_marker_behavior_correlation_controlling_study(x, y, covariates, covnames, description, study_indicator, studynames, markername);
drawnow, snapnow
% -----------------------------------------------------------------

%% Residualized NPS values: WM and CSF only

all_nps_resid = resid(scale(gwcsf(:, 2:3), 1), all_nps, true);

perc_correct = 100 * sum(all_nps_resid > 0) ./ length(all_nps_resid);
all_d = mean(all_nps_resid) ./ std(all_nps_resid);
fprintf('All NPS: Accuracy for Stim vs. No-stim: %3.0f%%, d = %3.2f\n', perc_correct, all_d);

for i = 1:k   
    nps_by_study_resid{i} = all_nps_resid(behdat.newindic(:, i));
end

axh = plot_NPS_by_study(nps_by_study_resid, studynames);

axes(axh(1))
title('NPS by study: WM/CSF resid');
saveas(gcf, fullfile(figsavedir, 'NPS_by_study_WMCSFresid.png'));
drawnow, snapnow

% Individual differences: NPS - VAS correlation
% -----------------------------------------------------------------
description = 'NPS correlations with indiv diffs in pain report';
x = cat(1, nps_by_study_resid{:});
y = behdat.vas_stim_vs_nostim; % vas
covariates = contrastcodes;
covnames = connames(1:2);
study_indicator = behdat.newindic;
markername = 'NPS';
savename = 'NPS_VAS_correlation';

brain_marker_behavior_correlation_controlling_study(x, y, covariates, covnames, description, study_indicator, studynames, markername);
drawnow, snapnow
% -----------------------------------------------------------------

%% Residualized NPS values: CSF only

all_nps_resid = resid(scale(gwcsf(:, 3), 1), all_nps, true);

perc_correct = 100 * sum(all_nps_resid > 0) ./ length(all_nps_resid);
all_d = mean(all_nps_resid) ./ std(all_nps_resid);
fprintf('All NPS: Accuracy for Stim vs. No-stim: %3.0f%%, d = %3.2f\n', perc_correct, all_d);

for i = 1:k   
    nps_by_study_resid{i} = all_nps_resid(behdat.newindic(:, i));
end

axh = plot_NPS_by_study(nps_by_study_resid, studynames);

axes(axh(1))
title('NPS by study: CSF resid');
saveas(gcf, fullfile(figsavedir, 'NPS_by_study_CSFresid.png'));
drawnow, snapnow

% Individual differences: NPS - VAS correlation
% -----------------------------------------------------------------
description = 'NPS correlations with indiv diffs in pain report';
x = cat(1, nps_by_study_resid{:});
y = behdat.vas_stim_vs_nostim; % vas
covariates = contrastcodes;
covnames = connames(1:2);
study_indicator = behdat.newindic;
markername = 'NPS';
savename = 'NPS_VAS_correlation';

brain_marker_behavior_correlation_controlling_study(x, y, covariates, covnames, description, study_indicator, studynames, markername);
drawnow, snapnow
% -----------------------------------------------------------------

%% Residualized NPS values: CSF components

all_nps_resid = resid(scale(gwcsfcomponents{3}, 1), all_nps, true);

perc_correct = 100 * sum(all_nps_resid > 0) ./ length(all_nps_resid);
all_d = mean(all_nps_resid) ./ std(all_nps_resid);
fprintf('All NPS: Accuracy for Stim vs. No-stim: %3.0f%%, d = %3.2f\n', perc_correct, all_d);

for i = 1:k   
    nps_by_study_resid{i} = all_nps_resid(behdat.newindic(:, i));
end

axh = plot_NPS_by_study(nps_by_study_resid, studynames);

axes(axh(1))
title('NPS by study: CSF components resid');
saveas(gcf, fullfile(figsavedir, 'NPS_by_study_CSFcompresid.png'));
drawnow, snapnow

% Individual differences: NPS - VAS correlation
% -----------------------------------------------------------------
description = 'NPS correlations with indiv diffs in pain report';
x = cat(1, nps_by_study_resid{:});
y = behdat.vas_stim_vs_nostim; % vas
covariates = contrastcodes;
covnames = connames(1:2);
study_indicator = behdat.newindic;
markername = 'NPS';
savename = 'NPS_VAS_correlation';

brain_marker_behavior_correlation_controlling_study(x, y, covariates, covnames, description, study_indicator, studynames, markername);
drawnow, snapnow
% -----------------------------------------------------------------

%% Residualized NPS values: CSF/WM components

all_nps_resid = resid(scale([gwcsfcomponents{2} gwcsfcomponents{3}], 1), all_nps, true);

perc_correct = 100 * sum(all_nps_resid > 0) ./ length(all_nps_resid);
all_d = mean(all_nps_resid) ./ std(all_nps_resid);
fprintf('All NPS: Accuracy for Stim vs. No-stim: %3.0f%%, d = %3.2f\n', perc_correct, all_d);

for i = 1:k   
    nps_by_study_resid{i} = all_nps_resid(behdat.newindic(:, i));
end

axh = plot_NPS_by_study(nps_by_study_resid, studynames);

axes(axh(1))
title('NPS by study: CSF/WM components resid');
saveas(gcf, fullfile(figsavedir, 'NPS_by_study_WMCSFcompresid.png'));
drawnow, snapnow

%% Normalized NPS values: CSF only

all_nps_resid = all_nps - gwcsf(:, 3);

perc_correct = 100 * sum(all_nps_resid > 0) ./ length(all_nps_resid);
all_d = mean(all_nps_resid) ./ std(all_nps_resid);
fprintf('All NPS: Accuracy for Stim vs. No-stim: %3.0f%%, d = %3.2f\n', perc_correct, all_d);

for i = 1:k   
    nps_by_study_resid{i} = all_nps_resid(behdat.newindic(:, i));
end

axh = plot_NPS_by_study(nps_by_study_resid, studynames);

axes(axh(1))
title('NPS by study: CSF norm');

saveas(gcf, fullfile(figsavedir, 'NPS_by_study_CSFnorm.png'));
drawnow, snapnow

% Individual differences: NPS - VAS correlation
% -----------------------------------------------------------------
description = 'NPS correlations with indiv diffs in pain report';
x = cat(1, nps_by_study_resid{:});
y = behdat.vas_stim_vs_nostim; % vas
covariates = contrastcodes;
covnames = connames(1:2);
study_indicator = behdat.newindic;
markername = 'NPS';
savename = 'NPS_VAS_correlation';

brain_marker_behavior_correlation_controlling_study(x, y, covariates, covnames, description, study_indicator, studynames, markername);
drawnow, snapnow
% -----------------------------------------------------------------
%% Normalized NPS values: CSF WM only

all_nps_resid = all_nps - mean(gwcsf(:, 2:3), 2);

perc_correct = 100 * sum(all_nps_resid > 0) ./ length(all_nps_resid);
all_d = mean(all_nps_resid) ./ std(all_nps_resid);
fprintf('All NPS: Accuracy for Stim vs. No-stim: %3.0f%%, d = %3.2f\n', perc_correct, all_d);

for i = 1:k   
    nps_by_study_resid{i} = all_nps_resid(behdat.newindic(:, i));
end

axh = plot_NPS_by_study(nps_by_study_resid, studynames);

axes(axh(1))
title('NPS by study: CSF+WM norm');

saveas(gcf, fullfile(figsavedir, 'NPS_by_study_WMCSFnorm.png'));
drawnow, snapnow

% Individual differences: NPS - VAS correlation
% -----------------------------------------------------------------
description = 'NPS correlations with indiv diffs in pain report';
x = cat(1, nps_by_study_resid{:});
y = behdat.vas_stim_vs_nostim; % vas
covariates = contrastcodes;
covnames = connames(1:2);
study_indicator = behdat.newindic;
markername = 'NPS';
savename = 'NPS_VAS_correlation';

brain_marker_behavior_correlation_controlling_study(x, y, covariates, covnames, description, study_indicator, studynames, markername);
drawnow, snapnow
% -----------------------------------------------------------------
%% Final NPS resid: Use CSF components

all_nps_resid = resid(scale(gwcsfcomponents{3}, 1), all_nps, true);

for i = 1:k   
    nps_by_study_resid{i} = all_nps_resid(behdat.newindic(:, i));
end

% Individual differences: NPS - VAS correlation
% -----------------------------------------------------------------
description = 'NPS correlations with indiv diffs in pain report';
x = cat(1, nps_by_study_resid{:});
y = behdat.vas_stim_vs_nostim; % vas
covariates = contrastcodes;
covnames = connames(1:2);
study_indicator = behdat.newindic;
markername = 'NPS';
savename = 'NPS_VAS_correlation';

brain_marker_behavior_correlation_controlling_study(x, y, covariates, covnames, description, study_indicator, studynames, markername);
drawnow, snapnow
% -----------------------------------------------------------------
%% Save
save(fullfile(resultsdir, 'NPS_by_study.mat'), 'all_nps', 'all_nps_resid', 'gwcsf', 'gwcsfcomponents');


%% Notes

% Final analysis:  Best performance overall is when top 5 principal
% components of CSF are regressed out. This improves things meaningfully.
%
% Next best is removing top 5 WM/CSF components.  This is similar to CSF
% only but more complex.
%
% Removing GM/WM/CSF means also helps, though I worry about contamination
% of global GM in particular with signals of interest.

