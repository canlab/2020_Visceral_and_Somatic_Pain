function visceral_compare_groups(y, indic, covs, ydescrip, studynames, plotcolors, varargin)
% visceral_compare_groups(y, indic, covs, ydescrip, studynames, plotcolors, varargin)
%
% Two-sample t-test and Wilcoxon rank sum test on two groups
% y is data to compare (any brain/outcome/stimulus measure of interest)
% ydescrip is descriptive name for plot axis
% indic is columns with indicators for group status
% - uses only cases belonging to one group or another
% - eliminates other cases for purposes of this test
% covs : If entered, also robust stats
% - controls for covariates
% - plots groups residualized with respect to covariates
% colors
% - cell array of colors


wh = any(indic, 2);
group_codes = double(indic(:, 1)) - double(indic(:, 2));
group_codes = group_codes(wh);

y = y(wh);
if ~isempty(covs)
    covs = covs(wh, :);
end

indic = indic(wh, :);

for i = 1:2
    y_by_study{i} = y(indic(:, i));
end

disp(ydescrip)

% generic - does not just work for NPS, but any variable...so use it:
axh = plot_NPS_compare_two_groups(y_by_study, studynames, plotcolors);

subplot(1, 2, 1); title(ydescrip); ylabel(ydescrip);
subplot(1, 2, 2); title(' '); ylabel(ydescrip);

drawnow, snapnow

if ~isempty(covs)
    
    covnames = [];
    if length(varargin) > 0, covnames = varargin{1}; end
    
    if isempty(covnames)
        for i = 1:size(covs, 2)
            covnames{i} = 'Cov';
        end
    end
    
    fprintf('%s: Robust, controlling covs\n', ydescrip);
    
    X = [group_codes covs];
    
    [b, regressionstats_rob] = robustfit(X, y);
    glm_table(regressionstats_rob, [{'Group'} covnames], b);
    
end

end % function

