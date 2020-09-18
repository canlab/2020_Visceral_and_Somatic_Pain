% Load: This is done in s1
%
% load(fullfile(resultsdir, 'stim_vs_nostim_all_subjects.mat'));
%
% stim_vs_nostim_all_subjects = remove_empty(stim_vs_nostim_all_subjects);
%
% % Select subjects for this analysis
% stim_vs_nostim_all_subjects.dat = stim_vs_nostim_all_subjects.dat(:, behdat.wh_subjects);
%
% stim_vs_nostim_all_subjects.removed_images = ~behdat.wh_subjects;

combined_dat = stim_vs_nostim_all_subjects;

% trick to avoid putting empty images back in
combined_dat.removed_images = 0;


z = '___________________________________________________';

%% Image similarity

fprintf('%s\n%s\n%s\n', z, 'Spatial correlation with functional signatures', z);

stats = image_similarity_plot(combined_dat, 'average','mapset','npsplus','dofixrange',[-.15 .15],'plotstyle','polar');

title(' ')
savename = fullfile(figsavedir, ['signature_polar_Controls.png']);
% saveas(gcf, savename);

drawnow, snapnow

% Clean
hh = findobj(gca, 'Type', 'Text');  delete(hh)
savename = fullfile(figsavedir, ['signature_polar_clean.png']);
% saveas(gcf, savename);

fprintf('%s\n%s\n%s\n', z, 'Spatial correlation with Buckner lab networks', z);

stats = image_similarity_plot(combined_dat, 'average', 'bucknerlab','dofixrange',[-.3 .3],'plotstyle','polar');

title(' ')
savename = fullfile(figsavedir, ['bucknernetworks_polar_Controls.png']);
% saveas(gcf, savename);
drawnow, snapnow

% Clean
hh = findobj(gca, 'Type', 'Text');  delete(hh)
savename = fullfile(figsavedir, ['bucknernetworks_polar_clean.png']);
% saveas(gcf, savename);

%% Image similarity by study

studynames = {'Gastric' 'Rectal 1' 'Rectal 2' 'Vaginal' 'Esophageal'  'Thermal 1' 'Thermal 2'};
% mycolors = {[.2 .7 .2] [.8 0 .8] [.2 .2 1] [.4 .2 .6]  [.6 .2 .4] [.2 .7 .5] [.2 .7 .2]};
colors={[161,218,180]/255 [65,182,196]/255 [44,127,184]/255 [37,52,148]/255 [254,153,41]/255 [217,95,14]/255 [153,52,4]/255};
mycolors={[161,218,180]/255 [65,182,196]/255 [44,127,184]/255 [37,52,148]/255 [254,153,41]/255 [217,95,14]/255 [153,52,4]/255};

k = size(behdat.newindic, 2);

for i = 1:k
    
    studydat = combined_dat;
    studydat.dat = studydat.dat(:, behdat.newindic(:, i));
    
    fprintf('%s\n%s\n%s\n%s\n', z, 'Spatial correlation with functional signatures', studynames{i}, z);
    
    stats = image_similarity_plot(studydat, 'average','mapset','npsplus','dofixrange',[-.15 .15],'plotstyle','polar');
    title(studynames{i});
    
    % Color change
    hh = findobj(gcf, 'Color', 'r'); set(hh, 'Color', mycolors{i});
    hh = findobj(gcf, 'Type', 'patch');
    set(hh([2 3]), 'FaceColor', mycolors{i}, 'EdgeColor',  mycolors{i});
    set(hh(1), 'EdgeColor',  mycolors{i});
    
    %a = input('press space');
    
    title(' ')
    savename = fullfile(figsavedir, ['signature_polar' studynames{i} '.png']);
%     saveas(gcf, savename);
    drawnow, snapnow
    
    % Clean
    hh = findobj(gca, 'Type', 'Text');  delete(hh)
    savename = fullfile(figsavedir, ['signature_polar' studynames{i} '_clean.png']);
