clc; clear all;close all;
thermal_img (IMG1) = matfile('Data/images/thermal_image.mat');
visible_img (IMG3) = matfile('Data/images/visible_image.mat');

%%% Select Feature ponts from ICI and FLIR images %%%
%%% Code for manual Image registraiton of FLIR and RGB image %%%
IMG1 = imadjust(double(thermal_img.FLIR_tmp1)./255);
IMG3 = (rgb2gray(visible_img.Logitech_RGB1));
figure;
subplot(1,2,1);imshow(IMG1);
subplot(1,2,2);imshow(IMG3);

%%% Image Registration with IR and RGB Images %%%
movingIMG = IMG1;
fixedIMG = IMG3;
[optimizer, metric] = imregconfig('multimodal');
tform = imregtform(movingIMG, fixedIMG, 'Similarity', optimizer, metric);
regIMG = imwarp(movingIMG, tform,'OutputView',imref2d(size(fixedIMG)));
% figure;imshowpair(regIMG2,fixedIMG);

%%%%%%%%%%%%%%%%% Detect faces in RGB Images %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
faceDet = vision.CascadeObjectDetector('FrontalFaceCART');
faceBox = step(faceDet,IMG3);
drawBox = vision.ShapeInserter('BorderColor','White');
image = step(drawBox, IMG3, int32(faceBox));
% figure;imshow(image);
faceIMG = imcrop(regIMG,faceBox(1,:));
faceRGB = imcrop(IMG3,faceBox(1,:));
% figure;
% subplot(1,2,1);imshow(faceRGB);
% subplot(1,2,2);imshow(faceIMG2);

figure;imshowpair(faceIMG,faceRGB);
movingIMG = faceIMG;
fixedIMG = faceRGB;
[optimizer, metric] = imregconfig('multimodal');
optimizer = registration.optimizer.RegularStepGradientDescent;
metric = registration.metric.MattesMutualInformation;
tform = imregtform(movingIMG,fixedIMG, 'rigid', optimizer, metric);
regIMG = imwarp(movingIMG, tform,'OutputView',imref2d(size(fixedIMG)));
figure;imshowpair(regIMG,fixedIMG);
%%% Image registration using Demon algorithms %%%
movingIMG = faceIMG;
fixedIMG = faceRGB;

[~,Ireg] = imregdemons(movingIMG,fixedIMG);
figure;imshowpair(Ireg,fixedIMG);
figure;imshowpair(Ireg,fixedIMG,'montage');
