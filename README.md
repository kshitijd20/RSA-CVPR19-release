# CVPR_RSA_release
code for CVPR paper "Representation Similarity Analysis for Efficient Task Taxonomy and Transfer Learning"

This repo is build upon the code from the [Taskonomy paper](http://taskonomy.stanford.edu/).
#### Step1 RDM creation

1. Switch to taskonomy/taskbank
2. Follow installation instructions and downloading pretrained models
3. Download taskonomy images used for RDM creation [here] (https://drive.google.com/open?id=1IwP1_lfLl88FXq0AvfmYWUtw1Z5e6urT)
4. Move to taskonomy/taskbank/tools directory
5. Run python generate_features_taskonomy_500 --img_dir "path to downloaded image directory" --save_dir "path to save features"
6. Run python create_taskonomy_RDMs_enc_final.py --feat_dir "path to saved features" --save_dir "path to save RDMs"
P.S.: Make sure you have enough space as saved features require lot of space (67 GB).


#### Step2 Install RSA toolbox

Install [RSA tool box] (https://github.com/rsagroup/rsatoolbox)


#### Step3 RSA analysis (generate figures from the paper)

1. Add path to your RSA toolbox directory in RSA_analysis/C_Fig.5 or in matlab path
2. Change rdm_path to path to saved RDMs in RSA_analysis/C_Fig.5
3. Run C_Fig5.m to generate results for Figure 4 and 5 from the paper

The code to generate results for small models and pascal VOC will be released soon. For early access or any other queries please contact kshitijdwivedi93@gmail.com
