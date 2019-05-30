function im_quality = FR_VIF( im_reference,im_distorted )
%FR_VIF Summary of this function goes here
%   Detailed explanation goes here
%path(path,'F:\code\matlabPyrTools');
%path(path,'F:\code\matlabPyrTools\MEX');
path(path,'D:\gao\image processing\程序\Directionlet Enhancement\Dirctionlets\VIF\matlabPyrTools');
path(path,'D:\gao\image processing\程序\Directionlet Enhancement\Dirctionlets\VIF\matlabPyrTools\MEX');
im_quality = vifvec(im_reference,im_distorted);
%rmpath('F:\code\matlabPyrTools');
%rmpath('F:\code\matlabPyrTools\MEX');
rmpath('D:\gao\image processing\程序\Directionlet Enhancement\Dirctionlets\VIF\matlabPyrTools');
rmpath('D:\gao\image processing\程序\Directionlet Enhancement\Dirctionlets\VIF\matlabPyrTools\MEX');