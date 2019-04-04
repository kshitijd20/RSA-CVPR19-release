%% generate figure for dendrogram from task similarity matrix
function h = save_dendrogram(final_matrix,task_list_labels,save_dir,layer_name)
    semantic_task_list = {'object class', 'scene class','semantic segmentation'};
    ldg_task_list = {'vanishing point','room layout'};
    twod_task_list = {'2D edges','2D keypoints','colorization','inpainting','autoencoding','2D segment','denoising'};
    threed_task_list = {'curvature','Occlusion edges','3D keypoints','reshading', 'z-depth','surface normals','2.5d segment','distance'};
    h = figure
    Z = linkage(final_matrix);
    D = pdist(final_matrix);
    leafOrder = optimalleaforder(Z ,D);
    c = cluster(Z,'maxclust',5);
    %cutoff = median([Z(end-2,3) Z(end-1,3)]);
    dendrogram(Z,'Orientation','left','ColorThreshold','default','Labels',task_list_labels,'Reorder',leafOrder)
    title_=strcat(layer_name,"_dendrogram_","fig5");
    ticklabels = get(gca,'YTickLabel');
    % prepend a color for each tick label
    ticklabels_new = cell(size(ticklabels));
    for i = 1:length(ticklabels)
        if any(strcmp(semantic_task_list,ticklabels{i}))
            ticklabels_new{i} = ['\color{magenta} ' ticklabels{i}];
        elseif any(strcmp(ldg_task_list,ticklabels{i}))
            ticklabels_new{i} = ['\color{red} ' ticklabels{i}];
        elseif any(strcmp(twod_task_list,ticklabels{i}))
            ticklabels_new{i} = ['\color{blue} ' ticklabels{i}];
        elseif any(strcmp(threed_task_list,ticklabels{i}))
            ticklabels_new{i} = ['\color{green} ' ticklabels{i}];
        else
            ticklabels_new{i} = ['\color{yellow} ' ticklabels{i}];
        end
        
    end
    % set the tick labels
    set(gca, 'YTickLabel', ticklabels_new);
    pdf = strcat(save_dir,'/',title_,'.pdf');
    png = strcat(save_dir,'/',title_,'.png');
    eps = strcat(save_dir,'/',title_,'.eps');
    %set(h,'Units','Inches');
    %pos = get(h,'Position');
    %set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3)+0.3, pos(4)+0.3])
    print(h,pdf,'-dpdf','-r300')
    print(h, png,'-dpng','-r300')
    print(h, eps,'-depsc','-r300')
end