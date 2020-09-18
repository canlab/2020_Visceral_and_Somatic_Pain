load(fullfile(resultsdir, 'NPS_by_study_patientscontrols.mat'), 'all_nps', 'all_nps_resid', 'gwcsf', 'gwcsfcomponents');

% use all_nps_resid
% normalize by stim intensity, because there are diffs between patients and
% controls in some cases.

studynames = {'R1 Controls' 'R1 Crohns' 'R2 Controls' 'R2 IBS'};
mycolors = {[.8 0 .8] [.4 0 .4] [.2 .2 1] [.2 .2 .5]};


%% Get normalized NPS values

% groups 2, 3:  Controls, CD patients (Grenoble)
% groups 4, 5:  Controls, IBS patients (Sendai)

vol = behdat.stim_intensity;  % mL

k = size(behdat.newindic, 2);

for i = 1:k
    nps_by_study{i} = all_nps_resid(behdat.newindic(:, i));
    
    vol_by_study{i} = vol(behdat.newindic(:, i));
    
    nps_per_mL{i} = nps_by_study{i} ./ vol_by_study{i};

    % only exists for 4:5, Sendai data
    pressure_by_study{i} = behdat.stim_intensity_pressure(behdat.newindic(:, i));

    nps_per_mmHg{i} = nps_by_study{i} ./ pressure_by_study{i};

end

%% Stim intensity diffs for each study

y = vol;
indic = behdat.newindic(:, 2:3);
covs = [];
ydescrip = 'Volume (mL)';
plotcolors = mycolors(1:2);
plotstudynames = studynames(1:2);

visceral_compare_groups(y, indic, covs, ydescrip, plotstudynames, plotcolors);

y = vol;
indic = behdat.newindic(:, 4:5);
covs = [];
ydescrip = 'Volume (mL)';
plotcolors = mycolors(3:4);
plotstudynames = studynames(3:4);

visceral_compare_groups(y, indic, covs, ydescrip, plotstudynames, plotcolors);


y = behdat.stim_intensity_pressure;
indic = behdat.newindic(:, 4:5);
covs = [];
ydescrip = 'Pressure (mmHg)';
plotcolors = mycolors(3:4);
plotstudynames = studynames(3:4);

visceral_compare_groups(y, indic, covs, ydescrip, plotstudynames, plotcolors);

%% NPS diffs

y = all_nps_resid;
indic = behdat.newindic(:, 2:3);
covs = [vol behdat.vas_stim_vs_nostim];
covnames = {'Volume' 'Pain ratings'};
ydescrip = 'NPS with CSF denoising';
plotcolors = mycolors(1:2);
plotstudynames = studynames(1:2);

visceral_compare_groups(y, indic, covs, ydescrip, plotstudynames, plotcolors, covnames);
%%
y = all_nps_resid;
indic = behdat.newindic(:, 4:5);
covs = [vol behdat.vas_stim_vs_nostim];
covnames = {'Volume' 'Pain ratings'};
ydescrip = 'NPS with CSF denoising';
plotcolors = mycolors(3:4);
plotstudynames = studynames(3:4);

visceral_compare_groups(y, indic, covs, ydescrip, plotstudynames, plotcolors, covnames);

%% NPS by study, normalized by stimulus volume

%%
y = cat(1, nps_per_mL{:});
indic = behdat.newindic(:, 2:3);
covs = behdat.vas_stim_vs_nostim;
covnames = {'Pain ratings'};
ydescrip = 'NPS per mL with CSF denoising';
plotcolors = mycolors(1:2);
plotstudynames = studynames(1:2);

visceral_compare_groups(y, indic, covs, ydescrip, plotstudynames, plotcolors, covnames);
%%
y = cat(1, nps_per_mL{:});
indic = behdat.newindic(:, 4:5);
covs = behdat.vas_stim_vs_nostim;
covnames = {'Pain ratings'};
ydescrip = 'NPS per mL with CSF denoising';
plotcolors = mycolors(3:4);
plotstudynames = studynames(3:4);

visceral_compare_groups(y, indic, covs, ydescrip, plotstudynames, plotcolors, covnames);

%%
y = cat(1, nps_per_mmHg{:});
indic = behdat.newindic(:, 4:5);
covs = [];
ydescrip = 'NPS per mm Hg pressure with CSF denoising';
plotcolors = mycolors(3:4);
plotstudynames = studynames(3:4);

visceral_compare_groups(y, indic, covs, ydescrip, plotstudynames, plotcolors);


% %% Separate "clean" plots and t-tests for patient vs. control
% z = '___________________________________________________';
% 
% fprintf('\n%s\nRectal 1 Control - Patient\n%s\n', z, z);
% 
% axh = plot_NPS_compare_two_groups(nps_per_mL(2:3), studynames(1:2), mycolors(1:2));
% axes(axh(1));
% ylabel('NPS response / mL stimulus');
% 
% fprintf('\n%s\nRectal 2 Control - Patient\n%s\n', z, z);
% 
% axh = plot_NPS_compare_two_groups(nps_per_mL(4:5), studynames(3:4), mycolors(3:4));
% axes(axh(1));
% ylabel('NPS response / mL stimulus');
% 
% fprintf('\n%s\nRectal 2 Control - Patient\n%s\n', z, z);
% 
% axh = plot_NPS_compare_two_groups(nps_per_mmHg(4:5), studynames(3:4), mycolors(3:4));
% axes(axh(1));
% ylabel('NPS response / mmHg Pressure');
% 


%% Correlation with pain report

% Set up contrast codes
%'Gastric-Control'    'Rectal-Control'    'Rectal-CD'    'Rectal-Control'  'Rectal-IBS'
% Done in s6_set_up_paths_patientcontrols

% add interactions
contrastcodes = [contrastcodes contrastcodes .* repmat(all_nps_resid, 1, size(contrastcodes, 2))];
connames = [connames {'NPS*Gastric vs. Other' 'NPS*Rectal 1 Control vs. CD' 'NPS*Rectal 2 Control vs. IBS' 'NPS*Rectal 1 vs. 2'}];
    

% Analysis

description = 'NPS correlations with indiv diffs in pain report';
x = all_nps_resid;
y = behdat.vas_stim_vs_nostim; % vas
covariates = contrastcodes;
covnames = connames;
study_indicator = behdat.newindic;
markername = 'NPS';
savename = 'NPS_VAS_correlation_allcontrolspatients';

brain_marker_behavior_correlation_controlling_study(x, y, covariates, covnames, description, study_indicator, studynames, markername);
axis tight

saveas(gcf, fullfile(figsavedir, [savename '.png']));
drawnow, snapnow
title(' ');
saveas(gcf, fullfile(figsavedir, [savename '_clean.png']));

