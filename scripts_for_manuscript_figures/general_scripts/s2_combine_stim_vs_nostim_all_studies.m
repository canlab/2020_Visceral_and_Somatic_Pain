clear all

% masterdir = '/Users/tor/Dropbox/SHARED_DATASETS/V_Michiko_Lukas_Giao_VisceralPain';
masterdir='D:\Dropbox (Cognitive and Affective Neuroscience Laboratory)\';

% The names of the study folders and the "common" folder should be the same
% across computers to make things easier.
commondir = fullfile(masterdir, 'V_visceral_common');
commonscriptsdir = fullfile(commondir, 'scripts');
g = genpath(commonscriptsdir); addpath(g)

[basedir, resultsdir, figsavedir, scriptsdir, pubdir] = set_up_dirs('nps_visceral',masterdir);

%% Load and concatenate data objects

myvariablename = 'stim_vs_nostim_all_subjects';

individual_study_dirs = {'V_fMRI_gastric_Leuven' 'V_fMRI_rectal_Grenoble' 'V_fMRI_rectal_Sendai' 'V_fMRI_vaginal_Leuven' 'v_fMRI_oesophageal_London' };
data_object_name{1} = {'data_objects_control.mat'};
data_object_name{2} = {'data_objects.mat'};
data_object_name{3} = {'data_objects_control.mat' 'data_objects_ibs.mat'};
data_object_name{4} = {'data_objects.mat'};
data_object_name{5} = {'data_objects_control.mat'};

n = length(individual_study_dirs);

combined_dat = [];

for i = 1:n
    
    for j = 1:length(data_object_name{i})
        
        mypath = fullfile(masterdir, individual_study_dirs{i}, 'results', data_object_name{i}{j});
        
        fprintf('Working on: \n%s\n', mypath);
        
        if exist(mypath, 'file') == 2
            
            tmp_obj = load(mypath);
            
        else
            fprintf('CANNOT FIND: \n%s\n', mypath);
            continue  % will skip to next file
        end
        
        if ~isfield(tmp_obj, myvariablename)
            fprintf('CANNOT FIND VAR %s in: \n%s\n', myvariablename, mypath);
            continue  % will skip to next file
        end
        
        % we have the data object: add it
        if isempty(combined_dat)
            
            combined_dat = tmp_obj.(myvariablename);
            
            n = size(combined_dat.dat, 2);
            combined_dat.additional_info{1} = i * ones(n, 1);
            combined_dat.additional_info{2} = 'Study';
            
        else
            
            newdat = resample_space(tmp_obj.(myvariablename), combined_dat);
            
            n = size(newdat.dat, 2);
            combined_dat.additional_info{1} = [combined_dat.additional_info{1}; i * ones(n, 1)];
            
            combined_dat.dat = [combined_dat.dat newdat.dat];
        end
        
        
    end % file within study
    
end % study


clear tmp_obj newdat
eval([myvariablename ' =  combined_dat;'])
eval(['save(fullfile(resultsdir, myvariablename), ''' myvariablename ''');'])

