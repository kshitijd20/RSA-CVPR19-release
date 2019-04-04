%% generate figure for similarity matrix with labels
function h = save_affinity_matrix(final_matrix,task_list_labels,save_dir,layer_name)
    semantic_task_list = {'object class', 'scene class','semantic segmentation'};
    ldg_task_list = {'vanishing point','room layout'};
    twod_task_list = {'2D edges','2D keypoints','colorization','inpainting','autoencoding','2D segment','denoising'};
    threed_task_list = {'curvature','Occlusion edges','3D keypoints','reshading', 'z-depth','surface normals','2.5d segment','distance'};
    h = figure
    imagesc(final_matrix);            % Create a colored plot of the matrix values
    colormap(flipud(gray));
    colorbar('Ticks',[min(min(final_matrix)),max(max(final_matrix))],'TickLabels',{'Low','High'})

    set(gca, 'XTick', 1:20, ...                             % Change the axes tick marks
             'XTickLabel', task_list_labels, ...  %   and tick labels
             'YTick', 1:20, ...
             'YTickLabel', task_list_labels, ...
             'TickLength', [0 0]);
    xtickangle(90)
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
    ticklabels = get(gca,'XTickLabel');
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
    set(gca, 'XTickLabel', ticklabels_new);
   
    %set(findall(gcf,'-property','FontSize'),'FontSize',15)

    set(gca,'FontName', 'Arial')
    title_=strcat(layer_name,"_matrix","_affinity");
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