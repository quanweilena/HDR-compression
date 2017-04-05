function img_xyz_out=ipt(img_xyz_co, img_base_xyz);

M_H_D65=[0.4002 0.7075 -0.0807;-0.2280 1.1500 0.0612;0.0000 0.0000 0.9184];
M_IPT=[0.4000 0.4000 0.2000;4.4550 -4.8510 0.3960;0.8056 0.3572 -1.1628];

gamma=1.5;

img_lms_2=M_H_D65*img_xyz_co;
img_lms_pc=abs(img_lms_2).^0.43;
img_ipt=M_IPT*img_lms_pc;

LA=0.2*img_base_xyz(2,:,:);
k=1./(5*LA+1);
FL = 0.2*k.^4.*(5*LA)+0.1*(1-k.^4).^2.*(5*LA).^(1/3); 
C=sqrt(img_ipt(2,:).^2+img_ipt(3,:).^2);
temp_3=(1.29*C.^2-0.27*C+0.42)./(C.^2-0.31*C+0.42);

img_p=img_ipt(2,:).*((FL+1).^0.2).*temp_3;
img_t=img_ipt(3,:).*((FL+1).^0.2).*temp_3;
img_i=img_ipt(1,:).^gamma;

img_ipt_new=[img_i;img_p;img_t];

img_lms_out=inv(M_IPT)*img_ipt_new;
img_xyz_out=inv(M_H_D65)*img_lms_out;