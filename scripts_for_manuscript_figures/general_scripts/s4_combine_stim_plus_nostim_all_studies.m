%% Load and concatenate data objects

myvariablename = 'stim_plus_nostim_all_subjects';

individual_study_dirs = {'V_fMRI_gastric_Leuven' 'V_fMRI_rectal_Grenoble' 'V_fMRI_rectal_Sendai' 'V_fMRI_vaginal_Leuven'};
data_object_name{1} = {'data_objects_control.mat'};
data_object_name{2} = {'data_objects.mat'};
data_object_name{3} = {'data_objects_control.mat' 'data_objects_ibs.mat'};
data_object_name{4} = {'data_objects.mat'};

n = length(individual_study_dirs);

combined_dat = [];
indx = 1;

% clear all_fullpath allY

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
            combined_dat.Y = tmp_obj.(myvariablename).Y;
            combined_dat.fullpath = tmp_obj.(myvariablename).fullpath;

        else
            
            newdat = resample_space(tmp_obj.(myvariablename), combined_dat);
            
            n = size(newdat.dat, 2);
            combined_dat.additional_info{1} = [combined_dat.additional_info{1}; i * ones(n, 1)];
            
            combined_dat.dat = [combined_dat.dat newdat.dat];
            combined_dat.Y  = [ combined_dat.Y; newdat.Y ];
            combined_dat.fullpath  = strvcat( combined_dat.fullpath, newdat.fullpath );

        end
        
%         allY{indx} = tmp_obj.(myvariablename).Y;
%         all_fullpath{indx} = tmp_obj.(myvariablename).fullpath;
%         indx = indx + 1;
        
    end % file within study
    
end % study

clear tmp_obj newdat
eval([myvariablename ' =  combined_dat;'])
eval(['save(fullfile(resultsdir, myvariablename), ''' myvariablename ''');'])

