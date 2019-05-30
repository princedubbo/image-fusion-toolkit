function I = displayDictionaryElementsAsImage(D, numRows, numCols,X,Y,sortVarFlag,d)
% function I = displayDictionaryElementsAsImage(D, numRows, numCols, X,Y)
% displays the dictionary atoms as blocks. For activation, the dictionary D
% should be given, as also the number of rows (numRows) and columns
% (numCols) for the atoms to be displayed. X and Y are the dimensions of
% each atom.
%d是块结构指示向量


borderSize = 1;
columnScanFlag = 1;
strechEachVecFlag = 1;
showImFlag = 1;

if (isempty(who('X')))
    X = 8;
    Y = 8;
end
if (isempty(who('sortVarFlag')))
    sortVarFlag = 1;
end

numElems = size(D,2);
if (isempty(who('numRows')))
    numRows = floor(sqrt(numElems));
    numCols = numRows;
end
if (isempty(who('strechEachVecFlag'))) 
    strechEachVecFlag = 0;
end
if (isempty(who('showImFlag'))) 
    showImFlag = 1;
end
if (isempty(who('d'))) 
    d=1:numElems;
end
%%% sort the elements, if necessary.
%%% construct the image to display (I)
%% 有些自定义的分块字典，使字典的列数不能整除块的大小
%这样在把字典转换成图片的时候，inex就
m=size(d,2);
while m<numElems
    d(m)=max(d)+1;
    m=m+1;
end
%%
sizeForEachImage = sqrt(size(D,1))+borderSize;
I = zeros(sizeForEachImage*numRows+borderSize,sizeForEachImage*numCols+borderSize,3);
%%% fill all this image in blue,yes
I(:,:,1) = 0;%min(min(D));
I(:,:,2) = 0; %min(min(D));
I(:,:,3) = 1; %max(max(D));

%%% now fill the image squares with the elements (in row scan or column
%%% scan).
[V,indice] = sort(d);
if (strechEachVecFlag)
    for counter = indice
        D(:,counter) = D(:,counter)-min(D(:,counter));
        if (max(D(:,counter)))
            D(:,counter) = D(:,counter)./max(D(:,counter));%归一化
        end
    end
end
%%

if (sortVarFlag)
    vars = var(D);
    [V,indices] = sort(vars');
    indices = fliplr(indices);
    D = [D(:,1:sortVarFlag-1),D(:,indices+sortVarFlag-1)];
    signs = sign(D(1,:));
    signs(find(signs==0)) = 1;
    D = D.*repmat(signs,size(D,1),1);
    D = D(:,1:numRows*numCols);
end

%%
counter=1;
for j = 1:numRows
    for i = 1:numCols
%         if (strechEachVecFlag)
%             D(:,counter) = D(:,counter)-min(D(:,counter));
%             D(:,counter) = D(:,counter)./max(D(:,counter));
%         end
%         if (columnScanFlag==1)
%             I(borderSize+(i-1)*sizeForEachImage+1:i*sizeForEachImage,borderSize+(j-1)*sizeForEachImage+1:j*sizeForEachImage,1)=reshape(D(:,counter),8,8);
%             I(borderSize+(i-1)*sizeForEachImage+1:i*sizeForEachImage,borderSize+(j-1)*sizeForEachImage+1:j*sizeForEachImage,2)=reshape(D(:,counter),8,8);
%             I(borderSize+(i-1)*sizeForEachImage+1:i*sizeForEachImage,borderSize+(j-1)*sizeForEachImage+1:j*sizeForEachImage,3)=reshape(D(:,counter),8,8);
%         else
            % Go in Column Scan:
            if(counter>numel(indice))
                I(borderSize+(j-1)*sizeForEachImage+1:j*sizeForEachImage,borderSize+(i-1)*sizeForEachImage+1:i*sizeForEachImage,1)=reshape(D(:,counter),X,Y);
                I(borderSize+(j-1)*sizeForEachImage+1:j*sizeForEachImage,borderSize+(i-1)*sizeForEachImage+1:i*sizeForEachImage,2)=reshape(D(:,counter),X,Y);
                I(borderSize+(j-1)*sizeForEachImage+1:j*sizeForEachImage,borderSize+(i-1)*sizeForEachImage+1:i*sizeForEachImage,3)=reshape(D(:,counter),X,Y);
            else
                I(borderSize+(j-1)*sizeForEachImage+1:j*sizeForEachImage,borderSize+(i-1)*sizeForEachImage+1:i*sizeForEachImage,1)=reshape(D(:,indice((j-1)*numCols+i)),X,Y);
                I(borderSize+(j-1)*sizeForEachImage+1:j*sizeForEachImage,borderSize+(i-1)*sizeForEachImage+1:i*sizeForEachImage,2)=reshape(D(:,indice((j-1)*numCols+i)),X,Y);
                I(borderSize+(j-1)*sizeForEachImage+1:j*sizeForEachImage,borderSize+(i-1)*sizeForEachImage+1:i*sizeForEachImage,3)=reshape(D(:,indice((j-1)*numCols+i)),X,Y);
            end
%         end
            counter=counter+1;   
    end
end

if (showImFlag) 
    I = I-min(min(min(I)));
    I = I./max(max(max(I)));
    imshow(I,[]);
end
