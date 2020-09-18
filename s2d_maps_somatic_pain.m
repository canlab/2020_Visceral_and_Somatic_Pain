% this is done in s1
% o2 = canlab_results_fmridisplay([], 'compact2', 'noverbose');
% f1 = gcf;


%% T-test for each

% ------------------------------------------------------------------
% Stim vs. No-stim simple t-test, q < .05 FDR
% ------------------------------------------------------------------

z = '___________________________________________________';
fprintf('%s\n%s\n%s\n', z, 'Somatic pain: Heat', z);

o2 = removeblobs(o2);
t = ttest(bmrk3_high_low_heat_pain, .05, 'fdr');
t = apply_mask(t, which('gray_matter_mask.img'));
t = threshold(t, .05, 'fdr');
o2 = addblobs(o2, region(t), 'trans', 'splitcolor', {[0 0 1] [.3 .8 1] [1 .5 0] [1 1 0]});

saveas(gcf, fullfile(figsavedir, ['map_ttest_heatpain.png']));
drawnow, snapnow

z = '___________________________________________________';
fprintf('%s\n%s\n%s\n', z, 'Somatic pain: Vaginal', z);

o2 = removeblobs(o2);
t = ttest(stim_vs_nostim_control_vag, .05, 'fdr');
t = apply_mask(t, which('gray_matter_mask.img'));
t = threshold(t, .05, 'fdr');
o2 = addblobs(o2, region(t), 'trans', 'splitcolor', {[0 0 1] [.3 .8 1] [1 .5 0] [1 1 0]});

saveas(gcf, fullfile(figsavedir, ['map_ttest_vaginalpain.png']));
drawnow, snapnow

t = threshold(t, .015, 'unc');
o2 = removeblobs(o2);
o2 = addblobs(o2, region(t), 'trans', 'splitcolor', {[0 0 1] [.3 .8 1] [1 .5 0] [1 1 0]});

saveas(gcf, fullfile(figsavedir, ['map_ttest_vaginalpain_samethreshasheat.png']));
drawnow, snapnow

