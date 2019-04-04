function h = C_Fig5(rdm_dir,save_dir,rsa_dir)
    %%
    % function to generate Figure 4,5,6 of CVPR submission i.e.
    % Task similarity matrix  and Dendrograms for different blocks of encoder
    % Inputs:
    % rdm_dir: path to generated rdms from taskonomy models
    % save_dir: path to save the figures
    % rsa_dir: path to rsa toolbox
    % Outputs:
    % The function will generate task similarity matrix, dendrograms and rsa
    % results for each block of each task RDM and save it in the save directory

    % General set up

    % add path to rsa toolbox
    addpath(genpath(rsa_dir));
    returnHere = pwd;
    cd(returnHere)
    userOptions = defineUserOptions;

    % statistical inference
    % userOptions.RDMcorrelationType='Kendall_taua';
    userOptions.RDMcorrelationType='Spearman';
    userOptions.RDMrelatednessTest = 'randomisation';
    userOptions.RDMrelatednessThreshold = 0.05;
    userOptions.RDMrelatednessMultipleTesting = 'none';%'FWE'
    userOptions.candRDMdifferencesTest = 'conditionRFXbootstrap';
    userOptions.candRDMdifferencesMultipleTesting = 'FDR';
    userOptions.plotpValues = '*';
    userOptions.nRandomisations = 10;
    userOptions.nBootstrap = 20;
    userOptions.candRDMdifferencesThreshold = 0.05;
    userOptions.candRDMdifferencesMultipleTesting = 'FDR';


    % Path  RDM directory and save_dir
    rdm_path = rdm_dir;
    save_dir = save_dir; %Results will be saved in Fig5 directory
    mkdir(save_dir);
    userOptions.rootPath = [pwd,filesep,save_dir];
    userOptions.analysisName = 'C_Fig5';
    userOptions.projectName = 'CVPR_RSA';

    % list of tasks and layers
    % task list for reading RDM files
    task_list = { 'autoencoder','class_1000', 'class_places', 'colorization','curvature', 'denoise', 'edge2d', 'edge3d', ...
        'inpainting_whole','keypoint2d', 'keypoint3d', ...
        'reshade', 'rgb2depth', 'rgb2mist', 'rgb2sfnorm','room_layout' , ...
        'segment25d', 'segment2d', 'segmentsemantic', ...
         'vanishing_point'} ;
    % task list with labels of actual tasks
    task_list_labels = { 'autoencoding','object class', 'scene class', 'colorization','curvature', 'denoising', '2D edges', 'Occlusion edges', ...
        'inpainting','2D keypoints', '3D keypoints', ...
        'reshading', 'z-depth', 'distance', 'surface normals','room layout' , ...
        '2.5d segment', '2D segment', 'semantic segmentation', ...
         'vanishing point'} ;
    % task list sorted according to task type for generating task similarity matrices
    task_list_labels_switched = { 'colorization', 'inpainting','autoencoding','denoising','2D keypoints',...
        '2D segment','2D edges','3D keypoints','2.5d segment','curvature',...
        'Occlusion edges','reshading','z-depth','distance','surface normals',...
        'semantic segmentation','object class', 'scene class',...
       'room layout' , 'vanishing point'} ;

    % Task type lists for color coding plots according to task type
    class_task_list = {'class_1000', 'class_places', 'vanishing_point','room_layout'};
    semantic_task_list = {'class_1000', 'class_places','segmentsemantic'};
    ldg_task_list = {'vanishing_point','room_layout'};
    twod_task_list = {'edge2d','keypoint2d','colorization','inpainting_whole','autoencoder','segment2d'};
    threed_task_list = {'curvature','edge3d','keypoint3d','reshade', 'rgb2depth','rgb2sfnorm','segment25d','rgb2mist'};

    % layer list and refined layer list for short text labels
    layer_list = {'encoder_block1','encoder_block2', 'encoder_block3', 'encoder_block4', 'encoder_output'};
    layer_list_refined = {'block1','block2', 'block3', 'block4', 'eoutput'};

    % reading RDMs

    num_samples=500; % number of images to run the RSA analysis (max is 500)

    taskonomy_RDMs = RDM_DNN(task_list,layer_list,layer_list_refined,rdm_path,class_task_list,num_samples);
    taskonomy_RDMs_cell = cell(numel(task_list),numel(layer_list));
    for i=1:numel(task_list)
        for j=1:numel(layer_list)
            taskonomy_RDMs_cell{i,j}=taskonomy_RDMs(i,j);
        end
    end

    % RSA analysis for taskonomy
    layer_RSA =  cell(numel(task_list),numel(layer_list));
    for i = 1:numel(layer_list)
        for j=1:numel(task_list)
            userOptions.figure1filename = strcat(layer_list{i},'_',task_list{j});
            userOptions.figure2filename = strcat(layer_list{i},'_',task_list{j},'_2');

            %function that performs RSA analysis
            layer_RSA{j,i} = rsa.compareRefRDM2candRDMs(taskonomy_RDMs(j,i),taskonomy_RDMs_cell(:,i), userOptions);
        end
    end

    % Saving RSA analysis results into a matrix for later use (takes time to compute)
    %Changing the directory to current directory (as RSA function changes current directory)
    cd(returnHere)
    num_samples_str = int2str(num_samples);
    rsa_results_file_name = strcat(save_dir,"/RSA_analysis_taskonomy_",num_samples_str,".mat");
    save(rsa_results_file_name,'layer_RSA')

    % generating task similarity matrices and dendrograms
    taskonomy_matrix = cell(numel(task_list),numel(task_list));
    for i=1:numel(task_list)
        for j=1:numel(layer_list)
            task_list_matrices{i,j} = strcat(task_list{i},'_',layer_list_refined{j});
        end
    end
    %for loop for generating dendrogram and task similarity matrix for each
    %layer
    for layer=1:numel(layer_list)
        % for loop for generating task similarity matrix from RSA analysis
        % it's important to get correct correlation value as rsa output are
        % sorted the for loop below performs the same
        for i=1:numel(task_list)
            for k=1:numel(layer_RSA{i,layer}.candRelatedness_r)
                labels(k)=layer_RSA{i,layer}.orderedCandidateRDMnames{k};
                rdm_labels(k) = task_list_matrices(k,layer);
            end
            [vals,indices]=intersect(labels,rdm_labels);
            for j=1:numel(task_list)
                taskonomy_matrix{i,j} = layer_RSA{i,layer}.candRelatedness_r(indices(j));
            end
        end
        task_similarity_matrix = cell2mat(taskonomy_matrix);
        % matrix save path
        num_samples_str = int2str(num_samples);
        matrix_file_name =  strcat(save_dir,"/SM_",num_samples_str,'_',layer_list_refined{layer},".mat");

        %switching the labels to cluster the rows of matrix according to task
        %type
        task_similarity_matrix=create_matrix_labels_switched(task_similarity_matrix,task_list_labels,task_list_labels_switched);
        save(matrix_file_name,'task_similarity_matrix')
        save_affinity_matrix(task_similarity_matrix,task_list_labels_switched,save_dir,layer_list_refined{layer})

        %creating and saving dendrogram
        save_dendrogram(task_similarity_matrix,task_list_labels_switched,save_dir,layer_list_refined{layer})
    end
end
