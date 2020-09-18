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

stats = image_similarity_plot(combined_dat, 'average');

title(' ')
savename = fullfile(figsavedir, ['signature_polar_Controls.png']);
saveas(gcf, savename);

drawnow, snapnow

% Clean
hh = findobj(gca, 'Type', 'Text');  delete(hh)
savename = fullfile(figsavedir, ['signature_polar_clean.png']);
saveas(gcf, savename);

fprintf('%s\n%s\n%s\n', z, 'Spatial correlation with Buckner lab networks', z);

stats = image_similarity_plot(combined_dat, 'average', 'bucknerlab');

title(' ')
savename = fullfile(figsavedir, ['bucknernetworks_polar_Controls.png']);
saveas(gcf, savename);
drawnow, snapnow

% Clean
hh = findobj(gca, 'Type', 'Text');  delete(hh)
savename = fullfile(figsavedir, ['bucknernetworks_polar_clean.png']);
saveas(gcf, savename);

%% Image similarity by study

studynames = {'Gastric' 'Rectal-Grenoble' 'Rectal-Sendai'};
mycolors = {[.2 .7 .2] [.8 0 .8] [.2 .2 1]};

k = size(behdat.newindic, 2);

for i = 1:k
    
    studydat = combined_dat;
    studydat.dat = studydat.dat(:, behdat.newindic(:, i));
    
    fprintf('%s\n%s\n%s\n%s\n', z, 'Spatial correlation with functional signatures', studynames{i}, z);
    
    stats = image_similarity_plot(studydat, 'average');
    title(studynames{i});
    
    % Color change
    hh = findobj(gcf, 'Color', 'r'); set(hh, 'Color', mycolors{i});
    hh = findobj(gcf, 'Type', 'patch');
    set(hh([2 3]), 'FaceColor', mycolors{i}, 'EdgeColor',  mycolors{i});
    set(hh(1), 'EdgeColor',  mycolors{i});
    
    %a = input('press space');
    
    title(' ')
    savename = fullfile(figsavedir, ['signature_polar' studynames{i} '.png']);
    saveas(gcf, savename);
    drawnow, snapnow
    
    % Clean
    hh = findobj(gca, 'Type', 'Text');  delete(hh)
    savename = fullfile(figsavedir, ['signature_polar' studynames{i} '_clean.png']);
    saveas(gcf, savename);
    
    fprintf('%s\n%s\n%s\n%s\n', z, 'Spatial correlation with Buckner lab networks', studynames{i}, z);
    
    stats = image_similarity_plot(studydat, 'average', 'bucknerlab');
    title(studynames{i});
    
    % Color change
    hh = findobj(gcf, 'Color', 'r'); set(hh, 'Color', mycolors{i});
    hh = findobj(gcf, 'Type', 'patch');
    set(hh([2 3]), 'FaceColor', mycolors{i}, 'EdgeColor',  mycolors{i});
    set(hh(1), 'EdgeColor',  mycolors{i});
    
    %a = input('press space');
    
    title(' ')
    savename = fullfile(figsavedir, ['bucknernetworks_polar' studynames{i} '.png']);
    saveas(gcf, savename);
    drawnow, snapnow
    
    % Clean
    hh = findobj(gca, 'Type', 'Text');  delete(hh)
    savename = fullfile(figsavedir, ['bucknernetworks_polar' studynames{i} '_clean.png']);
    saveas(gcf, savename);
    
end

%% Somatic
studynames = {'Heat pain' 'Vaginal pressure pain'};
mycolors = {[.2 .7 .5] [.6 .2 .4]};
  
for i = 1:2
    
    if i == 1
    studydat = bmrk3_high_low_heat_pain;
    else
        studydat = stim_vs_nostim_control_vag;
    end
    
    fprintf('%s\n%s\n%s\n%s\n', z, 'Spatial correlation with functional signatures', studynames{i}, z);
    
    stats = image_similarity_plot(studydat, 'average');
    title(studynames{i});
    
    % Color change
    hh = findobj(gcf, 'Color', 'r'); set(hh, 'Color', mycolors{i});
    hh = findobj(gcf, 'Type', 'patch');
    set(hh([2 3]), 'FaceColor', mycolors{i}, 'EdgeColor',  mycolors{i});
    set(hh(1), 'EdgeColor',  mycolors{i});
    
    %a = input('press space');
    
    title(' ')
    savename = fullfile(figsavedir, ['signature_polar' studynames{i} '.png']);
    saveas(gcf, savename);
    drawnow, snapnow
    
    % Clean
    hh = findobj(gca, 'Type', 'Text');  delete(hh)
    savename = fullfile(figsavedir, ['signature_polar' studynames{i} '_clean.png']);
    saveas(gcf, savename);
    
    fprintf('%s\n%s\n%s\n%s\n', z, 'Spatial correlation with Buckner lab networks', studynames{i}, z);
    
    stats = image_similarity_plot(studydat, 'average', 'bucknerlab');
    title(studynames{i});
    
    % Color change
    hh = findobj(gcf, 'Color', 'r'); set(hh, 'Color', mycolors{i});
    hh = findobj(gcf, 'Type', 'patch');
    set(hh([2 3]), 'FaceColor', mycolors{i}, 'EdgeColor',  mycolors{i});
    set(hh(1), 'EdgeColor',  mycolors{i});
    
    %a = input('press space');
    
    title(' ')
    savename = fullfile(figsavedir, ['bucknernetworks_polar' studynames{i} '.png']);
    saveas(gcf, savename);
    drawnow, snapnow
    
    % Clean
    hh = findobj(gca, 'Type', 'Text');  delete(hh)
    savename = fullfile(figsavedir, ['bucknernetworks_polar' studynames{i} '_clean.png']);
    saveas(gcf, savename);
    
end


%% compute stats across groups
combined_dat=replace_empty(combined_dat);
% put data in same space
heat=resample_space(bmrk3_high_low_heat_pain,combined_dat);
vaginal=resample_space(stim_vs_nostim_control_vag,combined_dat);
combined_dat.dat=[combined_dat.dat heat.dat vaginal.dat];
group=[combined_dat.additional_info{1}(behdat.wh_subjects); 4*ones(size(heat.dat,2),1); 5*ones(size(vaginal.dat,2),1)];

image_similarity_plot(combined_dat,'average','noplot','compareGroups',group);
image_similarity_plot(combined_dat,'average','bucknerlab','noplot','compareGroups',group);