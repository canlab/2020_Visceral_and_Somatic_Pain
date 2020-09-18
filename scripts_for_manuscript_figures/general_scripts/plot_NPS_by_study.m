function axh = plot_NPS_by_study(nps_by_study, studynames, varargin)
% axh = plot_NPS_by_study(nps_by_study, studynames, [colors cell])

create_figure('nps_by_study', 1, 2);
axh(1) = subplot(1, 2, 1);

mycolors = {[.3 .7 .4] [.4 .3 .7] [.4 .3 .7] [.7 .3 .4]};

if length(varargin) > 0
    mycolors = varargin{1};
end

barplot_colored(nps_by_study, 'colors', mycolors, 'XTickLabel', studynames);
ylabel('NPS response');
set(gca, 'FontSize', 18, 'Position', [.05 .11 .45 .815])
axis tight

k = length(nps_by_study);

for i = 1:k
    
    nps_d(i) = mean(nps_by_study{i}) ./ std(nps_by_study{i});
    accuracy(i) = 100 * sum(nps_by_study{i} > 0) ./ length(nps_by_study{i});
    
    ypos = double(mean(nps_by_study{i}) + 1.5 * ste(nps_by_study{i}));
    xpos = i - .3;
    
    text(xpos, ypos, sprintf('d = %3.2f', nps_d(i)), 'FontSize', 18);

    text(xpos+.15, 1, sprintf('%3.0f%%', accuracy(i)), 'FontSize', 18);

end

title('NPS by study');

axh(2) = subplot(1, 2, 2);
fprintf('%s\t', studynames{:})
fprintf('\n-----------------------------------------\n');

barplot_columns(nps_by_study, 'NPS by study', [], 'doind', 'colors', mycolors, 'nofig');
ylabel('NPS response');
set(gca, 'FontSize', 18, 'Position', [.55 .11 .4 .815], 'XTickLabel', studynames)
xlabel(' ');
axis tight

end

