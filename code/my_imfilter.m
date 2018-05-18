function output = my_imfilter(image, filter)
% This function is intended to behave like the built in function imfilter()
% See 'help imfilter' or 'help conv2'. While terms like "filtering" and
% "convolution" might be used interchangeably, and they are indeed nearly
% the same thing, there is a difference:
% from 'help filter2'
%    2-D correlation is related to 2-D convolution by a 180 degree rotation
%    of the filter matrix.

% Your function should work for color images. Simply filter each color
% channel independently.

% Your function should work for filters of any width and height
% combination, as long as the width and height are odd (e.g. 1, 7, 9). This
% restriction makes it unambigious which pixel in the filter is the center
% pixel.

% Boundary handling can be tricky. The filter can't be centered on pixels
% at the image boundary without parts of the filter being out of bounds. If
% you look at 'help conv2' and 'help imfilter' you see that they have
% several options to deal with boundaries. You should simply recreate the
% default behavior of imfilter -- pad the input image with zeros, and
% return a filtered image which matches the input resolution. A better
% approach is to mirror the image content over the boundaries for padding.

% % Uncomment if you want to simply call imfilter so you can see the desired
% % behavior. When you write your actual solution, you can't use imfilter,
% % filter2, conv2, etc. Simply loop over all the pixels and do the actual
% % computation. It might be slow.
% output = imfilter(image, filter);


%%%%%%%%%%%%%%%%
% Your code here
%%%%%%%%%%%%%%%%

% Step0: Initialize
[f_h, f_w] = size(filter);
[img_h, img_w, dim] = size(image);

% Step1: Replicated Boundary Pixels
pad_img = zeros(img_h+2*(f_h-1), img_w+2*(f_w-1), dim);
for d = 1:dim
    pad_img(f_h:end-f_h+1, f_w:end-f_w+1, d) = image(:, :, d);
    for i = 1:f_h-1
        pad_img(i, f_w:end-f_w+1, d) = image(1, :, d);
        pad_img(end-i+1, f_w:end-f_w+1, d) = image(end, :, d);
    end
    for i = 1:f_w-1
        pad_img(f_h:end-f_h+1, i, d) = image(:, 1, d);
        pad_img(f_h:end-f_h+1, end-i+1, d) = image(:, end, d);
    end
    for i = 1:f_h-1
        for j = 1:f_w-1
            pad_img(i, j, d) = image(1, 1, d);
            pad_img(i+f_h+img_h-1, j, d) = image(img_h, 1, d);
            pad_img(i, j+f_w+img_w-1, d) = image(1, img_w, d);
            pad_img(i+f_h+img_h-1, j+f_w+img_w-1, d) = image(img_h, img_w, d);
        end
    end
end

% Step2: Flip the Mask
for i = 1:ceil(f_h/2)
    if (i == ceil(f_h/2))
        for j = 1:floor(f_w/2)
            tmp = filter(i, j);
            filter(i, j) = filter(i, end-j+1);
            filter(i, end-j+1) = tmp;
        end   
    else
        for j = 1:f_w
            tmp = filter(i, j);
            filter(i, j) = filter(end-i+1, end-j+1);
            filter(end-i+1, end-j+1) = tmp;
        end
    end
end

% Step3: Weighted and Sum
output = zeros(size(image));
x = floor(f_w/2);
y = floor(f_h/2);
for d = 1:dim
    for i = 1:img_h
        for j = 1:img_w
            tmp = pad_img(f_h+i-1-y:f_h+i-1+y, f_w+j-1-x:f_w+j-1+x, d) .* filter;
            output(i, j, d) = sum(tmp(:));
        end
    end
end

