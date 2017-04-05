function img_rgb_out=run(img_input_rgb, dim1, dim2)

%Transmission Matrics Might Be Used
M_sRGB2XYZ=[0.4124 0.2127 0.0193;0.3576 0.7152 0.1192;0.1805 0.0722 0.9504];
M_XYZ2RGB=[0.8562 0.3372 -0.1934;-0.8360 1.8327 0.0033;0.0357 -0.0496 1.0112];
M_CAT02=[0.7328 0.4296 -0.1624;-0.7036 1.6975 0.0061;0.0030 0.0136 0.9834];
M_HPE=[0.38971 0.68898 -0.07868;-0.22981 1.18340 0.04641;0.0 0.0 1.0];
M_H_D65=[0.4002 0.7075 -0.0807;-0.2280 1.1500 0.0612;0.0000 0.0000 0.9184];
M_IPT=[0.4000 0.4000 0.2000;4.4550 -4.8510 0.3960;0.8056 0.3572 -1.1628];

%D65 White
D65_xyz=[95.05;100.00;108.90];

%Read Image
img_input_xyz=M_sRGB2XYZ'*img_input_rgb;

%Test Part
img_inputrgb_test=display_xyz(img_input_xyz,dim1,dim2);
img_inputrgb_test=uint8(img_inputrgb_test);
figure;
imshow(img_inputrgb_test);  %pic1

%Bilateral Filter
[img_base_xyz,img_detail_xyz]=bilateralfiter(img_input_xyz,dim1,dim2);

%%Test Part
img_base_rgb_test=display_xyz(img_base_xyz,dim1,dim2);
img_base_rgb_test=uint8(img_base_rgb_test);
figure;
imshow(img_base_rgb_test);  %pic2

%%Test Part
img_detail_rgb_test=display_xyz(img_detail_xyz,dim1,dim2);
img_detail_rgb_test=uint8(img_detail_rgb_test);
figure;
imshow(img_detail_rgb_test);  %pic3

%Blur
% [img_white_xyz_chro,img_white_xyz_tone]=white(img_input_xyz,dim1,dim2);
white_test = iCAM06_blur(img_input_xyz,4,dim1,dim2);

% %Test Part
% img_white_rgb_chro_test=display_xyz(white_test,dim1,dim2);
% img_white_rgb_chro_test=uint8(img_white_rgb_chro_test);
% figure;
% imshow(img_white_rgb_chro_test);  %pic4
% 
% %Test Part
% img_white_rgb_tone_test=display_xyz(white_test,dim1,dim2);
% img_white_rgb_tone_test=uint8(img_white_rgb_tone_test);
% figure;
% imshow(img_white_rgb_tone_test);  %pic5

%Chromatic Adaptation
img_xyz_ca=chromaticadaptation(img_base_xyz,white_test);

%Test Part
img_rgb_ca_test=display_xyz(img_xyz_ca,dim1,dim2);
img_rgb_ca_test=uint8(img_rgb_ca_test);
figure;
imshow(img_rgb_ca_test);  %pic6

%Tone Compression
img_tc_xyz=tonecompression(img_xyz_ca,white_test);

%Test Part
img_tc_rgb_test=display_xyz(img_tc_xyz,dim1,dim2);
img_tc_rgb_test=uint8(img_tc_rgb_test);
figure;
imshow(img_tc_rgb_test);  %pic7

%Detail Adjustment
img_detail_xyz_new=detailadjustment(img_base_xyz,img_detail_xyz);

%%Test Part
img_detail_rgb_test=display_xyz(img_detail_xyz_new,dim1,dim2);
img_detail_rgb_test=uint8(img_detail_rgb_test);
figure;
imshow(img_detail_rgb_test);  %pic8

%Combination
img_xyz_co=img_tc_xyz.*img_detail_xyz_new./255;

%%Test Part
img_rgb_co_test=display_xyz(img_xyz_co,dim1,dim2);
img_rgb_co_test=uint8(img_rgb_co_test);
figure;
imshow(img_rgb_co_test);  %pic9

%IPT Transformation
% img_xyz_out=ipt(img_xyz_co, img_base_xyz);
img_xyz_co_new(:,:,1)=reshape(img_xyz_co(1,:),dim1,dim2);
img_xyz_co_new(:,:,2)=reshape(img_xyz_co(2,:),dim1,dim2);
img_xyz_co_new(:,:,3)=reshape(img_xyz_co(3,:),dim1,dim2);
img_base_xyz_new(:,:,1)=reshape(img_base_xyz(1,:),dim1,dim2);
img_base_xyz_new(:,:,2)=reshape(img_base_xyz(2,:),dim1,dim2);
img_base_xyz_new(:,:,3)=reshape(img_base_xyz(3,:),dim1,dim2);
img_xyz_out_new=iCAM06_IPT(img_xyz_co_new, img_base_xyz_new,1.5);
img_xyz_out(1,:)=reshape(img_xyz_out_new(:,:,1),1,dim1*dim2);
img_xyz_out(2,:)=reshape(img_xyz_out_new(:,:,2),1,dim1*dim2);
img_xyz_out(3,:)=reshape(img_xyz_out_new(:,:,3),1,dim1*dim2);


%Output
img_rgb_out=display_xyz(img_xyz_out,dim1,dim2);

%Display
figure;
img_rgb_out=uint8(img_rgb_out);
imshow(img_rgb_out);