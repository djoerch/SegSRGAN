#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Aug  4 16:09:24 2020

@author: quentin
"""


import keras.backend as K
import numpy as np


########### loss component to GAN : 
    
def wasserstein_loss(y_true, y_pred):
    """Calculates the Wasserstein loss for a sample batch.
    The Wasserstein loss function is very simple to calculate. In a standard GAN, the discriminator
    has a sigmoid output, representing the probability that samples are real or generated. In Wasserstein
    GANs, however, the output is linear with no activation function! Instead of being constrained to [0, 1],
    the discriminator wants to make the distance between its output for real and generated samples as large as possible.
    The most natural way to achieve this is to label generated samples -1 and real samples 1, instead of the
    0 and 1 used in normal GANs, so that multiplying the outputs by the labels will give you the loss immediately.
    Note that the nature of this loss means that it can be (and frequently will be) less than 0."""
    return K.mean(y_true * y_pred)


def gradient_penalty_loss(y_true, y_pred, averaged_samples, gradient_penalty_weight):
    """Calculates the gradient penalty loss for a batch of "averaged" samples.
    In Improved WGANs, the 1-Lipschitz constraint is enforced by adding a term to the loss function
    that penalizes the network if the gradient norm moves away from 1. However, it is impossible to evaluate
    this function at all points in the input space. The compromise used in the paper is to choose random points
    on the lines between real and generated samples, and check the gradients at these points. Note that it is the
    gradient w.r.t. the input averaged samples, not the weights of the discriminator, that we're penalizing!
    In order to evaluate the gradients, we must first run samples through the generator and evaluate the loss.
    Then we get the gradients of the discriminator w.r.t. the input averaged samples.
    The l2 norm and penalty can then be calculated for this gradient.
    Note that this loss function requires the original averaged samples as input, but Keras only supports passing
    y_true and y_pred to loss functions. To get around this, we make a partial() of the function with the
    averaged_samples argument, and use that for model training."""
    # first get the gradients:
    #   assuming: - that y_pred has dimensions (batch_size, 1)
    #             - averaged_samples has dimensions (batch_size, nbr_features)
    # gradients afterwards has dimension (batch_size, nbr_features), basically
    # a list of nbr_features-dimensional gradient vectors
    gradients = K.gradients(y_pred, averaged_samples)[0]
    # compute the euclidean norm by squaring ...
    gradients_sqr = K.square(gradients)
    #   ... summing over the rows ...
    gradients_sqr_sum = K.sum(gradients_sqr,
                              axis=np.arange(1, len(gradients_sqr.shape)))
    #   ... and sqrt
    gradient_l2_norm = K.sqrt(gradients_sqr_sum)
    # compute lambda * (1 - ||grad||)^2 still for each single sample
    gradient_penalty = gradient_penalty_weight * K.square(1 - gradient_l2_norm)
    # return the mean as loss over all the batch samples
    return K.mean(gradient_penalty)

############# Component of reconstruction loss : 
    
# All the studied cas here take as loss function for the SR reconstruction the charbonnier loss : 
    
def charbonnier_loss(y_true, y_pred):
    """
    https://en.wikipedia.org/wiki/Huber_loss
    """
    epsilon = 1e-3
    diff = y_true - y_pred
    loss = K.mean(K.sqrt(K.square(diff)+epsilon*epsilon), axis=-1)
    return K.mean(loss)

def Dice_loss(y_true, y_pred):

    SR_loss = charbonnier_loss(y_true[:,0],y_pred[:,0])
    smooth = 1

    intersection = 2 * K.sum(y_true[:,1:] * y_pred[:,1:],axis=(0,2,3,4))+ smooth
    denominator = K.sum( y_pred[:,1:], axis=(0,2,3,4)) +  K.sum(y_true[:,1:],axis=(0,2,3,4)) + smooth
   
    dice_loss_per_class = 1 - intersection / denominator
    
    dice_loss = K.mean(dice_loss_per_class)
    
    loss = dice_loss + SR_loss
    
    return loss


class Reconstruction_loss_function :
    
    def __init__(self,loss_name = "charbonnier") : 
        self.loss_name = loss_name
        
    def get_loss_function(self):
        
        if self.loss_name == "charbonnier" : 
            
            print("the charbonnier loss function is the reconstruction function that will be used")
            
            loss_function = staticmethod(charbonnier_loss).__func__
            
        if self.loss_name == "dice":
            
            print("the dice loss function is the reconstruction function that will be used")
            
            loss_function = staticmethod(Dice_loss).__func__
        return loss_function
            

        
        

