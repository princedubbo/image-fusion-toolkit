function [img_mean,img_var] = variance(img)
% 
img = double(img); 
% Get rows and colums of img 
[r c] = size(img); 
     
% Mean value 
img_mean = mean(mean(img)); 
 
% Variance 
img_var = sqrt(sum(sum((img - img_mean).^2)) / (r * c ));
end