%% Load and handle missing/excluded data
% ------------------------------------------------------------------

o2 = canlab_results_fmridisplay([], 'compact2', 'noverbose');
f1 = gcf;
clear combined_dat
newindic=[];
for i = 1:2
    
    if i == 1
        studydat = bmrk3_high_low_heat_pain;
        combined_dat=studydat;
    elseif i==2
        studydat = thermal_stim;
    else
        studydat = stim_vs_nostim_control_vag;
    end

    
    
    if i>1
       combined_dat.dat=[combined_dat.dat studydat.dat]; 
    end
       newindic=[newindic; i*ones(size(studydat.dat,2),1)];

    
end



%% T-test
% Not in paper
C=[0.2457 0 0.6432;0.1843  0 0.4824;0.7765 0.3216 0; 0.8627 0.5529 0];
cmap={[C(1,:)] [C(2,:)] [C(3,:)] [C(4,:)]};
% ------------------------------------------------------------------
% Stim vs. No-stim simple t-test, q < .05 FDR
% ------------------------------------------------------------------
t = ttest(combined_dat, .05, 'fdr');
o2 = addblobs(o2, region(t), 'trans', 'splitcolor', cmap);

saveas(gcf, fullfile(figsavedir, ['map_ttest_all_controls_somatic.png']));
drawnow, snapnow
  
    
%% Set up regressors
% ------------------------------------------------------------------

% Check match:
% [behdat.study stim_vs_nostim_all_subjects.additional_info{1}(behdat.wh_subjects)]
% OK
% study = stim_vs_nostim_all_subjects.additional_info{1};
% indic = condf2indic(study);

contrasts = [   .5 .5 -1
                -1 1 0  ];

connames = {'Thermal vs Vaginal' 'Thermal 1 vs Thermal 2'  'All_Controls_adjusted_for_study_somatic'};

contrastcodes = condf2indic(newindic) * contrasts';

% Use these as regressors
combined_dat.X = contrastcodes;

% Regressors are not centered
% So the intercept is not the average subject, but the average (midpoint) of groups.
% Less powerful than centered regressors, but also not biased towards
% larger studies.

%% Run multiple regression with study covariates
% ------------------------------------------------------------------
C=canlabCmap;
z = '___________________________________________________';
fprintf('%s\n%s\n%s\n', z, 'Stim vs. No-stim Controlling Study', z);


out = regress(combined_dat, 'nodisplay');

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
    saveas(gcf, fullfile(figsavedir, ['map_' strrep(strrep(connames{i}, ' ', '_'), '.', '') '.png']));

    % make table
    r = region(t);
    table(r);
    
    % add brain surfaces
    if i == 3 && dosurfaces

        surface(r, 'foursurfaces','pos_colormap',C(33:end,:), 'neg_colormap',C(1:32,:),'color_upperboundpercentile', 85, 'color_lowerboundpercentile', 15);            
        saveas(gcf, fullfile(figsavedir, ['surf_' strrep(strrep(connames{i}, ' ', '_'), '.', '') '.png']));

    end
    
    drawnow, snapnow
    
    %a = input('press space');
    
end
 
% to-do: Cortical topography in sensorimotor strip
% to-do: Patient vs. control contrast
