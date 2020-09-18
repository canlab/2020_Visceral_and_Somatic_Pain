function brain_marker_behavior_correlation_controlling_study(x, y, covariates, covnames, description, study_indicator, studynames, markername)
% brain_marker_behavior_correlation_controlling_study(x, y, covariates, covnames, description, study_indicator, studynames, markername)
%
% Correlation between brain marker (x) and outcome (y) controlling for
% covariates, robust and non-robust
%
% description = 'NPS correlations with indiv diffs in pain report';
% x = all_nps;
% y = behdat.vas_stim_vs_nostim; % vas
% covariates = contrastcodes;
% covnames = connames(1:2);
% study_indicator = behdat.newindic;
% markername = 'NPS';
% savename = 'NPS_y_correlation';

%% Correlation with pain report

z = '___________________________________________________';
fprintf('%s\n%s\n%s\n', z, description, z);

fprintf('\n%s\n', 'Overall, controlling for study', z);
disp('Note for NPS and markers: p-values are two-tailed, we have one-tailed hypothesis');

X = [x covariates];
Y = y;
[~, ~, regressionstats] = glmfit(X, Y);
glm_table(regressionstats, [{'NPS'} covnames])

fprintf('\n%s\n', 'Overall, controlling for study, robust fit', z);

[b, regressionstats_rob] = robustfit(X, Y);
glm_table(regressionstats_rob, [{markername} covnames], b);

fprintf('\n%s\n', 'Separate stats for each group', z);

k = size(study_indicator, 2);

for i = 1:k
    
    fprintf('\n%s %s\n%s\n', 'Within each study (robust): ', studynames{i}, z);
    
    X = [x(study_indicator(:, i))];
    Y = y(study_indicator(:, i));
    try
    [b, regressionstats] = robustfit(X, Y);
    glm_table(regressionstats, [{markername}], b);
    catch
        fprintf('\n%s\n', lasterr);
    
    end
end

create_figure('indiv diffs');
if k == 3
%     colors = {[.2 .7 .2] [.8 0 .8] [.2 .2 1] };
colors = {[254,153,41]/255 [217,95,14]/255 [153,52,4]/255 };

elseif k==5
colors={[161,218,180]/255 [65,182,196]/255 [44,127,184]/255 [254,153,41]/255 [37,52,148]/255 };
elseif k == 7 
colors={[161,218,180]/255 [65,182,196]/255 [44,127,184]/255 [37,52,148]/255 [254,153,41]/255 [217,95,14]/255 [153,52,4]/255};

else
colors={[161,218,180]/255 [65,182,196]/255 [44,127,184]/255 [37,52,148]/255 };
end

[r,infostring,sig,h] = plot_correlation_samefig(x, y, [], 'k', 0, 1);


for i = 1:k
    
    hh(i) = plot(x(study_indicator(:, i)), y(study_indicator(:, i)), 'o', 'Color', colors{i}, 'MarkerSize', 8, 'LineWidth', 2);
    
end

% axis tight, axis auto
axis square
xlabel([markername ' Response']);
ylabel('VAS Ratings');
legend(hh, studynames, 'Location', 'Best');


% could do robust
% could see whether y no pain is high for outliers

scn_export_papersetup(400);

% axis tight

end % function


