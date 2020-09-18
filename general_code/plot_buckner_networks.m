% Load Bucker Lab 1,000FC masks
% ------------------------------------------------------------------------

names = load('Bucknerlab_7clusters_SPMAnat_Other_combined_regionnames.mat');
img = which('rBucknerlab_7clusters_SPMAnat_Other_combined.img');

mask = fmri_data(img);

networknames = names.rnames(1:7);
k = length(networknames);

newmaskdat = zeros(size(mask.dat, 1), k);

for i = 1:k
    
    wh = mask.dat == i;
    
    nvox(1, i) = sum(wh);
    
    newmaskdat(:, i) = double(wh);
    
    
end

mask.dat = newmaskdat;

%%
o2 = canlab_results_fmridisplay([], 'compact2', 'noverbose');

%%
for i = 1:k
    
    plotmask = mask;
    
    plotmask.dat = plotmask.dat(:, i);

    o2 = removeblobs(o2);
    
    o2 = addblobs(o2, region(plotmask), 'maxcolor', [1 0 0], 'mincolor', [.4 .1 .7]);
    
    drawnow
    
    scn_export_papersetup(800);
    
    saveas(gcf, fullfile(pwd, ['bucknerlab' networknames{i} '.png']));
    
end
