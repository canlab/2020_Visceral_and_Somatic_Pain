function [stats, within_subject_svm_dist] = visceral_train_SVM(inputobject, holdout_sets, redo_predict, bootsamples, resultsdir, savenamebase, o2, varargin)
%
% [stats, within_subject_svm_dist] = visceral_train_SVM(inputobject, holdout_sets, redo_predict, bootsamples, resultsdir, savenamebase, o2, [indic])
%
% redo_predict = 0;
% bootsamples = 50;
% savename = 'SVM_stats_weightmap_2000bootstrap';

within_subject_svm_dist = [];  % only returned if indic is entered

statssavefilename = fullfile(resultsdir, [savenamebase '.mat']);

figsavedir = fullfile(resultsdir, 'figures');

if redo_predict
    
    tic
    [cverr, stats, optout] = predict(inputobject, 'algorithm_name', 'cv_svm', 'nfolds', holdout_sets, 'bootweights', 'bootsamples', bootsamples);
    toc
    
    % remove to save space
    stats.function_handle = [];
    stats.function_call = [];
    stats.other_output_cv = [];
    stats = rmfield(stats, 'WTS');
    
    % add this special within-person thing
    stats.within_subject_svm_dist = within_subject_svm_dist;
    save(statssavefilename, 'stats');
    
else
    load(statssavefilename, 'stats');
end

% Show montages - unthresholded
% ----------------------------------------------------------------------------
w = stats.weight_obj;

o2 = removeblobs(o2);
o2 = addblobs(o2, region(w), 'trans', 'splitcolor', {[0 0 1] [.3 .8 1] [1 .5 0] [1 1 0]});

axes(o2.montage{2}.axis_handles(1))
savename = [savenamebase 'montage_nothreshold'];
saveas(gcf, fullfile(figsavedir, [savename '.png']));

%% Get indic if entered


indic = [];
if length(varargin) > 0
    
    indic = varargin{1};
    create_figure('ROC', 1, 2);
    
else
    create_figure('ROC');
end


%% ROC plot for combined cross-study SVM: Results overall and by study


ROC = roc_plot(stats.dist_from_hyperplane_xval, stats.Y > 0); %, 'color', 'r', 'twochoice');
title([strrep(savenamebase, '_', ' ') ' single-interval'], 'FontSize', 18);


if ~isempty(indic)
    % multi-study: Separate by study and do forced-choice
    % for stim vs. no-stim
    
    subplot(1, 2, 2);
    mycolors = {[.2 .7 .2] [.8 0 .8] [.6 0 .4] [.2 .2 1] [.2 .5 .7]};
    clear svm_dist_by_study y_by_study all_lineh
    
    k = size(indic, 2);
    
    for i = 1:k
        
        svm_dist_by_study{i} = stats.dist_from_hyperplane_xval(indic(:, i));
        y_by_study{i} = stats.Y(indic(:, i)) > 0;
        
    end
    
    % This will only work if the images in each set have equal numbers of stim
    % and no-stim outcomes, with a block of stim followed by a block of no-stim
    % and subjects in the same order in each block.  This format is required by
    % the 'twochoice' option.
    
    clear accuracy nsubj
    
    for i = 1:k
        
        ROC = roc_plot(svm_dist_by_study{i}, y_by_study{i}, 'color', mycolors{i}, 'twochoice');
        
        all_lineh(i) = ROC.line_handle(2);
        
        % accuracy
        accuracy(i) = ROC.accuracy;
        nsubj(i) = length(y_by_study{i}) ./ 2;
        
        % distances, for correlations
        d = reshape(svm_dist_by_study{i}, nsubj(i), 2);
        d = d(:, 1) - d(:, 2);
        svmdist_by_study{i} = d;
        
    end
    
    title([strrep(savenamebase, '_', ' ') ' forced choice'], 'FontSize', 18);
    %legend(all_lineh, studynames, 'Location', 'Best');
    
    % SVM accuracy
    
    total_acc = sum(accuracy .* nsubj) ./ sum(nsubj);  % per subject
    
    fprintf('Forced-choice accuracy: Balanced: %3.0f%%, Total: %3.0f%%\n', 100*mean(accuracy), 100*total_acc);
    
    within_subject_svm_dist = cat(1, svmdist_by_study{:});
    
end % Multi-group breakdown


savename = [savenamebase '_ROC'];
saveas(gcf, fullfile(figsavedir, [savename '.png']));

drawnow, snapnow



%% Bar plot
if ~isempty(indic)
    
    k = size(indic, 2);
    
    if k == 3
        mycolors = {[.2 .7 .2] [.8 0 .8] [.2 .2 1]};
    else
        mycolors = {[.2 .7 .2] [.8 0 .8] [.6 0 .4] [.2 .2 1] [.2 .5 .7]};
    end
    
    for i = 1:k
        studynames{i} = ['Group ' num2str(i)];
    end
    
    axh = plot_NPS_by_study(svmdist_by_study, studynames, mycolors);
    axes(axh(1)), title(' '), ylabel(' ');
    axes(axh(2)), title(' '), ylabel(' ');
    
    saveas(gcf, fullfile(figsavedir, [savenamebase '_bar.png']));
    
    hh = findobj(gcf, 'Type', 'Text');  delete(hh)
    axes(axh(1)), set(gca, 'FontSize', 28);
    axes(axh(2)), set(gca, 'FontSize', 28);
    saveas(gcf, fullfile(figsavedir, [savenamebase '_bar_clean.png']));
    
end


%% Show montages (thresholded) and surface
% ----------------------------------------------------------------------------

w = threshold(w, .05, 'unc');

o2 = removeblobs(o2);
o2 = addblobs(o2, region(w), 'trans', 'splitcolor', {[0 0 1] [.3 .8 1] [1 .5 0] [1 1 0]});
o2 = addblobs(o2, region(w), 'color', 'k', 'outline');

axes(o2.montage{2}.axis_handles(1))
savename = [savenamebase '_montage_unc05'];
saveas(gcf, fullfile(figsavedir, [savename '.png']));
drawnow, snapnow

w = threshold(w, .05, 'fdr');

o2 = removeblobs(o2);
o2 = addblobs(o2, region(w), 'trans', 'splitcolor', {[0 0 1] [.3 .8 1] [1 .5 0] [1 1 0]});
o2 = addblobs(o2, region(w), 'color', 'k', 'outline');

axes(o2.montage{2}.axis_handles(1))
savename = [savenamebase '_montage_fdr05'];
saveas(gcf, fullfile(figsavedir, [savename '.png']));
drawnow, snapnow

r = region(w);  % still FDR .05

if r(1).numVox ~= 0
    create_figure('surface');
    surface(r, 'foursurfaces', 'color_upperboundpercentile', 85, 'color_lowerboundpercentile', 15);
    
    savename = [savenamebase 'surface_fdr05'];
    saveas(gcf, fullfile(figsavedir, [savename '.png']));
    drawnow, snapnow
    
else
    disp('No significant surface results to plot');
end

end % function
