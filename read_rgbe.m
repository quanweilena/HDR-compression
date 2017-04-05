function [img_input_rgb, dim1, dim2] = read_rgbe(filename)

fid = fopen(filename,'r');

%is it a RGBE file?
line = fgetl(fid);
if(isempty(strfind(line,'#?')))
    fclose(fid);
    return;
end

line = fgetl(fid);
RLE = 0;
exposure = 1.0;
gamma = 1.0;

while(~isempty(line))
    %Properties of the RGBE image:
    
    %Compression format
	if(~isempty(strfind(line,'FORMAT=')))
       if(~isempty(strfind(line,'32-bit_rle_rgbe')))
           RLE = 1;
       end
    end
    
    %Gamma
    lst = strfind(line,'GAMMA=');
	if(~isempty(lst))
        gamma = str2double(line((lst(1)+7):end));
    end    
    
    %Exposure
    lst = strfind(line,'EXPOSURE=');
	if(~isempty(lst))
        exposure = str2double(line((lst(1)+9):end));
    end
    line = fgetl(fid);
end

%reading the height and the width of the image
[len, count] = fscanf(fid,'-Y %d +X %d',2);
line = fgetl(fid);
%[retChar, count] = fread(fid,1,'uint8');

%reading pixels...
[tmpImg, count] = fread(fid,inf,'uint8');

height = len(1);
width  = len(2);

%uncompressed?
if(~RLE||(count==(width*height*4)))
    tmpImg2 = zeros(width,height,4);
    for i=1:4
        tmpImg2(:,:,i) = reshape(tmpImg(i:4:(width*height*4)),width,height);
    end
    
    %from RGBE to Float
    tmpImg = RGBE2float(tmpImg2);   
    imgOut = zeros(height,width,3);
    for i=1:3
        imgOut(:,:,i) = tmpImg(:,:,i)';   
    end    
else
    %RLE decompression...
    imgRGBE = zeros(height,width,4);

    buffer = [];

    c = 5;
    %decompression of each line
    for i=1:height
        %decompression of each RGBE channel
        for j=1:4 
            k = 1;            
            %decompression of a single channel line
            while(k<=width)
                num = tmpImg(c);
                if(num>128)
                    num = num-128;                   
                    buffer(k:k+num-1,j) = tmpImg(c+1);

                    c = c+2;
                    k = k+num;
                else
                    buffer(k:k+num-1,j) = tmpImg((c+1):c+num);
                    
                    c = c+num+1;
                    k = k+num;
                end
            end
        end
        c = c+4;
        imgRGBE(i,:,:) = reshape(buffer,1,width,4);
    end
end
fclose(fid);

% hdr_info = struct('exposure', exposure, 'gamma', gamma);

r=imgRGBE(:,:,1);
g=imgRGBE(:,:,2);
b=imgRGBE(:,:,3);
e=imgRGBE(:,:,4);
dim=size(imgRGBE);
for i=1:dim(1)
    for j=1:dim(2)
        R(i,j)=r(i,j)*2^(e(i,j)-128-8);
        G(i,j)=g(i,j)*2^(e(i,j)-128-8);
        B(i,j)=b(i,j)*2^(e(i,j)-128-8);
    end
end
R=reshape(R.*255,1,dim(1)*dim(2));
G=reshape(G.*255,1,dim(1)*dim(2));
B=reshape(B.*255,1,dim(1)*dim(2));
% dim1=double(dim(1));
% dim2=double(dim(2));
dim1=dim(1);
dim2=dim(2);
img_input_rgb=[R;G;B]; 

end