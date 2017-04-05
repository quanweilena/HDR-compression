function [img_white_xyz_chro,img_white_xyz_tone]=white(img_input_xyz,dim1,dim2)

mindim=min(dim1,dim2);

filter_gau_chro=fspecial('gaussian',[5,5],mindim);
img_white_xyz_chro=imfilter(img_input_xyz,filter_gau_chro);

filter_gau_tone=fspecial('gaussian',[5,5],mindim/2);
img_white_xyz_tone=imfilter(img_input_xyz,filter_gau_tone);