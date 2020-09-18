% this may be different for each computer:
% it contains all the individual study folders, as well as common project
% folders
masterdir = '/Users/tor/Dropbox/SHARED_DATASETS/V_Michiko_Lukas_Giao_VisceralPain';

cd(masterdir)

% The names of the study folders and the "common" folder should be the same
% across computers to make things easier.
commondir = fullfile(masterdir, 'V_visceral_common');

% Set up common scripts - these are for loading data and setting paths
% and things done across multiple 'projects'

scriptsdir = fullfile(commondir, 'scripts');
g = genpath(scriptsdir); addpath(g)

toolboxdir = fullfile(commondir, 'toolboxes');
g = genpath(toolboxdir); addpath(g)

%% Run this to set up directories

projectdirs = {'nps_visceral' 'spatial_basis_visceral'};

mkdir(fullfile(commondir, 'projects'))

for i = 1:length(projectdirs)
    
    basedir = fullfile(commondir, 'projects', projectdirs{i});
    if ~exist(basedir, 'dir'), mkdir(basedir); end

    resultsdir = fullfile(basedir, 'results');
    if ~exist(resultsdir, 'dir'), mkdir(resultsdir); end

    figsavedir = fullfile(resultsdir, 'figures');
    if ~exist(figsavedir, 'dir'), mkdir(figsavedir); end

    scriptsdir = fullfile(basedir, 'scripts');
    if ~exist(scriptsdir, 'dir'), mkdir(scriptsdir); end

    pubdir = fullfile(resultsdir, 'html_reports');
    if ~exist(pubdir, 'dir'), mkdir(pubdir); end

end

