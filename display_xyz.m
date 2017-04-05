function img_rgb_out=display_xyz(img_xyz_out,dim1,dim2)

M_sRGB2XYZ=[0.4124 0.2127 0.0193;0.3576 0.7152 0.1192;0.1805 0.0722 0.9504];

img_rgb_out_3=inv(M_sRGB2XYZ')*img_xyz_out;
img_r=img_rgb_out_3(1,:);img_rgb_out(:,:,1)=reshape(img_r,dim1,dim2);
img_g=img_rgb_out_3(2,:);img_rgb_out(:,:,2)=reshape(img_g,dim1,dim2);
img_b=img_rgb_out_3(3,:);img_rgb_out(:,:,3)=reshape(img_b,dim1,dim2);
img_rgb_out(img_rgb_out<0) = 0; img_rgb_out(img_rgb_out>255) = 255;
end