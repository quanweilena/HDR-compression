function img_detail_xyz_new=detailadjustment(img_base_xyz,img_detail_xyz)

LA=0.2*img_base_xyz(2,:,:);
k=1./(5*LA+1);
FL=0.2*k.^4*5.*LA+0.1*(1-k.^4).^2.*(5*LA).^(1/3);
temp_2=(FL+0.8).^0.25;
img_detail_xyz_new=(img_detail_xyz).^(repmat(temp_2,[3;1]));