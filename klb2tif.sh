#!/bin/bash

if [ -f ~/.bash_profile ]; then 
    source ~/.bash_profile;
fi

conda activate segmentation
python klb2tif.py $1
conda deactivate
