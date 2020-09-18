
%% NPS responses: All and by study

all_nps = apply_nps(stim_vs_nostim_all_subjects);
all_nps = all_nps{1};


perc_correct = 100 * sum(all_nps > 0) ./ length(all_nps);
all_d = mean(all_nps) ./ std(all_nps);
fprintf('All NPS: Accuracy for Stim vs. No-stim: %3.0f%%, d = %3.2f\n', perc_correct, all_d);

%Accuracy for Stim vs. No-stim:  87%

%% NPS by study

% behdat.study
% behdat.newindic

studynames = {'Gastric' 'Rectal 1' 'Rectal 2'};
mycolors = {[.2 .7 .2] [.8 0 .8] [.2 .2 1]};

k = size(behdat.newindic, 2);

for i = 1:k
    nps_by_study{i} = all_nps(behdat.newindic(:, i));
end

    %nps_by_study{1} =     nps_by_study{3} .* 30/18;  % rescale by time; not perfect, but rough attempt to correct scale diffs, see below
    
axh = plot_NPS_by_study(nps_by_study, studynames, mycolors);
saveas(gcf, fullfile(figsavedir, 'NPS_by_study_Controls.png'));

axes(axh(1));
hh = findobj(axh(1), 'Type', 'Text');  delete(hh)
xlabel(' '); ylabel(' '); set(gca, 'FontSize', 36);
title(' ');
scn_export_papersetup(500);
saveas(gcf, fullfile(figsavedir, 'NPS_by_study_Controls_clean.png'));

drawnow, snapnow

% Check for sameness:  N runs, contrast weights, field strength
%
% Factors that could influence magnitude:
% - Match / spatial pattern - likely
% - Discomfort / pain intensity  - unlikely
%
% Field strength - all 3 T
% RUns and contrasts - all run averages, not an issue
% voxel size after resampling - all same
% voxel size original - may be some diffs in SNR, not huge issue
% baseline condition - gastric and rectal more potential baseline
% discomfort
%
% duration of stimuli - gastric = 30 sec (slower), 18 for rectal, 12 for
% vaginal (3 x 4 sec pressure pulses)
% - temporal match to HRF
% - habituation/sensitization during trial (gastric may peak early)
% - neural 'duty cycle': frequency during stim block
% - overlap with HP filter and noise frequencies

% No real principled basis for rescaling: Max is same for 18 sec & 30 sec
% hrf = spm_hrf(2/16);
% short = ones(round(18 * 16/2), 1); short = conv(short, hrf);
% long = ones(round(30 * 16/2), 1); long = conv(long, hrf);
% create_figure('hrf'); plot(short);
% hold on; plot(long)

%% Correlation with pain report

description = 'NPS correlations with indiv diffs in pain report';
x = all_nps;
y = behdat.vas_stim_vs_nostim; % vas
covariates = contrastcodes;
covnames = connames(1:2);
study_indicator = behdat.newindic;
markername = 'NPS';
savename = 'NPS_VAS_correlation';

brain_marker_behavior_correlation_controlling_study(x, y, covariates, covnames, description, study_indicator, studynames, markername);

saveas(gcf, fullfile(figsavedir, [savename '.png']));
drawnow, snapnow
title(' ');
saveas(gcf, fullfile(figsavedir, [savename '_clean.png']));

%% Correlation with stim intensity
% Note: need to z-score within study...

description = 'NPS correlations with indiv diffs in stim pressure';
x = all_nps;
y = behdat.stim_intensity; % vas
covariates = contrastcodes;
covnames = connames(1:2);
study_indicator = behdat.newindic;
markername = 'NPS';
savename = 'NPS_stim_intensity_correlation';

brain_marker_behavior_correlation_controlling_study(x, y, covariates, covnames, description, study_indicator, studynames, markername);

ylabel('Stimulus intensity');
saveas(gcf, fullfile(figsavedir, [savename '.png']));
drawnow, snapnow
title(' ');
saveas(gcf, fullfile(figsavedir, [savename '_clean.png']));


