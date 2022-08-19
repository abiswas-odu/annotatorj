echo off
set klb_file=%1
call conda activate segmentation
call roi_convert generate-mask --orig_image %klb_file% --output_format klb
call conda deactivate