function axh = plot_NPS_compare_two_groups(nps_by_study, studynames, varargin)
% axh = plot_NPS_compare_two_groups(nps_by_study, studynames, [colors cell])

create_figure('nps_by_study', 1, 2);
axh(1) = subplot(1, 2, 1);

mycolors = {[.3 .7 .4] [.4 .3 .7] [.4 .3 .7] [.7 .3 .4]};

if length(varargin) > 0
    mycolors = varargin{1};
end

barplot_colored(nps_by_study, 'colors', mycolors, 'XTickLabel', studynames);
ylabel('NPS response');
set(gca, 'FontSize', 18)
axis tight

k = length(nps_by_study);

if k > 2, error('Use plot_NPS_by_study.m instead.'); end

title('NPS by study');

% t-test.  Could enter covs here.

fprintf('Group differences: Two-sample t-test\n');
fprintf('%s\t', studynames{:})
fprintf('\n-----------------------------------------\n');

[H,p,ci,stats] = ttest2_printout(nps_by_study{1}, nps_by_study{2}, 0); 

P = ranksum(nps_by_study{1}, nps_by_study{2});
fprintf('Wilcoxon rank sum P = %3.4f\n', P);


axh(2) = subplot(1, 2, 2);
fprintf('%s\t', studynames{:})
fprintf('\n-----------------------------------------\n');

barplot_columns(nps_by_study, 'NPS by study', [], 'doind', 'colors', mycolors, 'nofig');
ylabel('NPS response');
set(gca, 'FontSize', 18, 'XTickLabel', studynames)
xlabel(' ');
axis tight

end

