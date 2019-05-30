function psnr = psnr(originalimg, restoredimg)
%PSNR Summary of this function goes here
%   Detailed explanation goes here
%Peak Signal to Noise Ratio (PSNR)∑Â÷µ–≈‘Î±»

md = (originalimg - restoredimg).^2;
mdsize = size(md);
summation = 0;
for  i = 1:mdsize(1)
    for j = 1:mdsize(2)
        summation = summation + abs(md(i,j));
    end
end

psnr = size(originalimg, 1) * size(originalimg, 2) * max(max(originalimg.^2))/summation;
psnr = 10 * log10(psnr);
%}

end

