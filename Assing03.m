%
%   ELG 5163 Assignment 3 - MOTION DETECTION IN IMAGE SEQUENCES
%   Jana Rusrus [#300205310]
%
clear, clc, close all

%% Input
I0 = imread('image00.jpg');
I1 = imread('image01.jpg');
I2 = imread('image02.jpg');

%% Calculate the absolute difference of the two images.

temporal = imabsdiff(I0,I1);

threshold = 10/255;

mask= im2bw(temporal, threshold);
a = medfilt2(mask,[5 5]); 
subplot(131),imshow(I0)
subplot(132),imshow(I1)
subplot(133),imshow(a)
%% adaptive background differentiation
BG_intial = I0;
motion = I1 - BG_intial;

if motion >= threshold
    BG1 = BG_intial; 
    
else
    BG1 = I1;
end

subplot(131),imshow(I0)
subplot(132),imshow(I1)
subplot(133),imshow(motion)
%% Output
figure()
imshow(temporal, [])

