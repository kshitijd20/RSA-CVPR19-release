%%%
%%% This function transforms task similarity matrix according to new labels
%%% This is useful if we wish to create task similarity matrix with rows
%%% and columns clustered according to task type
%%%
function h = create_matrix_labels_switched(similarity_matrix,task_list_labels,task_list_labels_switched)
    similarity_matrix_task_type_labels = zeros(numel(task_list_labels_switched),numel(task_list_labels_switched));
    for i=1:numel(task_list_labels_switched)
        for j=1:numel(task_list_labels_switched)
            i_ = find(strcmp(task_list_labels, task_list_labels_switched{i}));
            j_ = find(strcmp(task_list_labels, task_list_labels_switched{j}));
            similarity_matrix_task_type_labels(i,j)= similarity_matrix(i_,j_);
        end
    end
    h=similarity_matrix_task_type_labels;
end