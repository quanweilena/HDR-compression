function img_tc_xyz=tonecompression(img_xyz_ca,img_white_xyz_tone)

M_HPE=[0.38971 0.68898 -0.07868;-0.22981 1.18340 0.04641;0.0 0.0 1.0];

img_xyz_ca=img_xyz_ca./255;
img_white_xyz_tone=img_white_xyz_tone./255;

%Cone Response
p=0.75;    %range from 0.6 to 0.85
LA = 0.2*img_white_xyz_tone(2,:);
k=1./(5*LA+1);
FL=0.2*k.^4*5.*LA+0.1*(1-k.^4).^2.*(5*LA).^(1/3);
FL=[FL;FL;FL];
Yw=[img_white_xyz_tone(2,:);img_white_xyz_tone(2,:);img_white_xyz_tone(2,:)];

img_hpe=M_HPE*img_xyz_ca;
temp=(FL.*abs(img_hpe)./Yw).^p;
img_cone_hpe=(400*temp)./(27.13+temp)+0.1;

%Rod Response
LAS=2.26*LA;
j_1=0.00001./(5*LAS/2.26+0.00001);
FLS=3800*j_1.^2.*(5*LAS./2.26)+0.2*(1-j_1.^2).^4.*(5*LAS./2.26).^(1/6);

S=abs(img_xyz_ca(2,:));
Sw=max(5*LA(:));
BS=0.5./(1+0.3*((5*LAS/2.26).*(S/Sw)).^3)+0.5./(1+5*(5*LAS/2.26));
temp_1=(FLS.*S/Sw).^p;
AS=3.05*BS.*((400*temp_1)./(27.13+temp_1))+0.03;

img_rod_hpe=[AS;AS;AS];

%Combination
img_hpe_tc=img_cone_hpe+img_rod_hpe;
img_tc_xyz=inv(M_HPE)*img_hpe_tc;

img_tc_xyz=img_tc_xyz.*255;
