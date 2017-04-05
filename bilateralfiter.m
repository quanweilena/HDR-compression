function [img_base_xyz,img_detail_xyz]=bilateralfiter(img_input_xyz,dim1,dim2)

img_input_xyz=img_input_xyz./255;

img_XX=reshape(img_input_xyz(1,:),dim1,dim2);img_XYZ(:,:,1)=img_XX;
img_YY=reshape(img_input_xyz(2,:),dim1,dim2);img_XYZ(:,:,2)=img_YY;
img_ZZ=reshape(img_input_xyz(3,:),dim1,dim2);img_XYZ(:,:,3)=img_ZZ;

Base = zeros(dim1,dim2,3);
w = 2;  % bilateral filter half-width
sigma_d = floor(max(dim1,dim2)*0.02);
sigma_r = 0.35;  % bilateral filter standard deviations
[X,Y] = meshgrid(-w:w,-w:w);
Gau = exp(-(X.^2+Y.^2)/(2*sigma_d^2));

h_1 = waitbar(0,'Applying bilateral filter...');
set(h_1,'Name','Bilateral Filter Progress');

for i = 1:dim1
   for j = 1:dim2
         % Extract local region.
         iMin = max(i-w,1);
         iMax = min(i+w,dim1);
         jMin = max(j-w,1);
         jMax = min(j+w,dim2);
         I = img_XYZ(iMin:iMax,jMin:jMax,:);
      
         % Compute Gaussian range weights.
         dx = I(:,:,1)-img_XYZ(i,j,1);
         dy = I(:,:,2)-img_XYZ(i,j,2);
         dz = I(:,:,3)-img_XYZ(i,j,3);
         H = exp(-(dx.^2+dy.^2+dz.^2)/(2*sigma_r^2));
      
         % Calculate bilateral filter response.
         F = H.*Gau((iMin:iMax)-i+w+1,(jMin:jMax)-j+w+1);
         norm_F = sum(F(:));
         Base(i,j,1) = sum(sum(F.*I(:,:,1)))/norm_F;
         Base(i,j,2) = sum(sum(F.*I(:,:,2)))/norm_F;
         Base(i,j,3) = sum(sum(F.*I(:,:,3)))/norm_F;        
   end
   waitbar(i/dim1);
end
% Close waitbar.
close(h_1);

%Base Layer
img_base_x=reshape(Base(:,:,1).*255,1,dim1*dim2);
img_base_y=reshape(Base(:,:,2).*255,1,dim1*dim2);
img_base_z=reshape(Base(:,:,3).*255,1,dim1*dim2);
img_base_xyz=[img_base_x;img_base_y;img_base_z];

%Detail Layer
Detail_img=img_XYZ./Base;  %detail layer
img_detail_x=reshape(Detail_img(:,:,1).*255,1,dim1*dim2);
img_detail_y=reshape(Detail_img(:,:,2).*255,1,dim1*dim2);
img_detail_z=reshape(Detail_img(:,:,3).*255,1,dim1*dim2);
img_detail_xyz=[img_detail_x;img_detail_y;img_detail_z];

% M_sRGB2XYZ=[0.4124 0.2127 0.0193;0.3576 0.7152 0.1192;0.1805 0.0722 0.9504];
% img_detail_rgb_test_1=inv(M_sRGB2XYZ')*img_detail_xyz;
% fprintf('%d\n',max(max(img_detail_rgb_test_1)));
