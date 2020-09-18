%% classify group membership (visceral vs somatic)
rsfmri_stats=image_similarity_plot(combined_dat,'average','mapset','bucknerlab','noplot');

r=[rsfmri_stats.r];
Z=fisherz(r)';
%
% %first 4 studies are visceral %last 3 studies are (somewhat) somatic
Y=somatic;

%% train on rectal 1 and thermal, test on others


trainingIndices=combined_dat.additional_info{1}==2|combined_dat.additional_info{1}==7;
Zsub=Z(trainingIndices,:);
Ysub=Y(trainingIndices,:);

clear b yhat* b_avg b_sample_sub st_sample_sub
% do loocv
indices = crossvalind('Kfold',Ysub,10);
for i = 1:10
    test = (indices == i);
    train = ~test;
    for j=1:7
        b(i,j,:)=glmfit(Zsub(train,j),Ysub(train,:),'binomial','link','logit');
        yhat(test,j)=glmval(squeeze(b(i,j,:)),Zsub(test,j),'logit');
    end
    
    %      [~, b(i,:), intercept, out]= cv_lassopcrmatlab(Zsub(train,:),Ysub(train,:),Zsub(test,:),test);
    %      yhat(test) = intercept + Zsub(test,:) * b(i,:)';
    %      yhat(test) = exp(yhat(test))./(1+exp(yhat(test))); %convert to probabilities
end

