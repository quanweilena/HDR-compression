function img_xyz_ca=chromaticadaptation(img_base_xyz,img_white_xyz_chro)

M_CAT02=[0.7328 0.4296 -0.1624;-0.7036 1.6975 0.0061;0.0030 0.0136 0.9834];
D65_xyz=[95.05;100.00;108.90];

F=1;
%LA=0.2*80;
LA=0.2*img_base_xyz(2,:);
D=0.3*F*(1-(1/3.6)*exp((-LA-42)/92));

img_lms=M_CAT02*(img_base_xyz);
D65_lms=M_CAT02*D65_xyz;
img_white_lms_chro=M_CAT02*img_white_xyz_chro;
r_c=(D65_lms(1,:).*D./img_white_lms_chro(1,:)+(1-D)).*img_lms(1,:);
g_c=(D65_lms(2,:).*D./img_white_lms_chro(2,:)+(1-D)).*img_lms(2,:);
b_c=(D65_lms(3,:).*D./img_white_lms_chro(3,:)+(1-D)).*img_lms(3,:);
img_lms_ca=[r_c;g_c;b_c];

img_xyz_ca=inv(M_CAT02)*img_lms_ca;