%     saveas(gcf, savename);
    
    fprintf('%s\n%s\n%s\n%s\n', z, 'Spatial correlation with Buckner lab networks', studynames{i}, z);
    
    stats = image_similarity_plot(studydat, 'average', 'bucknerlab','dofixrange',[-.3 .3],'plotstyle','polar');
    title(studynames{i});
    
    % Color change
    hh = findobj(gcf, 'Color', 'r'); set(hh, 'Color', mycolors{i});
    hh = findobj(gcf, 'Type', 'patch');
    set(hh([2 3]), 'FaceColor', mycolors{i}, 'EdgeColor',  mycolors{i});
    set(hh(1), 'EdgeColor',  mycolors{i});
    
    %a = input('press space');
    
    title(' ')
    savename = fullfile(figsavedir, ['bucknernetworks_polar' studynames{i} '.png']);
%     saveas(gcf, savename);
    drawnow, snapnow
    
    % Clean
    hh = findobj(gca, 'Type', 'Text');  delete(hh)
    savename = fullfile(figsavedir, ['bucknernetworks_polar' studynames{i} '_clean.png']);
%     saveas(gcf, savename);
    
end

%% Somatic
% studynames = {'Heat pain' 'Heat pain (study 2)' 'Vaginal pressure pain'};
% mycolors = {[.2 .7 .5] [.2 .7 .2] [.6 .2 .4]};
%
% for i = 1:3
%
%     if i == 1
%         studydat = bmrk3_high_low_heat_pain;
%     elseif i==2
%         studydat = thermal_stim;
%     else
%         studydat = stim_vs_nostim_control_vag;
%     end
%
%     fprintf('%s\n%s\n%s\n%s\n', z, 'Spatial correlation with functional signatures', studynames{i}, z);
%
%     stats = image_similarity_plot(studydat, 'average','mapset','npsplus','dofixrange',[-.15 .15]);
%     title(studynames{i});
%
%     % Color change
%     hh = findobj(gcf, 'Color', 'r'); set(hh, 'Color', mycolors{i});
%     hh = findobj(gcf, 'Type', 'patch');
%     set(hh([2 3]), 'FaceColor', mycolors{i}, 'EdgeColor',  mycolors{i});
%     set(hh(1), 'EdgeColor',  mycolors{i});
%
%     %a = input('press space');
%
%     title(' ')
%     savename = fullfile(figsavedir, ['signature_polar' studynames{i} '.png']);
%     saveas(gcf, savename);
%     drawnow, snapnow
%
%     % Clean
%     hh = findobj(gca, 'Type', 'Text');  delete(hh)
%     savename = fullfile(figsavedir, ['signature_polar' studynames{i} '_clean.png']);
%     saveas(gcf, savename);
%
%     fprintf('%s\n%s\n%s\n%s\n', z, 'Spatial correlation with Buckner lab networks', studynames{i}, z);
%
%     stats = image_similarity_plot(studydat, 'average', 'bucknerlab','dofixrange',[-.3 .3]);
%     title(studynames{i});
%
%     % Color change
%     hh = findobj(gcf, 'Color', 'r'); set(hh, 'Color', mycolors{i});
%     hh = findobj(gcf, 'Type', 'patch');
%     set(hh([2 3]), 'FaceColor', mycolors{i}, 'EdgeColor',  mycolors{i});
%     set(hh(1), 'EdgeColor',  mycolors{i});
%
%     %a = input('press space');
%
%     title(' ')
%     savename = fullfile(figsavedir, ['bucknernetworks_polar' studynames{i} '.png']);
%     saveas(gcf, savename);
%     drawnow, snapnow
%
%     % Clean
%     hh = findobj(gca, 'Type', 'Text');  delete(hh)
%     savename = fullfile(figsavedir, ['bucknernetworks_polar' studynames{i} '_clean.png']);
%     saveas(gcf, savename);
%
% end


%% compute stats across groups
% combined_dat=replace_empty(combined_dat);
% % put data in same space
% heat=resample_space(bmrk3_high_low_heat_pain,combined_dat);
% vaginal=resample_space(stim_vs_nostim_control_vag,combined_dat);
% combined_dat.dat=[combined_dat.dat heat.dat vaginal.dat];
% group=[combined_dat.additional_info{1}(behdat.wh_subjects); 4*ones(size(heat.dat,2),1); 5*ones(size(vaginal.dat,2),1)];

