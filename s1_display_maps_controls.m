%% Load and handle missing/excluded data
% ------------------------------------------------------------------
load(fullfile(resultsdir, 'stim_vs_nostim_all_subjects.mat'));

stim_vs_nostim_all_subjects = remove_empty(stim_vs_nostim_all_subjects);

o2 = canlab_results_fmridisplay([], 'compact2', 'noverbose');
f1 = gcf;

% Select subjects for this analysis
stim_vs_nostim_all_subjects.dat = stim_vs_nostim_all_subjects.dat(:, behdat.wh_subjects);

stim_vs_nostim_all_subjects.removed_images = ~behdat.wh_subjects;

%% T-test
% Not in paper

% ------------------------------------------------------------------
% Stim vs. No-stim simple t-test, q < .05 FDR
% ------------------------------------------------------------------

t = ttest(stim_vs_nostim_all_subjects, .05, 'fdr');
o2 = addblobs(o2, region(t), 'trans', 'splitcolor', {[0 0 1] [.3 .8 1] [1 .5 0] [1 1 0]});

saveas(gcf, fullfile(figsavedir, ['map_ttest_all_controls.png']));
drawnow, snapnow

%% Compare to NPS
% Fig 1B

o2 = removeblobs(o2);

npsdisplay = which('weights_NSF_grouppred_cvpcr_FDR05_smoothed_fwhm05.img');
r = region(fmri_data(npsdisplay));

o2 = addblobs(o2, r, 'trans', 'splitcolor', {[0 0 1] [.3 .8 1] [1 .5 0] [1 1 0]});
figure(f1);
saveas(gcf, fullfile(figsavedir, 'map_nps_for_comparison.png'));

drawnow, snapnow

if dosurfaces

    surface(r, 'foursurfaces', 'color_upperboundpercentile', 85, 'color_lowerboundpercentile', 15);
    
    drawnow, snapnow
    saveas(gcf, fullfile(figsavedir, ['surface_nps.png']));
end

  
    
%% Set up regressors
% ------------------------------------------------------------------

% Check match:
% [behdat.study stim_vs_nostim_all_subjects.additional_info{1}(behdat.wh_subjects)]
% OK
% study = stim_vs_nostim_all_subjects.additional_info{1};
% indic = condf2indic(study);

contrasts = [   1 -.5 -.5 
                 0  1 -1];

connames = {'Gastric vs. Rectal Controls' 'Rectal 1 vs. Rectal 2 Controls' 'All_Controls_adjusted_for_study'};

contrastcodes = behdat.newindic * contrasts';

% Use these as regressors
stim_vs_nostim_all_subjects.X = contrastcodes;

% Regressors are not centered
% So the intercept is not the average subject, but the average (midpoint) of groups.
% Less powerful than centered regressors, but also not biased towards
% larger studies.

%% Run multiple regression with study covariates
% ------------------------------------------------------------------

z = '___________________________________________________';
fprintf('%s\n%s\n%s\n', z, 'Stim vs. No-stim Controlling Study', z);


out = regress(stim_vs_nostim_all_subjects, 'nodisplay');

k = size(out.t.dat, 2);
for i = 1:k
    
    o2 = removeblobs(o2);
    
    t = out.t;
    t.dat = t.dat(:, i);
    t.ste = t.ste(:, i);
    t.p = t.p(:, i);
    t.sig = t.sig(:, i);
    t.threshold = t.threshold(:, i);
    
    fprintf('%s\n%s\n%s\n', z, connames{i}, z);
        
    t = threshold(t, .05, 'fdr', 'k', 10);

    o2 = addblobs(o2, region(t), 'trans', 'splitcolor', {[0 0 1] [.3 .8 1] [1 .5 0] [1 1 0]});
    
    % label and save image
    saveas(gcf, fullfile(figsavedir, ['map_' strrep(strrep(connames{i}, ' ', '_'), '.', '') '.png']));

    % make table
    r = region(t);
    table(r);
    
    % add brain surfaces
    if i == 3 && dosurfaces

        surface(r, 'foursurfaces', 'color_upperboundpercentile', 85, 'color_lowerboundpercentile', 15);
            
        saveas(gcf, fullfile(figsavedir, ['surf_' strrep(strrep(connames{i}, ' ', '_'), '.', '') '.png']));

    end
    
    drawnow, snapnow
    
    %a = input('press space');
    
end
 
% to-do: Cortical topography in sensorimotor strip
% to-do: Patient vs. control contrast
