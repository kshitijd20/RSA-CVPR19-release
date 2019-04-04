%% reading RDMs of DNN layers
function h = RDM_DNN(task_list,layer_list,layer_list_refined,output_path,class_task_list,n_samples)
    semantic_task_list = {'class_1000', 'class_places','segmentsemantic'};
    ldg_task_list = {'vanishing_point','room_layout'};
    twod_task_list = {'edge2d','keypoint2d','colorization','inpainting_whole','autoencoder','segment2d'};
    threed_task_list = {'curvature','edge3d','keypoint3d','reshade', 'rgb2depth','rgb2sfnorm','segment25d','rgb2mist'};
    for i=1:numel(task_list)
        for j=1:numel(layer_list)
            % fifth layer is encoder output which doesnt have feedforward
            % appended to its name so j<5 here 
            if (any(strcmp(class_task_list,task_list{i}))&&j<5) 
                layer_name = strcat('feedforward_',layer_list(j));
            else
                layer_name = layer_list(j);
            end
            
            RDM_path = strcat(output_path,'/',task_list(i),'_',layer_name,'.mat');
            temp=load(RDM_path{1});
            h(i,j).RDM = temp.rdm(1:n_samples,1:n_samples);
            h(i,j).name = strcat(task_list(i),'_',layer_list_refined(j));
            if any(strcmp(semantic_task_list,task_list{i}))
                h(i,j).color = {0,1,0};
            elseif any(strcmp(ldg_task_list,task_list{i}))
                h(i,j).color = {1,0,0};
            elseif any(strcmp(twod_task_list,task_list{i}))
                h(i,j).color = {1,1,0};
            elseif any(strcmp(threed_task_list,task_list{i}))
                h(i,j).color = {0,1,1};
            else
                h(i,j).color = {0,0,1};
            end
            
        end
    end
end