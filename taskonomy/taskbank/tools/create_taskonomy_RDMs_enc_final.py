import json
import glob
import os
import numpy as np
import datetime
import scipy.io as sio
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
import argparse


#RDM from activations
def create_rdm(layers, task_list, RDM_dir,save_dir):
    fc_task_list = 'class_1000 class_places vanishing_point jigsaw room_layout vanishing_point'
    fc_task_list = fc_task_list.split()
    feedforward_encoder_save_list = 'feedforward_encoder_block1 feedforward_encoder_block2 feedforward_encoder_block3 feedforward_encoder_block4 encoder_output'
    feedforward_encoder_save_list = feedforward_encoder_save_list.split()
    for task in task_list:
        if task in fc_task_list:
            layer_list = feedforward_encoder_save_list
        else:
            layer_list = layers
        for layer in layer_list:
            activations = glob.glob(RDM_dir + "/*" + task +"_"+layer+ ".npy")
            activations.sort()
            print(activations)
            n = len(activations)
            RDM = np.zeros((n,n))
            RDM_filename = task + "_" + layer +".mat"
            feature_0=np.load(activations[0]).ravel()
            print(feature_0.shape,layer,n)
            activations_value = np.zeros((n,feature_0.shape[0]))
            for i in range(n):
                activation = np.load(activations[i])[0,:]
                activation_reshaped = activation.ravel()
                activations_value[i,:]= activation_reshaped
            activations_value = (activations_value - np.mean(activations_value,axis=0))

            for i in range(n):
                #print(activations[i])
                for j in range(n):
                    feature_i=activations_value[i]
                    feature_j=activations_value[j]

                    RDM[i,j] = 1-np.corrcoef(feature_i,feature_j)[0][1]
            sio.savemat(os.path.join(save_dir,RDM_filename),dict(rdm= RDM))
            print(os.path.join(save_dir,RDM_filename),RDM.shape)


def main():
    parser = argparse.ArgumentParser(description='Creates RDM from DNN activations')
    parser.add_argument('-fd','--feat_dir', help='feature directory path', default = "./taskonomy_feats_taskonomy500", type=str)
    parser.add_argument('-sd','--save_dir', help='save directory path', default = "./taskonomy_rdms", type=str)
    args = vars(parser.parse_args())
    if not os.path.exists(args['save_dir']):
        os.makedirs(args['save_dir'])

    args_file = os.path.join(args['save_dir'],'args.json')
    with open(args_file, 'w') as fp:
        json.dump(args, fp, sort_keys=True, indent=4)
    task_list = 'class_1000 autoencoder curvature denoise edge2d edge3d \
    keypoint2d keypoint3d colorization \
    reshade rgb2depth rgb2mist rgb2sfnorm \
    room_layout segment25d segment2d vanishing_point \
    segmentsemantic class_1000 class_places inpainting_whole'
    task_list = task_list.split()
    encoder_save_list = 'encoder_block1 encoder_block2 encoder_block3 encoder_block4 encoder_output'
    encoder_save_list = encoder_save_list.split()

    create_rdm(encoder_save_list, task_list, args['feat_dir'],args['save_dir'])








if __name__ == "__main__":
    main()
