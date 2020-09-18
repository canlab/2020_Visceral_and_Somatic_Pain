% bmrk3_high_low_heat_pain
% stim_vs_nostim_control_vag
nps_by_study_som = {};

%% NPS responses: All and by study

z = '___________________________________________________';
fprintf('%s\n%s\n%s\n', z, 'NPS for somatic pain: Heat', z);

all_nps = apply_nps(bmrk3_high_low_heat_pain);
all_nps = all_nps{1}; %.* 2.^3 / 1.5^3;  % scale by relative voxel volume for comparability


perc_correct = 100 * sum(all_nps > 0) ./ length(all_nps);
all_d = mean(all_nps) ./ std(all_nps);
fprintf('All NPS: Accuracy for Stim vs. No-stim: %3.0f%%, d = %3.2f\n', perc_correct, all_d);

nps_by_study_som{1} = all_nps;


z = '___________________________________________________';
fprintf('%s\n%s\n%s\n', z, 'NPS for somatic pain: Vaginal (controls)', z);

all_nps = apply_nps(stim_vs_nostim_control_vag);
all_nps = all_nps{1} .*  1.5^3 / 2.^3; % scale by relative voxel volume for comparability


perc_correct = 100 * sum(all_nps > 0) ./ length(all_nps);
all_d = mean(all_nps) ./ std(all_nps);
fprintf('All NPS: Accuracy for Stim vs. No-stim: %3.0f%%, d = %3.2f\n', perc_correct, all_d);

nps_by_study_som{2} = all_nps;

%Accuracy for Stim vs. No-stim:  87%

%% NPS by study


studynames = {'Heat pain' 'Vaginal pressure pain'};
mycolors = {[.2 .7 .5] [.6 .2 .4]};
  
axh = plot_NPS_by_study(nps_by_study_som, studynames, mycolors);
saveas(gcf, fullfile(figsavedir, 'NPS_by_study_Controls_Somatic.png'));

axes(axh(1));
hh = findobj(axh(1), 'Type', 'Text');  delete(hh)
xlabel(' '); ylabel(' '); set(gca, 'FontSize', 36);
title(' ');
scn_export_papersetup(500);
saveas(gcf, fullfile(figsavedir, 'NPS_by_study_Controls_Somatic_clean.png'));

drawnow, snapnow
