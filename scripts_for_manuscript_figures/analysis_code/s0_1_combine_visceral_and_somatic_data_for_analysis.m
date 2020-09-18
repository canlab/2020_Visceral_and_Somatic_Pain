load('C:\Users\phili\Dropbox (Cognitive and Affective Neuroscience Laboratory)\V_visceral_common\projects\nps_visceral\results\stim_vs_nostim_all_subjects.mat');
load_somatic_pain;
stim_vs_nostim_all_subjects.dat=[stim_vs_nostim_all_subjects.dat bmrk3_high_low_heat_pain.dat thermal_stim.dat];
stim_vs_nostim_all_subjects.additional_info{1}=[stim_vs_nostim_all_subjects.additional_info{1}; 7*ones(size(bmrk3_high_low_heat_pain.dat,2),1); 8*ones(size(thermal_stim.dat,2),1)];

save([resultsdir filesep 'stim_vs_nostim_all_subjects_corrected'],'stim_vs_nostim_all_subjects','-v7.3');

