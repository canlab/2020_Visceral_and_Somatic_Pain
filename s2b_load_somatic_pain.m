% Prep heat and vaginal pain

load(fullfile(resultsdir, 'bmrk3_high_low_heat_pain'));

vagfile = fullfile(basedir, '..', '..', '..', 'V_fMRI_vaginal_Leuven', 'results', 'data_objects.mat');

v = load(vagfile, 'dat_control_certainstim_avg', 'dat_control_nostim_avg');

stim_vs_nostim_control_vag = v.dat_control_certainstim_avg;
stim_vs_nostim_control_vag.dat = stim_vs_nostim_control_vag.dat - v.dat_control_nostim_avg.dat;

