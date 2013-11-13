function [ im ] = retinexfunc( img )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
% RETINEX - pset 3
%
% Implement a simple version of the retinex algorithm

%img = mean(imread('blackboard.tiff'),3);

% Derivation filters
clear fn
fn(:,:,1) = [0 0 0; -1 1 0; 0 0 0];
fn(:,:,2) = [0 0 0; -1 1 0; 0 0 0]';

% Derivate
out = convFn(img, fn);

% INSERT YOUR CODE HERE
% Threshold the low derivatives to get rid of small changes
[size1, size2, size3] = size(out);
mean_horiz = 1.0*mean2(abs(out(:,:,1))) %fix threshold for the horizontal derivative matrix
mean_vert = 1.0*mean2(abs(out(:,:,2)))%fix threshold for the vertical derivative matrix
for i=1:size1 %first matrix
    for j=1:size2
        if abs(out(i,j,1)) < mean_horiz
        out(i,j,1) = 0;
        end
    end
end
for i=1:size1 %second matrix
    for j=1:size2
        if abs(out(i,j,2)) < mean_vert
        out(i,j,2) = 0;
        end
    end
end



% Pseudo-inverse (using the trick from Weiss, ICCV 2001; equations 5-7)
im=deconvFn(out,fn);



end

