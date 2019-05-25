# CVPR_RSA_release
code for CVPR paper ["Representation Similarity Analysis for Efficient Task Taxonomy and Transfer Learning"](https://arxiv.org/abs/1904.11740)

This repo is build upon the code from the [Taskonomy paper](http://taskonomy.stanford.edu/).
#### Step1 RDM creation

1. Switch to taskonomy/taskbank
2. Follow installation instructions and downloading pretrained models
3. Download taskonomy images used for RDM creation [here](https://drive.google.com/open?id=1IwP1_lfLl88FXq0AvfmYWUtw1Z5e6urT)
4. Change current directory to taskonomy/taskbank/tools directory
5. Run python generate_features_taskonomy_500 --img_dir "path to downloaded image directory" --save_dir "path to save features"
6. Run python create_taskonomy_RDMs_enc_final.py --feat_dir "path to saved features" --save_dir "path to save RDMs"

P.S.: Make sure you have enough space as saved features require lot of space (67 GB).

#### Step2 Download my forked copy of [RSA toolbox](https://github.com/kshitijd20/rsatoolbox)

#### Step3 RSA analysis (generate figures from the paper)

1. Change current directory to RSA_analysis
2. run demo.m after modifying the rdm_dir, rsa_dir, and save_dir paths to corresponding paths in the demo.m to generate results for Figure 4 and 5 from the paper

The code to generate results for small models and pascal VOC will be released soon. For early access or any other queries please contact kshitijdwivedi93@gmail.com
