% Prep heat and vaginal pain

load(fullfile(resultsdir, 'bmrk3_high_low_heat_pain'));
bmrk3_high_low_heat_pain=resample_space(bmrk3_high_low_heat_pain,stim_vs_nostim_all_subjects);




% vagfile = fullfile('D:\Dropbox (Cognitive and Affective Neuroscience Laboratory)\V_fMRI_vaginal_Leuven\2015\results\data_objects.mat');
vagfile = fullfile('C:\Users\phili\Dropbox (Cognitive and Affective Neuroscience Laboratory)\V_fMRI_vaginal_Leuven\2015\results\data_objects.mat');


v = load(vagfile, 'dat_control_certainstim_avg', 'dat_control_nostim_avg');

stim_vs_nostim_control_vag = v.dat_control_certainstim_avg;
stim_vs_nostim_control_vag.dat = stim_vs_nostim_control_vag.dat - v.dat_control_nostim_avg.dat;
stim_vs_nostim_control_vag=resample_space(stim_vs_nostim_control_vag,stim_vs_nostim_all_subjects);





%% get data from bmrk4
% load('D:\Google Drive\Wagerlab_Single_Trial_Pain_Datasets\Data\bmrk4_pain_ST_SmoothedWithBasis_handfoot\bmrk4_pain_ST_SmoothedWithBasis_allmetadata.mat')
load('C:\Users\phili\Google Drive\Wagerlab_Single_Trial_Pain_Datasets\Data\bmrk4_pain_ST_SmoothedWithBasis_handfoot\bmrk4_pain_ST_SmoothedWithBasis_allmetadata.mat')

clear tv;
for s=1:length(bmrk4_pain_st_alldata.stim)
%     load(['D:\Google Drive\Wagerlab_Single_Trial_Pain_Datasets\Data\bmrk4_pain_ST_SmoothedWithBasis_handfoot\' bmrk4_pain_st_alldata.dat_obj{s}]);
    load(['C:\Users\phili\Google Drive\Wagerlab_Single_Trial_Pain_Datasets\Data\bmrk4_pain_ST_SmoothedWithBasis_handfoot\' bmrk4_pain_st_alldata.dat_obj{s}]);

    if s==1
        thermal_stim=dat;        
    end
    tv(s,:)=mean(dat.dat(:,bmrk4_pain_st_alldata.stim{s}==3),2); %high  stim
    
end
thermal_stim.dat=tv';
thermal_stim = resample_space(thermal_stim, stim_vs_nostim_all_subjects);
