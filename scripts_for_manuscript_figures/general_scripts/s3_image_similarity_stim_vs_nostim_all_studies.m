% similarity of the contrast images to resting-state networks
%get patient group information

%22nd subject (from Grenoble) has one image with all zeros -- exclude
combined_dat.dat=combined_dat.dat(:,[1:21 23:end]);

%
rsfmri_stats = image_similarity_plot(combined_dat, 'average','bucknerlab');
drawnow;snapnow;

nps_stats = image_similarity_plot(combined_dat, 'average','npsplus');
drawnow;snapnow;