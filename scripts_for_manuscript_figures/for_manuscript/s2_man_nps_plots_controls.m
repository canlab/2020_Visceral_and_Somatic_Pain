%%rescale data
% stim_vs_nostim_all_subjects = preprocess(stim_vs_nostim_all_subjects, 'remove_csf');
% stim_vs_nostim_all_subjects = preprocess(stim_vs_nostim_all_subjects, 'rescale_by_csf');
% stim_vs_nostim_all_subjects = split(stim_vs_nostim_all_subjects);

% stim_vs_nostim_all_subjects.additional_info{1}=stim_vs_nostim_all_subjects.additional_info{1}(isControl); %%PK ADD THIS
%% NPS responses: All and by study

all_nps = apply_nps(stim_vs_nostim_all_subjects);

% For regressing out gray, white, CSF - not used
% [gwcsf, gwcsfcomponents] = extract_gray_white_csf(stim_vs_nostim_all_subjects); % gwcsf is mean gray, white, CSF

% scaling factors for each image: L2 norm
for i=1:size(stim_vs_nostim_all_subjects.dat,2) 
    sF(i)=norm(stim_vs_nostim_all_subjects.dat(:,i),2); 
end

all_nps = all_nps{1};

% Regress out mean gray, white, CSF across subjects
% all_nps_resid = resid(scale(gwcsf, 1), all_nps, true);

% Divide by L2 norm
all_nps_l2 = all_nps./sF';

NN = length(all_nps_l2);

perc_correct = 100 * sum(all_nps_l2 > 0) ./ NN;

% Cohen's d
all_d = mean(all_nps_l2) ./ std(all_nps_l2);

fprintf('All NPS: Accuracy for Stim vs. No-stim: %3.0f%%, d = %3.2f\n', perc_correct, all_d);

%Accuracy for Stim vs. No-stim:  98%

%% NPS by study

% behdat.study
% behdat.newindic

studynames = {'Gastric' 'Rectal 1' 'Rectal 2' 'Vaginal'  'Esophageal' 'Thermal 1' 'Thermal 2'};
% mycolors = {[.2 .7 .2] [.8 0 .8] [.2 .2 1] [.4 .2 .6]  [.6 .2 .4] [.2 .7 .5] [.2 .7 .2]};
mycolors={[161,218,180]/255 [65,182,196]/255 [44,127,184]/255 [254,153,41]/255 [37,52,148]/255 [217,95,14]/255 [153,52,4]/255}; %
k = size(behdat.newindic, 2);

stim_vs_nostim_all_subjects.additional_info{1}(stim_vs_nostim_all_subjects.additional_info{1}>6)=stim_vs_nostim_all_subjects.additional_info{1}(stim_vs_nostim_all_subjects.additional_info{1}>6)-1;

for i = 1:k
    nps_by_study{i} = all_nps_l2(stim_vs_nostim_all_subjects.additional_info{1}==i); %
    
end

    %nps_by_study{1} =     nps_by_study{3} .* 30/18;  % rescale by time; not perfect, but rough attempt to correct scale diffs, see below
    
axh = plot_NPS_by_study(nps_by_study([1:3 5]), studynames([1:3 5]), mycolors([1:3 5]));
% saveas(gcf, fullfile(figsavedir, 'NPS_by_study_Controls_visceral.png'));

axes(axh(1));
hh = findobj(axh(1), 'Type', 'Text');  delete(hh)
xlabel(' '); ylabel(' '); set(gca, 'FontSize', 18);
title(' ');
scn_export_papersetup(500);
% saveas(gcf, fullfile(figsavedir, 'NPS_by_study_Controls_visceral_clean.png'));

drawnow, snapnow


    
axh = plot_NPS_by_study(nps_by_study([4 6 7]), studynames([4 6 7]), mycolors([4 6 7]));
% saveas(gcf, fullfile(figsavedir, 'NPS_by_study_Controls_somatic.png'));

axes(axh(1));
hh = findobj(axh(1), 'Type', 'Text');  delete(hh)
xlabel(' '); ylabel(' '); set(gca, 'FontSize', 18);
title(' ');
scn_export_papersetup(500);
% saveas(gcf, fullfile(figsavedir, 'NPS_by_study_Controls_somatic_clean.png'));

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
x = all_nps_l2;
y = behdat.vas_stim_vs_nostim; % vas

covariates = contrastcodes(visceral,2:end-2);
covnames = connames(2:end-2);
study_indicator = behdat.newindic;
markername = 'NPS';
savename = 'NPS_VAS_correlation';

brain_marker_behavior_correlation_controlling_study(x(visceral), y(visceral), covariates, covnames, description, study_indicator(visceral,[1:3 5]), studynames([1:3 5]), markername);
% saveas(gcf, fullfile(figsavedir, [savename '_visceral.png']));
drawnow, snapnow
title(' ');
% saveas(gcf, fullfile(figsavedir, [savename '_visceral_clean.png']));



covariates = contrastcodes(somatic,5:end);
covnames = connames(5:end);
study_indicator = behdat.newindic;
markername = 'NPS';
savename = 'NPS_VAS_correlation';

brain_marker_behavior_correlation_controlling_study(x(somatic), y(somatic), covariates, covnames, description, study_indicator(somatic,[4 6:7]), studynames([4 6:7]), markername);

% saveas(gcf, fullfile(figsavedir, [savename '_somatic.png']));
drawnow, snapnow
title(' ');
% saveas(gcf, fullfile(figsavedir, [savename '_somatic_clean.png']));



%% Correlation with stim intensity
% Note: need to z-score within study...

% description = 'NPS correlations with indiv diffs in stim pressure';
% x = all_nps;
% y = behdat.stim_intensity; % vas
% covariates = contrastcodes;
% covnames = connames(1:3);
% study_indicator = behdat.newindic;
% markername = 'NPS';
% savename = 'NPS_stim_intensity_correlation';
% 
% brain_marker_behavior_correlation_controlling_study(x(~isnan(y),:), y(~isnan(y)), covariates(~isnan(y),:), covnames, description, study_indicator(~isnan(y),1:3), studynames(1:3), markername);
% 
% ylabel('Stimulus intensity');
% saveas(gcf, fullfile(figsavedir, [savename '.png']));
% drawnow, snapnow
% title(' ');
% saveas(gcf, fullfile(figsavedir, [savename '_clean.png']));
% 
% 
