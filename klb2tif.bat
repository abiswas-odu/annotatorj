echo off
set klb_file=%1
call conda activate segmentation
call python klb2tif.py %klb_file%
call conda deactivate