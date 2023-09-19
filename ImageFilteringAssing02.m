%
%   ELG 5163 Assignment 2 - ANALYSIS OF IMAGE FILTERING AND EDGE DETECTION METHODS
%   Jana Rusrus [#300205310]
%
clear, clc, close all

%% --------------- Input --------------- %% 
img1 = imread('licenceplateBW.jpg');      % load the image
figure(); imshow(img1)
title('licenceplate(Original)')
% imwrite(img1, 'plots/0_licenceplate_Original.jpg')

img2 = imread('mountainBW.jpg');
figure(); imshow(img2)
title('mountain(Original)')
% imwrite(img2, 'plots/0_mountain_Original.jpg')

% Noisy Images
gnoisy1 = imnoise(img1, 'gaussian', 0.02);  % add gaussian noise 
figure(); imshow(gnoisy1)
title('licenceplate(with gaussian noise)')
% imwrite(gnoisy1, 'plots/1_licenceplate_withGaussian.jpg')

gnoisy2 = imnoise(img2, 'gaussian', 0.02);
figure(); imshow(gnoisy2)
title('mountain with gaussian noise')
% imwrite(gnoisy2, 'plots/1_mountain_withGaussian.jpg')

snoisy1 = imnoise(img1, 'salt & pepper', 0.05);  % add salt & pepper noise 
figure(); imshow(snoisy1)
title('licenceplate with salt and pepper noise')
% imwrite(snoisy1, 'plots/2_licenceplate_withSaltPepper.jpg')

snoisy2 = imnoise(img2, 'salt & pepper', 0.05);
figure(); imshow(snoisy2)
title('mountain with salt and pepper noise')
% imwrite(snoisy2, 'plots/2_mountain_withSaltPepper.jpg')


%% --------------- Define the mask filters  --------------- %% 
k_avg3 = ones(3,3)/9;           % define 3*3 mean filter (flat)
k_avg7 = ones(7,7)/49;          % define 7*7 mean filter

k_dir_3 = [1;2;1] * [1,2,1] / 16;
k_dir_7 = [1;2;4;8;4;2;1] * [1,2,4,8,4,2,1] / 484;

k_gauss = round(fspecial('gaussian', [7 7],1.412) * 1115) / 1115;

%% --------------- For Image 1  --------------- %% 
% Appply the flat mean filters
avg3_gauss = imfilter(gnoisy1, k_avg3); % apply 3*3 mean filter on the gaussian noisy image
figure(); imshow(avg3_gauss)
title('The flat(3*3) filter applied on licenceplate with gaussian noise')
% imwrite(avg3_gauss, 'plots/3_licenceplate_avg3Gauss.jpg')

avg3_salt = imfilter(snoisy1, k_avg3); % apply 
figure(); imshow(avg3_salt)
title('The flat(3*3) filter applied on licenceplate with salt&pepper noise')
% imwrite(avg3_salt, 'plots/4_licenceplate_avg3Salt.jpg')


avg7_gauss = imfilter(gnoisy1, k_avg7); % apply 7*7 mean filter on the gaussian noisy image
figure(); imshow(avg7_gauss)
title('The flat(7*7) filter applied on licenceplate with gaussian noise')
% imwrite(avg7_gauss, 'plots/5_licenceplate_avg7Gauss.jpg')

avg7_salt = imfilter(snoisy1, k_avg7); % apply 
figure(); imshow(avg7_salt)
title('The flat(7*7) filter applied on licenceplate with salt&pepper noise')
% imwrite(avg7_salt, 'plots/6_licenceplate_avg7Salt.jpg')

% Apply the directional avg3 
dir_gaus3 = imfilter(gnoisy1, k_dir_3);
figure(); imshow(dir_gaus3)
title('The directional Avg(3*3) filter applied on licenceplate with gaussian noise')
% imwrite(dir_gaus3, 'plots/7_licenceplate_dir3Gaus.jpg')

dir_salt3 = imfilter(snoisy1, k_dir_3);
figure(); imshow(dir_salt3);
title('The directional Avg(3*3) filter applied on licenceplate with salt&pepper noise')
% imwrite(dir_salt3, 'plots/8_licenceplate_dir3Salt.jpg')

% Apply the directional avg7 
dir_gaus7 = imfilter(gnoisy1, k_dir_7);
figure(); imshow(dir_gaus7)
%title('The directional Avg(7*7) filter applied on licenceplate with gaussian noise')
% imwrite(dir_gaus7, 'plots/9_licenceplate_dir7Gaus.jpg')

dir_salt7 = imfilter(snoisy1, k_dir_7);
figure(); imshow(dir_salt7)
title('The directional Avg(7*7) filter applied on licenceplate with salt&pepper noise')
% imwrite(dir_salt7, 'plots/10_licenceplate_dir7Salt.jpg')

% Apply the Gaussian Filter
gauss1 = imfilter(gnoisy1, k_gauss);
figure(); imshow(gauss1)
title('The Gaussian Filter applied on licenceplate with gaussian noise')
% imwrite(gauss1, 'plots/11_licenceplate_gaussOngauss.jpg')

gauss2 = imfilter(snoisy1, k_gauss);
figure(); imshow(gauss2)
title('The Gaussian Filter applied on licenceplate with salt&pepper noise')
% imwrite(gauss2, 'plots/12_licenceplate_gaussOnSalt.jpg')

% Apply the Meadian Filter
km = medfilt2(snoisy1,[3 3]);     %  3*3 median filter
figure(); imshow(km)
title('The Meadian Filter applied on licenceplate with salt&pepper noise')
% imwrite(km, 'plots/13_licenceplate_Median3OnSalt.jpg')

km2 = medfilt2(gnoisy1,[3 3]);  
figure(); imshow(km2)
title('The Meadian Filter applied on licenceplate with gaussian noise')
% imwrite(km2, 'plots/14_licenceplate_Median3OnGauss.jpg')


%% --------------- For Image 2  --------------- %% 
% Appply the flat mean filters
avg3_gauss2 = imfilter(gnoisy2, k_avg3); % apply 3*3 mean filter on the gaussian noisy image
figure(); imshow(avg3_gauss2)
title('The flat(3*3) filter applied on mountain with gaussian noise')
% imwrite(avg3_gauss2 , 'plots/3_mountain_avg3Gauss.jpg')

avg3_salt2 = imfilter(snoisy2, k_avg3); % apply 
figure(); imshow(avg3_salt2)
title('The flat(3*3) filter applied on mountain with salt&pepper noise')
% imwrite(avg3_salt2 , 'plots/4_mountain_avg3Salt.jpg')


avg7_gauss2 = imfilter(gnoisy2, k_avg7); % apply 7*7 mean filter on the gaussian noisy image
figure(); imshow(avg7_gauss2)
title('The flat(7*7) filter applied on mountain with gaussian noise')
% imwrite(avg7_gauss2 , 'plots/5_mountain_avg7Gauss.jpg')

avg7_salt2 = imfilter(snoisy2, k_avg7); % apply 
figure(); imshow(avg7_salt2)
title('The flat(7*7) filter applied on mountain with salt&pepper noise')
% imwrite(avg7_salt2 , 'plots/6_mountain_avg7Salt.jpg')

% Apply the directional avg3 
dir2_gaus3 = imfilter(gnoisy2, k_dir_3);
figure(); imshow(dir2_gaus3)
title('The directional Avg(3*3) filter applied on mountain with gaussian noise')
% imwrite(dir2_gaus3, 'plots/7_mountain_dir3Gaus.jpg')

dir2_salt3 = imfilter(snoisy2, k_dir_3);
figure(); imshow(dir2_salt3)
title('The directional Avg(3*3) filter applied on mountain with salt&pepper noise')
% imwrite(dir2_salt3, 'plots/8_mountain_dir3Salt.jpg')

% Apply the directional avg7 
dir2_gaus7 = imfilter(gnoisy2, k_dir_7);
figure(); imshow(dir2_gaus7)
title('The directional Avg(7*7) filter applied on mountain with gaussian noise')
% imwrite(dir2_gaus7, 'plots/9_mountain_dir7Gaus.jpg')


dir2_salt7 = imfilter(snoisy2, k_dir_7);
figure(); imshow(dir2_salt7)
title('The directional Avg(7*7) filter applied on mountain with salt&pepper noise')
% imwrite(dir2_salt7, 'plots/10_mountain_dir7Salt.jpg')

% Apply the Gaussian Filter
gauss3 = imfilter(gnoisy2, k_gauss);
figure(); imshow(gauss3)
title('The Gaussian Filter applied on mountain with gaussian noise')
% imwrite(gauss3, 'plots/11_mountain_gaussOngauss.jpg')

gauss4 = imfilter(snoisy2, k_gauss);
figure(); imshow(gauss4)
title('The Gaussian Filter applied on licenceplate with salt&pepper noise')
% imwrite(gauss4, 'plots/12_mountain_gaussOnSalt.jpg')

% Apply the Meadian Filter
kms2 = medfilt2(snoisy2,[3 3]);     %  3*3 median filter
figure(); imshow(kms2)
title('The Meadian Filter applied on mountain with salt&pepper noise')
% imwrite(kms2, 'plots/13_mountain_Median3OnSalt.jpg')

kmg2 = medfilt2(gnoisy2,[3 3]);  
figure(); imshow(kmg2)
title('The Meadian Filter applied on mountain with gaussian noise')
% imwrite(kmg2, 'plots/14_mountain_Median3OnGauss.jpg')


%% --------------- Sobel for the first Image  --------------- %% 
Sobl.iorig = edge(img1,'sobel'); %Sobel edges on original
figure();imshow(Sobl.iorig);
title('sobel On Original');
% imwrite(Sobl.iorig, 'plots/15_licenceplate_sobelOnOriginal.jpg')

Sobl.igauss = edge(gnoisy1,'sobel'); %Sobel edges on gaussian noisy
figure();imshow(Sobl.igauss);
title('sobel On gaussian noise');
% imwrite(Sobl.igauss, 'plots/16_licenceplate_sobelOngaussnoise.jpg')

Sobl.isalt = edge(snoisy1,'sobel'); %Sobel edges on salt noisy 
figure();imshow(Sobl.isalt);
title('sobel On salt noise');
% imwrite(Sobl.isalt, 'plots/17_licenceplate_sobelOnsaltnoise.jpg')

Sobl.igausfilter = edge(gauss1,'sobel'); %Sobel edges on gaussian filter
figure();imshow(Sobl.igausfilter);
title('sobel On gaussian filter');
% imwrite(Sobl.igausfilter, 'plots/18_licenceplate_sobelOngaussfilter.jpg')

Sobl.imed = edge(km,'sobel'); %Sobel edges on median for salt filter
figure(); imshow(Sobl.imed);
title('sobel On median');
% imwrite(Sobl.imed, 'plots/19_licenceplate_sobelOnmedian.jpg')

%% --------------- Sobel for the second image --------------- %% 
Sobl2.i2origin = edge(img2,'sobel');      %Sobel edges on original
figure(); imshow(Sobl2.i2origin);
title('sobel On origin');
% imwrite(Sobl2.i2origin, 'plots/20_mountain_sobelOnorigin.jpg')

Sobl2.i2gauss = edge(gnoisy2,'sobel'); %Sobel edges on gaussian noisy
figure();imshow(Sobl2.i2gauss);
title('sobel On gaussian noise');
% imwrite(Sobl2.i2gauss, 'plots/21_mountain_sobelOngaussnoise.jpg')

Sobl2.i2salt = edge(snoisy2,'sobel'); %Sobel edges on salt noisy 
figure();imshow(Sobl2.i2salt);
title('sobel On salt noise');
% imwrite(Sobl2.i2salt, 'plots/22_mountain_sobelOnsaltnoise.jpg')

Sobl2.i2gausfilter = edge(gauss3,'sobel'); %Sobel edges on gaussian filter
figure();imshow(Sobl2.i2gausfilter);
title('sobel On gaussian filter');
% imwrite(Sobl2.i2gausfilter, 'plots/23_mountain_sobelOngaussfilter.jpg')

Sobl2.i2med = edge(kms2,'sobel'); %Sobel edges on median for salt filter
figure(); imshow(Sobl2.i2med);
title('sobel On median');
% imwrite(Sobl2.i2med, 'plots/24_mountain_sobelOnmedian.jpg')

%% --------------- prewitt for the first Image --------------- %% 
prewit1.Original = edge(img1,'prewitt');
figure();imshow(prewit1.Original);
title('prewitt On original');
% imwrite(prewit1.Original, 'plots/25_licenceplate_prewittOnoriginal.jpg')

prewit1.gaussnoise = edge(gnoisy1,'prewitt');
figure(); imshow(prewit1.gaussnoise);
title('prewitt On gaussian noise ');
% imwrite(prewit1.gaussnoise, 'plots/26_licenceplate_prewittOngauss.jpg')

prewit1.saltynoise = edge(snoisy1,'prewitt');
figure(); imshow(prewit1.saltynoise);
title('prewitt On salt noise');
% imwrite(prewit1.saltynoise, 'plots/27_licenceplate_prewittOnsalt.jpg')

prewit1.gaussf = edge(gauss1,'prewitt');
figure();imshow(prewit1.gaussf);
title('prewitt On gaussian filter');
% imwrite(prewit1.gaussf, 'plots/28_licenceplate_prewittOngaussfilter.jpg')

prewit1.saltf = edge(km,'prewitt');
figure(); imshow(prewit1.saltf);
title('prewitt On median');
% imwrite(prewit1.saltf, 'plots/29_licenceplate_prewittOnmedian.jpg')
%% --------------- prewitt for the second Image --------------- %% 
prewit2.Original = edge(img2,'prewitt');
figure(); imshow(prewit2.Original);
title('prewitt On original');
% imwrite(prewit2.Original, 'plots/30_mountain_prewittOnoriginal.jpg')

prewit2.gaussnoise = edge(gnoisy2,'prewitt');
figure(); imshow(prewit2.gaussnoise);
title('prewitt On gaussian noise');
% imwrite(prewit2.gaussnoise, 'plots/31_mountain_prewittOngauss.jpg')

prewit2.saltynoise = edge(snoisy2,'prewitt');
figure(); imshow(prewit2.saltynoise);
title('prewitt On salt noise');
% imwrite(prewit2.saltynoise, 'plots/32_mountain_prewittOnsalt.jpg')

prewit2.gaussf = edge(gauss3,'prewitt');
figure();imshow(prewit2.gaussf);
title('prewitt On gaussian filter');
% imwrite(prewit2.gaussf, 'plots/33_mountain_prewittOngaussfilter.jpg')

prewit2.saltf = edge(kms2,'prewitt');
figure(); imshow(prewit2.saltf);
title('prewitt On median');
% imwrite(prewit2.saltf, 'plots/34_mountain_prewittOnmedian.jpg')

%% --------------- laplacian for the first Image --------------- %% 
k_lap  = fspecial('laplacian');                              %Create Laplacian filte

laplacian1.Original = imfilter(double(img1),k_lap,'symmetric');      %Laplacian edges
figure(); imshow(laplacian1.Original);
title('laplacian On original');
% imwrite(laplacian1.Original, 'plots/35_licence_laplacianOnoriginal.jpg')

laplacian1.gauss = imfilter(double(gnoisy1),k_lap,'symmetric');
figure(); imshow(laplacian1.gauss);
title('laplacian On gaussian noise');
% imwrite(laplacian1.gauss, 'plots/36_licence_laplacianOngauss.jpg')

laplacian1.salt = imfilter(double(snoisy1),k_lap,'symmetric');
figure(); imshow(laplacian1.salt );
title('laplacian On salt noise');
% imwrite(laplacian1.salt , 'plots/37_licence_laplacianOnsalt.jpg')

laplacian1.gaussfilter  = imfilter(double(gauss1),k_lap,'symmetric');
figure(); imshow(laplacian1.gaussfilter);
title('laplacian On gausian filter');
% imwrite(laplacian1.gaussfilter, 'plots/38_licence_laplacianOngausfilter.jpg')

laplacian1.medianfilter = imfilter(double(km),k_lap,'symmetric');
figure(); imshow(laplacian1.medianfilter);
title('laplacian On median filter');
% imwrite(laplacian1.medianfilter, 'plots/39_licence_laplacianOnmedianfilter.jpg')


%% --------------- laplacian for the second Image --------------- %% 

laplacian2.Original = imfilter(double(img2),k_lap,'symmetric');      %Laplacian edges
figure(); imshow(laplacian2.Original);
title('laplacian On original');
% imwrite(laplacian2.Original, 'plots/40_mountain_laplacianOnoriginal.jpg')

laplacian2.gauss = imfilter(double(gnoisy2),k_lap,'symmetric');
figure(); imshow(laplacian2.gauss);
title('laplacian On gaussian noise');
% imwrite(laplacian2.gauss, 'plots/41_mountain_laplacianOngauss.jpg')

laplacian2.salt = imfilter(double(snoisy2),k_lap,'symmetric');
figure(); imshow(laplacian2.salt );
title('laplacian On salt noise');
% imwrite(laplacian2.salt , 'plots/42_mountain_laplacianOnsalt.jpg')

laplacian2.gaussfilter = imfilter(double(gauss3),k_lap,'symmetric');
figure(); imshow(laplacian2.gaussfilter);
title('laplacianOngausfilter');
% imwrite(laplacian2.gaussfilter, 'plots/43_mountain_laplacianOngausfilter.jpg')

laplacian2.medianfilter = imfilter(double(kms2),k_lap,'symmetric');
figure(); imshow(laplacian2.medianfilter);
title('laplacianOnmedianfilter');
% imwrite(laplacian2.medianfilter, 'plots/44_mountain_laplacianOnmedianfilter.jpg')


%% ---------------  the canny on the first Image --------------- %% 
canny1.original = edge(img1,'canny'); %Canny edge detection on original
figure(); imshow(canny1.original);
title('canny On original');
% imwrite(canny1.original, 'plots/45_licence_cannyOnoriginal.jpg')

canny1.gauss = edge(gnoisy1,'canny'); 
figure(); imshow(canny1.gauss);
title('canny On gaussian noise');
% imwrite(canny1.gauss, 'plots/46_licence_cannyOngauss.jpg')

canny1.salt  = edge(snoisy1,'canny'); 
figure(); imshow(canny1.salt);
title('canny On salt noise');
% imwrite(canny1.salt, 'plots/47_licence_cannyOnsalt.jpg')

canny1.gaussfilter = edge(gauss1,'canny'); %Canny edge detection
figure(); imshow(canny1.gaussfilter);
title('cannyOn gaussian filter');
% imwrite(canny1.gaussfilter, 'plots/48_licence_cannyOngaussfilter.jpg')

canny1.median = edge(km,'canny'); %Canny edge detection 
figure(); imshow(canny1.median);
title('canny On median');
% imwrite(canny1.median, 'plots/49_licence_cannyOnmedian.jpg')

%% ---------------  the canny on the second Image --------------- %% 
canny2.original = edge(img2,'canny'); %Canny edge detection on original
figure(); imshow(canny2.original);
title('canny On original');
% imwrite(canny2.original, 'plots/50_mountain_cannyOnoriginal.jpg')

canny2.gauss = edge(gnoisy2,'canny'); %Canny edge detection on original
figure(); imshow(canny2.gauss);
title('canny On gaussian noise');
% imwrite(canny2.gauss, 'plots/51_mountaon_cannyOngauss.jpg')

canny2.salt  = edge(snoisy2,'canny'); %Canny edge detection on original
figure(); imshow(canny2.salt);
title('canny On salty noise');
% imwrite(canny2.salt, 'plots/52_mountain_cannyOnsalt.jpg')

canny2.gaussfilter = edge(gauss3,'canny'); %Canny edge detection
figure(); imshow(canny2.gaussfilter);
title('Canny On gaussian filter');
% imwrite(canny2.gaussfilter, 'plots/53_mountain_cannyOngaussfilter.jpg')

canny2.median = edge(kms2,'canny'); %Canny edge detection 
figure(); imshow(canny2.median);
title('canny On median filter.');
% imwrite(canny2.median, 'plots/54_mountain_cannyOnmedianfilter.jpg')