% apply to other data
b_avg=squeeze(mean(b));%take average parameters for 10 CV folds
for j=1:7
    [b dev st(j)]=glmfit(Zsub(:,j),Ysub,'binomial');
    b_sample_sub(j)=b(2);
    tv=st(j);
    st_sample_sub(j)=tv.se(2);
    p_sample_sub(j)=tv.p(2);
    yhat_other(:,j)=glmval(b_avg(j,:)',Z(~trainingIndices,j),'logit');

end

yhat=mean(yhat,2);
yhat_other=mean(yhat_other,2);

ROC_train= roc_plot(yhat, Y(trainingIndices), 'color', [.7 .7 .7],'threshold_type','Optimal balanced error rate','noplot');
ROC_test= roc_plot(yhat_other, Y(~trainingIndices), 'color', [.7 .7 .7],'threshold',ROC_train.class_threshold,'noplot');
tY=Y(~trainingIndices);
test_inds=behdat.study(~trainingIndices)==8|behdat.study(~trainingIndices)==3;
ROC_test_thermal= roc_plot(yhat_other(test_inds),tY(test_inds), 'color', [.7 .7 .7],'threshold',ROC_train.class_threshold,'noplot');


figure;
subplot(3,2,1:2)
plot([.75 7.25],[0 0],'k--');hold on;
errorbar(1:size(Z,2),b_sample_sub(:),st_sample_sub(:),'k-','LineWidth',2);
title 'Thermal vs. Rectal Pain Classification'
set(gca,'XLim',[.5 size(Z,2)+.5]);
% set(gca,'YLim',[-30 30]);
set(gca,'XTick',1:size(Z,2));
set(gca,'XTicklabel',rsfmri_stats(1).networknames)
ylabel 'Parameter Estimate';
set(gca,'FontSize',10)

subplot(3,2,4);
hold on; plot([0 1],[0 1],'k-')
ROC= roc_plot(yhat, Ysub==1, 'color', [.7 .7 .7],'threshold_type','Optimal balanced error rate');
set(gca,'FontSize',10)
axis square;
title(['AUROC = ' num2str(ROC.AUC)])

subplot(3,2,3);
CM_sub=confusionmat(yhat>ROC_train.class_threshold,Ysub'==1);
for i=1:length(CM_sub)
    CM_sub(i,:)=CM_sub(i,:)/sum(CM_sub(i,:));
end
imagesc(CM_sub,[0 1]);colorbar;colormap(flipud(gray));
set(gca,'FontSize',10)
title(['Accuracy = ' num2str(ROC.accuracy)])

set(gca,'XTick',1:2)
set(gca,'YTick',1:2)
set(gca,'XTickLabel',{'Rectal' 'Thermal'})
set(gca,'YTickLabel',{'Rectal' 'Thermal'})



%% test proportions for studies against empirical priors in training data
[cross_classification_tbl]=crosstab(yhat_other'>=ROC_test.class_threshold,behdat.study(~trainingIndices));
study_names_subset={'Gastric' 'Rectal 2'  'Vaginal' 'Esophageal' 'Thermal 2'};
mycolors={[161,218,180]/255 [65,182,196]/255 [44,127,184]/255 [254,153,41]/255 [37,52,148]/255 [217,95,14]/255 [153,52,4]/255}; %
sn=[1 3 4 5 8];
study_numbers=combined_dat.additional_info{1}(~trainingIndices);
for s=1:5
    stats_binomial(s)=binotest([zeros(cross_classification_tbl(1,s),1);ones(cross_classification_tbl(2,s),1)],ROC_train.class_threshold);

end

%plot with increasing frequency
[sorted_prop order]=sort([stats_binomial(:).prop]);
study_names_subset=study_names_subset(order);
subplot(3,2,5:6);hold on;
plot([0 5.5],[ROC_train.class_threshold ROC_train.class_threshold],'k--');
errorbar(1:5,sorted_prop,[stats_binomial(order).SE],'k-','Linewidth',2);
ylabel 'Proportion Somatic'
xlabel 'Study'
set(gca,'XTick',1:5)
set(gca,'XTickLabel',study_names_subset)
set(gca,'XLim',[.75 5])
set(gca,'YLim',[0 1])
set(gca,'FontSize',10)
set(gcf,'units','inches','Position',[2 2 7 7])
set(gcf,'color',[1 1 1]);

% export_fig(fullfile(figsavedir,'RSN_somatovisceral_Generalization.png'))
% drawnow; snapnow;

%%
inds=[3 1 4 5 7];
% labels={'Thermal' 'Rectal' studynames{inds}};
test_studies=combined_dat.additional_info{1}(~trainingIndices);
test_studies(test_studies==8)=7;
output{1}=yhat(Ysub==1);
output{2}=yhat(Ysub==0);
for i=1:length(inds)
    output{2+i}=yhat_other(test_studies==inds(i));
end
reorder=[1 2 3 4 5 7 6];
for i=1:length(mycolors); 
    mC(i,:)=mycolors{reorder(i)}; 
end
% 1:length(mycolors)
figure;
violinplot(output,'pointsize',5,'bw',.05,'facecolor',mC([6 2 inds],:),'mc','none','medc','k')
hold on;
view([90 90])
legend off
set(gca,'Visible','off')
set(gcf,'units','inches','Position',[2 2 7 5])
set(gcf,'color',[1 1 1])
% export_fig(fullfile(figsavedir,'RSN_somatovisceral_Generalization_corrected.png'))
drawnow; snapnow;



%% reliability of classification
% 
% 
% for it=1:1000
% trainingIndices=behdat.study==2|behdat.study==7;
% Zsub=Z(trainingIndices,:);
% Ysub=Y(trainingIndices,:);
% 
% clear b yhat* b_avg b_sample_sub st_sample_sub
% % do loocv
% indices = crossvalind('Kfold',Ysub,10);
% for i = 1:10
%     test = (indices == i);
%     train = ~test;
%     for j=1:7
%         b(i,j,:)=glmfit(Zsub(train,j),Ysub(train,:),'binomial','link','logit');
%         yhat(test,j)=glmval(squeeze(b(i,j,:)),Zsub(test,j),'logit');
%     end
%     
%     %      [~, b(i,:), intercept, out]= cv_lassopcrmatlab(Zsub(train,:),Ysub(train,:),Zsub(test,:),test);
%     %      yhat(test) = intercept + Zsub(test,:) * b(i,:)';
%     %      yhat(test) = exp(yhat(test))./(1+exp(yhat(test))); %convert to probabilities
% end
% 
% % apply to other data
% b_avg=squeeze(mean(b));%take average parameters for 10 CV folds
% b_est(it,:)=b_avg(:);
% 
% for j=1:7
%     [b dev st(j)]=glmfit(Zsub(:,j),Ysub,'binomial');
%     b_sample_sub(j)=b(2);
%     tv=st(j);
%     st_sample_sub(j)=tv.se(2);
%     p_sample_sub(j)=tv.p(2);
%     yhat_other(:,j)=glmval(b_avg(j,:)',Z(~trainingIndices,j),'logit');
% 
% end
% yhat=mean(yhat,2);
% yhat_other=mean(yhat_other,2);
% 
% ROC_train(it)= roc_plot(yhat, Y(trainingIndices), 'color', [.7 .7 .7],'threshold_type','Optimal balanced error rate','noplot');
% tY=Y(~trainingIndices);
% test_inds=behdat.study(~trainingIndices)==8|behdat.study(~trainingIndices)==3;
% ROC_test_thermal(it)= roc_plot(yhat_other(test_inds),tY(test_inds), 'color', [.7 .7 .7],'threshold',ROC_train.class_threshold,'noplot');
% 
% 
% ROC(it)= roc_plot(yhat, Ysub==1, 'color', [.7 .7 .7],'threshold_type','Optimal balanced error rate');
% 
% 
% 
% end
% 
% mean(squareform(tril(corr(b_est'),-1)))