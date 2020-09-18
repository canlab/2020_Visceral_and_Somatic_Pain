clear all

masterdir = '/Users/tor/Dropbox/SHARED_DATASETS/V_Michiko_Lukas_Giao_VisceralPain';

% The names of the study folders and the "common" folder should be the same
% across computers to make things easier.
commondir = fullfile(masterdir, 'V_visceral_common');
commonscriptsdir = fullfile(commondir, 'scripts');
g = genpath(commonscriptsdir); addpath(g)

[basedir, resultsdir, figsavedir, scriptsdir, pubdir] = set_up_dirs('nps_visceral');

