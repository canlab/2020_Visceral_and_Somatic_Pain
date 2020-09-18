%% Load and handle missing/excluded data -visceral-
% ------------------------------------------------------------------
% load(fullfile(resultsdir, 'stim_vs_nostim_all_subjects_updated.mat'));
% load('D:\Dropbox (Cognitive and Affective Neuroscience Laboratory)\V_visceral_common\projects\nps_visceral\results\stim_vs_nostim_all_subjects.mat')

load(fullfile(resultsdir, 'stim_vs_nostim_all_subjects_corrected.mat'));
stim_vs_nostim_all_subjects.dat=stim_vs_nostim_all_subjects.dat(:,isControl);
stim_vs_nostim_all_subjects = remove_empty(stim_vs_nostim_all_subjects);
stim_vs_nostim_all_subjects.removed_images = 0;%~any(behdat.newindic(:,1:4)');
stim_vs_nostim_all_subjects.additional_info{1}=stim_vs_nostim_all_subjects.additional_info{1}(isControl);

% somatic=all(behdat.newindic(:,[1 2 3 5])'==0)';
somatic=stim_vs_nostim_all_subjects.additional_info{1}==4|stim_vs_nostim_all_subjects.additional_info{1}==7|stim_vs_nostim_all_subjects.additional_info{1}==8;
visceral = ~somatic;
dosurfaces=0;
%% T-test
% clear o2;close all;
% o2 = canlab_results_fmridisplay([], 'full', 'noverbose');
% set(gcf,'position',[0 0 6000 1000])
% set(gcf, 'PaperPositionMode', 'auto');

% C=[0.2457 0 0.6432;0.1843  0 0.4824;0.7765 0.3216 0; 0.8627 0.5529 0];
% cmap={[0 0 1] [.2 0 1] [1 .5 0] [1 1 0]};

% ------------------------------------------------------------------
% Stim vs. No-stim simple t-test, q < .05 FDR
% ------------------------------------------------------------------
% tv=stim_vs_nostim_all_subjects;
% tv.dat=tv.dat(:,somatic);
% t = ttest(tv, .05, 'fdr');
% o2 = addblobs(o2, region(t), 'trans', 'splitcolor', cmap);
% saveas(gcf, fullfile(figsavedir, ['map_ttest_all_controls_somatic.png']));
% drawnow, snapnow
%
% C=canlabCmap;
% surface(region(t), 'foursurfaces','color_upperboundpercentile', 85, 'color_lowerboundpercentile', 15,'pos_colormap',C(33:end,:), 'neg_colormap',C(1:32,:));
% saveas(gcf, fullfile(figsavedir, ['surface_ttest_all_controls_somatic.png']));
% drawnow, snapnow


% clear o2;close all;
% o2 = canlab_results_fmridisplay([], 'full', 'noverbose');
% set(gcf,'position',[0 0 6000 1000])
% set(gcf, 'PaperPositionMode', 'auto');
% 
% tv=stim_vs_nostim_all_subjects;
% tv.dat=tv.dat(:,visceral);
% t = ttest(stim_vs_nostim_all_subjects, .05, 'fdr');
% o2 = addblobs(o2, region(t), 'trans', 'splitcolor', cmap);
% saveas(gcf, fullfile(figsavedir, ['map_ttest_all_controls_visceral.png']));
% drawnow, snapnow
% clear tv

%
% C=canlabCmap;
% surface(region(t), 'foursurfaces','color_upperboundpercentile', 85, 'color_lowerboundpercentile', 15,'pos_colormap',C(33:end,:), 'neg_colormap',C(1:32,:));
% saveas(gcf, fullfile(figsavedir, ['surface_ttest_all_controls_visceral.png']));
% drawnow, snapnow

%% Compare to NPS
% Fig 1B

% clear o2;close all;
% o2 = canlab_results_fmridisplay([], 'full', 'noverbose');
% set(gcf,'position',[0 0 6000 1000])
% 
% C=canlabCmap;
% npsdisplay = which('weights_NSF_grouppred_cvpcr_FDR05_smoothed_fwhm05.img');
% r = region(fmri_data(npsdisplay));
% 
% o2 = addblobs(o2, r, 'trans', 'splitcolor',cmap); %
% set(gcf, 'PaperPositionMode', 'auto');
% saveas(gcf, fullfile(figsavedir, 'map_nps_for_comparison.png'));
% 
% drawnow, snapnow
% 
% if dosurfaces
%     
%     surface(r, 'foursurfaces','color_upperboundpercentile', 85, 'color_lowerboundpercentile', 15,'pos_colormap',C(33:end,:), 'neg_colormap',C(1:32,:));
%     
%     drawnow, snapnow
%     saveas(gcf, fullfile(figsavedir, ['surface_nps.png']));
% end



%% separate regressions for visceral/somatic
clear o2;close all;
o2 = canlab_results_fmridisplay([], 'full', 'noverbose');
set(gcf,'position',[0 0 6000 1000])
cmap={[0 0 1] [.2 0 1] [1 .5 0] [1 1 0]};

tv=stim_vs_nostim_all_subjects;
tv.dat=tv.dat(:,visceral);

contrasts = [
    1 -.5 -.5 0
    0 1 -1 0
    1 0 0 -1 ];
connames = {'Gastric vs Rectal' 'Rectal 1 vs Rectal 2' 'Gastric vs Esophageal'  'Visceral_Controls_adjusted_for_study'};
contrastcodes = behdat.newindic(visceral,[1 2 3 5]) * contrasts';
tv.X = contrastcodes;

% Run multiple regression with study covariates -- visceral --
% ------------------------------------------------------------------

z = '___________________________________________________';
fprintf('%s\n%s\n%s\n', z, 'Stim vs. No-stim Controlling Study', z);


out = regress(tv, 'nodisplay');
% cmap={[C(1,:)] [C(2,:)] [1 .5 0] [1 1 1]};
% C=canlabCmap;

k = size(out.t.dat, 2);
for i = k
    
    o2 = removeblobs(o2);
    
    t = out.t;
    t.dat = t.dat(:, i);
    t.ste = t.ste(:, i);
    t.p = t.p(:, i);
    t.sig = t.sig(:, i);
    t.threshold = t.threshold(:, i);
    
    fprintf('%s\n%s\n%s\n', z, connames{i}, z);
    
    t = threshold(t, .05, 'fdr', 'k', 10);
    
    o2 = addblobs(o2, region(t), 'trans', 'splitcolor', cmap);
    
    % label and save image
    set(gcf, 'PaperPositionMode', 'auto');
%     saveas(gcf, fullfile(figsavedir, ['map_' strrep(strrep(connames{i}, ' ', '_'), '.', '') '.png']));
    drawnow, snapnow
    
    % make table
    r = region(t);
    
    if ~isempty(r(1).XYZ)
        table(r,'subclust');
    end
    
    % add brain surfaces
    if i == 4 && dosurfaces
        
        surface(r, 'foursurfaces','pos_colormap',C(32:end,:), 'neg_colormap',C(1:32,:),'color_upperboundpercentile', 85, 'color_lowerboundpercentile', 15);
%         saveas(gcf, fullfile(figsavedir, ['surf_' strrep(strrep(connames{i}, ' ', '_'), '.', '') '.png']));
        
    end
    
    drawnow, snapnow
    
    visceral_t_pos=t;
    visceral_t_pos.dat(visceral_t_pos.dat<0)=0;
    
    visceral_t_neg=t;
    visceral_t_neg.dat(visceral_t_neg.dat>0)=0;

end


%% separate regressions for visceral/somatic
clear o2;close all;
o2 = canlab_results_fmridisplay([], 'full', 'noverbose');
set(gcf,'position',[0 0 6000 1000])
tv=stim_vs_nostim_all_subjects;
tv.dat=tv.dat(:,somatic);

contrasts = [
    1 -.5 -.5
    0 1 -1  ];
connames = {'Vaginal vs Thermal' 'Thermal 1 vs Thermal 2' 'Somatic_Controls_adjusted_for_study'};
contrastcodes = behdat.newindic(somatic,[4 6 7]) * contrasts';
tv.X = contrastcodes;

% Run multiple regression with study covariates -- visceral --
% ------------------------------------------------------------------

z = '___________________________________________________';
fprintf('%s\n%s\n%s\n', z, 'Stim vs. No-stim Controlling Study', z);


out = regress(tv, 'nodisplay');
% C=[0.2457 0 0.6432;0.1843  0 0.4824;0.7765 0.3216 0; 0.8627 0.5529 0];
% cmap={[C(1,:)] [C(2,:)] [C(3,:)] [C(4,:)]};
C=canlabCmap;
cmap={[0 0 1] [.2 0 1] [1 .5 0] [1 1 0]};

k = size(out.t.dat, 2);
for i = k
    
    o2 = removeblobs(o2);
    
    t = out.t;
    t.dat = t.dat(:, i);
    t.ste = t.ste(:, i);
    t.p = t.p(:, i);
    t.sig = t.sig(:, i);
    t.threshold = t.threshold(:, i);
    
    fprintf('%s\n%s\n%s\n', z, connames{i}, z);
    
    t = threshold(t, .05, 'fdr', 'k', 10);
    o2 = addblobs(o2, region(t), 'trans', 'splitcolor', cmap);
    
    % label and save image
    set(gcf, 'PaperPositionMode', 'auto');
%     saveas(gcf, fullfile(figsavedir, ['map_' strrep(strrep(connames{i}, ' ', '_'), '.', '') '.png']));
    drawnow, snapnow
    
    % make table
    r = region(t);
    
    if ~isempty(r(1).XYZ)
        table(r,'subclust');
    end
    
    % add brain surfaces
    if i == 3 && dosurfaces
        
        surface(r, 'foursurfaces','pos_colormap',C(32:end,:), 'neg_colormap',C(1:32,:),'color_upperboundpercentile', 85, 'color_lowerboundpercentile', 15);
%         saveas(gcf, fullfile(figsavedir, ['surf_' strrep(strrep(connames{i}, ' ', '_'), '.', '') '.png']));
        
    end
    
    drawnow, snapnow
       
     
    somatic_t_pos=t;
    somatic_t_pos.dat(somatic_t_pos.dat<0)=0;
    
    somatic_t_neg=t;
    somatic_t_neg.dat(somatic_t_neg.dat>0)=0;
    
    
end


%% conjunction between visceral and somatic
clear o2;close all;
o2 = canlab_results_fmridisplay([], 'full', 'noverbose');
set(gcf,'position',[0 0 6000 1000])
% o2 = surface(o2, 'axes', [0.3 .2 .3 .3], 'direction', 'hires left', 'orientation', 'lateral');
% o2 = surface(o2, 'axes', [0.5 .2 .3 .3], 'direction', 'hires right', 'orientation', 'lateral');

somatic_t_pos=replace_empty(somatic_t_pos);
visceral_t_pos=replace_empty(visceral_t_pos);
overlap_pos=conjunction(somatic_t_pos,visceral_t_pos,1);

somatic_t_pos.dat(somatic_t_pos.dat<0)=0;
visceral_t_pos.dat(visceral_t_pos.dat<0)=0;

mask_pos_somatic=somatic_t_pos;
mask_pos_visceral=visceral_t_pos;
mask_pos_somatic.dat=mask_pos_somatic.dat>0 & mask_pos_somatic.sig>0;
mask_pos_visceral.dat=mask_pos_visceral.dat>0 & mask_pos_visceral.sig;


somatic_t_pos.dat(overlap_pos.sig>0)=0;
visceral_t_pos.dat(overlap_pos.sig>0)=0;
somatic_t_pos.sig(overlap_pos.sig>0)=0;
visceral_t_pos.sig(overlap_pos.sig>0)=0;

% 
o2=addblobs(o2,region(somatic_t_pos),'splitcolor',{[0 0 0] [0 0 0] [1 .5 0]*.8 [1 .5 0]});
o2=addblobs(o2,region(visceral_t_pos),'splitcolor',{[0 0 0] [0 0 0] [.35 .0 .7]*.8 [.35 .0 .7]});
o2=addblobs(o2,region(overlap_pos),'trans','color', [1 1 0]);


set(gcf, 'PaperPositionMode', 'auto');
% saveas(gcf, fullfile(figsavedir, 'conjunction_somatic_visceral_pos.png'));
drawnow, snapnow


%%
clear o2;close all;
o2 = canlab_results_fmridisplay([], 'full', 'noverbose');
set(gcf,'position',[0 0 6000 1000])
% o2 = surface(o2, 'axes', [0.3 .2 .3 .3], 'direction', 'hires left', 'orientation', 'lateral');
% o2 = surface(o2, 'axes', [0.5 .2 .3 .3], 'direction', 'hires right', 'orientation', 'lateral');

somatic_t_neg=replace_empty(somatic_t_neg);
visceral_t_neg=replace_empty(visceral_t_neg);
overlap_neg=conjunction(somatic_t_neg,visceral_t_neg,-1);

somatic_t_neg.dat(somatic_t_neg.dat>0)=0;
visceral_t_neg.dat(visceral_t_neg.dat>0)=0;


mask_neg_somatic=somatic_t_neg;
mask_neg_visceral=visceral_t_neg;
mask_neg_somatic.dat=mask_neg_somatic.dat<0 & mask_neg_somatic.sig>0;
mask_neg_visceral.dat=mask_neg_visceral.dat<0 & mask_neg_visceral.sig;


somatic_t_neg.dat(overlap_neg.sig>0)=0;
visceral_t_neg.dat(overlap_neg.sig>0)=0;
somatic_t_neg.sig(overlap_neg.sig>0)=0;
visceral_t_neg.sig(overlap_neg.sig>0)=0;

% 
% o2=addblobs(o2,region(somatic_t_neg),'splitcolor',{[1 .5 0]*.8 [1 .5 0] [0 0 0] [0 0 0] });
% o2=addblobs(o2,region(visceral_t_neg),'splitcolor',{[.35 .0 .7]*.8 [.35 .0 .7] [0 0 0] [0 0 0] });
o2=addblobs(o2,region(overlap_neg),'trans','color', [1 1 0]);
% 

set(gcf, 'PaperPositionMode', 'auto');
% saveas(gcf, fullfile(figsavedir, 'conjunction_somatic_visceral_neg.png'));
drawnow, snapnow
%% Set up regressors
% ------------------------------------------------------------------

% Check match:
% [behdat.study stim_vs_nostim_all_subjects.additional_info{1}(behdat.wh_subjects)]
% OK
% study = stim_vs_nostim_all_subjects.additional_info{1};
% indic = condf2indic(study);
%
% contrasts = [   1 -.5 -.5 0
%                 0 1 -1 0
%                 1 0 0 -1 ];
%
% connames = {'Gastric vs Rectal' 'Rectal 1 vs Rectal 2' 'Gastric vs Esophageal'  'All_Controls_adjusted_for_study'};


contrasts = [   -.25 -.25 -.25  1/3  -.25 1/3 1/3
    1 -.5 -.5 0 0 0 0
    0 1 -1 0 0 0 0
    1 0 0 0 -1 0 0
    0 0 0 0 0 -1 1
    0 0 0 -1 0 .5 .5];

connames = {'Somatic vs Visceral' 'Gastric vs Rectal' 'Rectal 1 vs Rectal 2' 'Gastric vs Esophageal' 'Thermal 1 vs Thermal 2', 'Thermal vs Vaginal', 'All_Controls_adjusted_for_study'};



contrastcodes = behdat.newindic * contrasts';

% Use these as regressors
stim_vs_nostim_all_subjects.X = contrastcodes;

% Regressors are not centered
% So the intercept is not the average subject, but the average (midpoint) of groups.
% Less powerful than centered regressors, but also not biased towards
% larger studies.

%% Run multiple regression comparing visceral and somatic
% ------------------------------------------------------------------

z = '___________________________________________________';
fprintf('%s\n%s\n%s\n', z, 'Stim vs. No-stim Controlling Study', z);


out = regress(stim_vs_nostim_all_subjects, 'nodisplay');
C=canlabCmap;

k = size(out.t.dat, 2);
for i = 1%:k
    
    for m=1:2 %mask somatic positive/mask visceral positive
    
    o2 = removeblobs(o2);
    
    t = out.t;
    t=replace_empty(t);
    
    
    t.dat = t.dat(:, i);
    t.ste = t.ste(:, i);
    t.p = t.p(:, i);
    t.sig = t.sig(:, i);
    t.threshold = t.threshold(:, i);
    
    fprintf('%s\n%s\n%s\n', z, connames{i}, z);
    
    t = threshold(t, .05, 'fdr', 'k', 10);
%     t.dat(t.dat<0)=0;
%     o2 = addblobs(o2, region(t), 'trans', 'splitcolor', cmap);
    
    % label and save image
%     saveas(gcf, fullfile(figsavedir, ['map_' strrep(strrep(connames{i}, ' ', '_'), '.', '') '.png']));
    drawnow, snapnow
    
    % make table
    r = region(t);
    
    if ~isempty(r(1).XYZ)
        table(r,'subclust');
    end
    
    % add brain surfaces
    if i == 5 && dosurfaces
        
        surface(r, 'foursurfaces','pos_colormap',C(32:end,:), 'neg_colormap',C(1:32,:),'color_upperboundpercentile', 85, 'color_lowerboundpercentile', 15);
%         saveas(gcf, fullfile(figsavedir, ['surf_' strrep(strrep(connames{i}, ' ', '_'), '.', '') '.png']));
        
    end
    
    drawnow, snapnow
    
    %a = input('press space');
    end
end


%% Run multiple regression comparing visceral and somatic --masked-- positive
% ------------------------------------------------------------------
clear o2;close all;
o2 = canlab_results_fmridisplay([], 'full', 'noverbose');
set(gcf,'position',[0 0 6000 1000])

z = '___________________________________________________';
fprintf('%s\n%s\n%s\n', z, 'Stim vs. No-stim Controlling Study', z);


out = regress(stim_vs_nostim_all_subjects, 'nodisplay');
C=canlabCmap;
masknames={'SomaticPositiveMask' 'VisceralPositiveMask'};

k = size(out.t.dat, 2);
 o2 = removeblobs(o2);

for i = 1%:k
    
    
    
    for m=1:2 %mask somatic positive/mask visceral positive

    t = out.t;
    t=replace_empty(t);
      t.dat = t.dat(:, i);
    t.ste = t.ste(:, i);
    t.p = t.p(:, i);
    t.sig = t.sig(:, i);
    
    if m==1
        t.dat=t.dat.*double(mask_pos_somatic.dat);
        t.dat(t.dat<0)=0;

    else
       t.dat=t.dat.*double(mask_pos_visceral.dat);
       t.dat=t.dat*-1;
       t.dat(t.dat<0)=0;
    end

    t.threshold = t.threshold(:, i);
    if m==1
    fprintf('%s\n%s\n%s\n', z, [connames{i} '; Somatic Positive mask'], z);
    else
    fprintf('%s\n%s\n%s\n', z, [connames{i} ' reversed; Visceral Positive mask'], z);        
    end
    t = threshold(t, .05, 'fdr', 'k', 10);
    t.dat(~t.sig)=nan;
    if m==1
            o2 = addblobs(o2, region(t), 'trans', 'splitcolor', cmap);
        t.fullpath='somatic_vs_visceral_activation.nii';
    else
              o2 = addblobs(o2, region(t), 'trans', 'splitcolor', {cmap{4} cmap{3} cmap{2} cmap{1}});
        t.fullpath='visceral_vs_somatic_activation.nii';
        
    end
    
    % label and save image
%     saveas(gcf, fullfile(figsavedir, ['map_' strrep(strrep(connames{i}, ' ', '_'), '.', '') '_masked.png']));
    drawnow, snapnow
%     write(t)

    % make table
    r = region(t);
    
    if ~isempty(r(1).XYZ)
%         table(r,'subclust');
%             cluster_table(r,1,0)
    end
    end

    % add brain surfaces
    if i == 5 && dosurfaces
        
%         surface(r, 'foursurfaces','pos_colormap',C(32:end,:), 'neg_colormap',C(1:32,:),'color_upperboundpercentile', 85, 'color_lowerboundpercentile', 15);
%         saveas(gcf, fullfile(figsavedir, ['surf_' strrep(strrep(connames{i}, ' ', '_'), '.', '') '.png']));
        
    end
    
    drawnow, snapnow
    
    %a = input('press space');
end



%% Run multiple regression comparing visceral and somatic --masked-- negative
% ------------------------------------------------------------------
clear o2;close all;
o2 = canlab_results_fmridisplay([], 'full', 'noverbose');
set(gcf,'position',[0 0 6000 1000])

z = '___________________________________________________';
fprintf('%s\n%s\n%s\n', z, 'Stim vs. No-stim Controlling Study', z);


out = regress(stim_vs_nostim_all_subjects, 'nodisplay');
C=canlabCmap;
masknames={'SomaticNegativeMask' 'VisceralNegativeMask'};

k = size(out.t.dat, 2);
 o2 = removeblobs(o2);

for i = 1%:k
    
    
    
    for m=1:2 %mask somatic positive/mask visceral positive

    t = out.t;
    t=replace_empty(t);
      t.dat = t.dat(:, i);
    t.ste = t.ste(:, i);
    t.p = t.p(:, i);
    t.sig = t.sig(:, i);
    
    if m==1
        t.dat=t.dat.*double(mask_neg_somatic.dat);
        t.dat(t.dat>0)=0;

    else
       t.dat=t.dat.*double(mask_neg_visceral.dat);
       t.dat=t.dat*-1;
       t.dat(t.dat>0)=0;
    end

    t.threshold = t.threshold(:, i);
    t.dat=t.dat*-1;
    if m==1
    fprintf('%s\n%s\n%s\n', z, [connames{i} '; Somatic Negative mask'], z);
    
    else
    fprintf('%s\n%s\n%s\n', z, [connames{i} ' reversed; Visceral Negative mask'], z);        
    end
    t = threshold(t, .05, 'fdr', 'k', 10);
    
    if m==1
    o2 = addblobs(o2, region(t), 'trans', 'splitcolor', cmap);
    t.fullpath='somatic_vs_visceral_deactivation.nii';

    else 
     o2 = addblobs(o2, region(t), 'trans', 'splitcolor', {cmap{4} cmap{3} cmap{2} cmap{1}});
     t.fullpath='visceral_vs_somatic_deactivation.nii';

    end
    
    % label and save image
%     saveas(gcf, fullfile(figsavedir, ['map_' strrep(strrep(connames{i}, ' ', '_'), '.', '') '_masked_negative.png']));
    drawnow, snapnow
    
    % make table
    r = region(t);
    
    if ~isempty(r(1).XYZ)
%         table(r,'subclust');
%             cluster_table(r,1,0);
    end
    end

    % add brain surfaces
    if i == 5 && dosurfaces
        
        surface(r, 'foursurfaces','pos_colormap',C(32:end,:), 'neg_colormap',C(1:32,:),'color_upperboundpercentile', 85, 'color_lowerboundpercentile', 15);
%         saveas(gcf, fullfile(figsavedir, ['surf_' strrep(strrep(connames{i}, ' ', '_'), '.', '') '.png']));
        
    end
    
    drawnow, snapnow
%         write(t)

    %a = input('press space');
end