image_similarity_plot(combined_dat,'average','mapset','npsplus','noplot');
image_similarity_plot(combined_dat,'average','mapset','bucknerlab','noplot');

%% render some figures for display

names={'NPS','PINES','Rejection','VPS'};
dat=load_image_set('npsplus');
mask=fmri_data(which('brainmask.nii'));
mask.dat(mask.dat<.25)=0;
dat=apply_mask(dat,mask);
ci=0;
for i=[1 5 6 7]
    ci=ci+1;
    clear o2;close all;
    o2 = canlab_results_fmridisplay([], 'multirow',1, 'noverbose');
    cmap={[0 0 1] [.2 0 1] [1 .5 0] [1 1 0]};
    
    tv=dat;
    tv.dat=tv.dat(:,i);
%     [lower_vals,lower_inds]=sort(tv.dat(:,i),'ascend');
%     [upper_vals,upper_inds]=sort(tv.dat(:,i),'descend');
%     
%     tv.dat=zeros(size(tv.dat(:,i)));
    
%     tv.dat(lower_inds(1:lower(length(tv.dat)/40)))=lower_vals(1:lower(length(tv.dat)/40));
%     tv.dat(upper_inds(1:lower(length(tv.dat)/40)))=upper_vals(1:lower(length(tv.dat)/40));
 
o2 = addblobs(o2, region(tv), 'trans', 'splitcolor', cmap);
    pause(5)
    set(gcf, 'PaperPositionMode', 'auto');
%     saveas(gcf, fullfile(figsavedir, ['map_' names{i} '_for_comparison.png']));
%     saveas(gcf, fullfile(figsavedir, ['masked_map_' names{ci} '_for_comparison_nothresh.png']));
    
    drawnow, snapnow
end

%%

studies=combined_dat.additional_info{1};
groupnum(studies==1)=2;
groupnum(studies==2)=2;
groupnum(studies==3)=2;
groupnum(studies==4)=1;
groupnum(studies==5)=2;
groupnum(studies==7)=1;
groupnum(studies==8)=1;

stats = image_similarity_plot(combined_dat, 'average','mapset','npsplus','dofixrange',[-.15 .15],'compareGroups',groupnum,'plotstyle','polar');


%% Correlation of buckner loadings with pain report
stats = image_similarity_plot(combined_dat, 'average', 'bucknerlab','dofixrange',[-.3 .3],'plotstyle','polar');

for n=1:7
description = 'Buckner network correlations with indiv diffs in pain report';
x = stats.r(n,:)';
y = behdat.vas_stim_vs_nostim; % vas

covariates = contrastcodes(visceral,2:end-2);
covnames = connames(2:end-2);
study_indicator = behdat.newindic;
markername = stats.networknames{n};
savename = [ markername '_VAS_correlation'];

brain_marker_behavior_correlation_controlling_study(x(visceral), y(visceral), covariates, covnames, description, study_indicator(visceral,[1:3 5]), studynames([1:3 5]), markername);
% saveas(gcf, fullfile(figsavedir, [savename '_visceral.png']));
drawnow, snapnow
title(' ');
% saveas(gcf, fullfile(figsavedir, [savename '_visceral_clean.png']));



covariates = contrastcodes(somatic,5:end);
covnames = connames(5:end);
study_indicator = behdat.newindic;
markername = stats.networknames{n};
savename = [ markername '_VAS_correlation'];

brain_marker_behavior_correlation_controlling_study(x(somatic), y(somatic), covariates, covnames, description, study_indicator(somatic,[4 6:7]), studynames([4 6:7]), markername);

% saveas(gcf, fullfile(figsavedir, [savename '_somatic.png']));
drawnow, snapnow
title(' ');
% saveas(gcf, fullfile(figsavedir, [savename '_somatic_clean.png']));
end