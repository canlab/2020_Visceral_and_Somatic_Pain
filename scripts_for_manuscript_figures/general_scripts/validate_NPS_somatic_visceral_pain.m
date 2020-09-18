%this script tests the sensitivity and specificity of the NPS across
%studies of pain, cognitive control, and negative emotion from Kragel et al
%2018

%% Load data. This has now been packaged into load_image_set

% files=dir('Study*.nii');
% i=0;P={};
% for s=1:18
%     for ss=1:15
%         i=i+1;
%         P{i}=[files(i).folder '/Study' num2str(s) 'Subject' sprintf('%02d',ss) '.nii'];
%         study(i)=s;
% 
%     end
% end
% dat=fmri_data(P);
% dat.Y=study;

dat = load_image_set('kragel18_alldata');
dat.Y = dat.dat_descrip.Studynumber;

%%
disp('Applying NPS.');

NPS = apply_nps(dat,'cosine_similarity', 'noverbose');

for s = 1:18
    NPS_response{s} = NPS{1}(dat.Y==s);
    %labels{s} = ['Study ' num2str(s)]; 
end

labels = dat.additional_info;

% Get colors

for c=1:18
    
    if c<7
        C{c}=[1 .2 0];
    elseif c>6 & c<13
        C{c}=[.4 .5 .2];
    else
        C{c}=[.1 0 .9];
    end
            
end
%% ROC
vector_data = [];

for i=1:18
    vector_data = [vector_data; NPS_response{i}(:)];
end

ispain = logical([ones(6*15,1);zeros(180,1)]);

create_figure('plot', 1, 3);

subplot(1,3,3)
roc=roc_plot(vector_data,ispain);
set(gca,'fontsize',12)

% Boostrap confidence intervals for effect size
bci = bootci(5000, @cohens_d_2sample, vector_data, ispain);

disp(' ')
fprintf('Threshold for cosine_sim = %3.4f, Cohen''s d(pain vs no) = %3.2f, Bootstrapped CI is [%3.2f %3.2f]\n', ...
        roc.class_threshold, cohens_d_2sample(vector_data, ispain), bci(1), bci(2));
disp(' ')

subplot(1,3,1:2)
barplot_columns(NPS_response,'names',labels,'colors',C,'nofig');
ylabel 'NPS Response (Cosine Similarity)'
hold on; plot([0 19],[roc.class_threshold roc.class_threshold],'k--')