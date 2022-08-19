#!/bin/bash

if [ -f ~/.bash_profile ]; then 
    source ~/.bash_profile;
fi

conda activate segmentation
roi_convert generate-mask --orig_image $1 --output_format klb
conda deactivate
