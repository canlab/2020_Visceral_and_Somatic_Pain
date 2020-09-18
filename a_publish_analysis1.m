% publish script

% Run this from the 'scripts' directory where it, and
% s0_set_up_paths_controls, are located

close all
clear all
s0_set_up_paths_controls;

% ------------------------------------------------------------------------
pubfilename = 'NPSpaper_1_Visceral_pain_Controls_3_studies_plus_somatic';

p = struct('useNewFigure', false, 'maxHeight', 800, 'maxWidth', 1200, ...
    'format', 'html', 'outputDir', fullfile(pubdir, pubfilename), 'showCode', false);

publish('script_set_1_controls.m', p)

% ------------------------------------------------------------------------

