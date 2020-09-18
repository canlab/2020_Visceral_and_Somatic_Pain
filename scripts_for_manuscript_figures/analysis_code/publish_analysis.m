% publish script

% Run this from the 'scripts' directory where it, and
% s0_set_up_paths_controls, are located
clear 
close all
s0_man_set_up_paths_controls;

% ------------------------------------------------------------------------
pubfilename = 'NPSpaper_1_ReportForManuscript';

p = struct('useNewFigure', false, 'maxHeight', 800, 'maxWidth', 1200, ...
    'format', 'html', 'outputDir', fullfile(pubdir, pubfilename), 'showCode', false);

publish('toPublish.m', p)