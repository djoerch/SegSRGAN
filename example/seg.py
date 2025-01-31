# We recommend to use a virtualenv
#
# $ virtualenv my_test
# $ source ./my_test/bin/active
# $ pip install SegSRGAN

import os
import sys
from pathlib import Path
import importlib

from SegSRGAN.Function_for_application_test_python3 import segmentation

# Find the weight location downloaded via the module import.
wpath_base=importlib.util.find_spec("SegSRGAN").submodule_search_locations[0]
wpath=os.path.join( wpath_base, "weights/Perso_without_data_augmentation" )

# Path to nifti file (TO BE ADAPTED).
input_nii = os.path.join( parent, "<PATH_TO_YOUR_IMAGE_HERE>.nii.gz" )
output_cortex_nii = os.path.join( parent,"cortex.nii.gz" )
output_hr_nii = os.path.join( parent,"SR.nii.gz" )

# Segmentation.
segmentation( input_file_path = input_nii,
              step = 30,
              new_resolution = (0.5,0.5,0.5),
              patch=128,
              path_output_cortex = output_cortex_nii,
              path_output_hr = output_hr_nii,
              weights_path=wpath )


                        
