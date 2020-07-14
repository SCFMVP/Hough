clc;
clear;  
clear all;
close all;
% ******************************************************
% auther: later
% time  : 2020/7/9 6:56
% tip   : circles identitfication
% change: 哈夫法
% Todo: 去边框 finished!!
% Todo: 去椒盐噪声 finished!!
% Todo: 准确定位 finished!!
% ******************************************************
% email: latermvp@163.com
% ******************************************************
%% 预处理
I=imread('002.jpg'); 
figure,imshow(I);     title('RGB');   imwrite(I,'1.RGB.jpg','jpg');
% 灰度化
GRAY=rgb2gray(I);     
% Median filtering-中值滤波
GRAY=medfilt2(GRAY,[3 3]);
figure,imshow(GRAY);    title('GRAY');  imwrite(GRAY,'2.GRAY.jpg','jpg');
% 二值化
threshold=graythresh(GRAY);
BW=im2bw(GRAY,threshold);
figure,imshow(BW);      title('BW');    imwrite(BW,'3.BW.jpg','jpg');
% 移除小联通区域
figure
subplot(1,2,1);
imshow(BW);  title('~BW');
BW = bwareaopen(BW, 100000);
subplot(1,2,2);
imshow(BW);     title('Remove Pointer');    
% 边缘检测
BW=edge(BW,'Canny',0.2);
figure,imshow(BW);      title('Canny'); 
% 细化
BW=bwmorph(BW,'thin',Inf);
figure,imshow(BW);      title('细化'); 

%% 哈夫变换
% 步长为1，即每次检测的时候增加的半径长度
step_r = 1;  
%检测的时候每次转过的角度
step_angle = 0.1; 
% 对检测的圆的大小范围预估，在实际项目中因为产品大小固定，所以可以给定较小范围，提高运行速度 
minr = 72;  
maxr = 75;  
% 自动取最优的灰度阈值
thresh = graythresh(GRAY);  
% 调用hough_circle函数进行霍夫变换检测圆
[hough_space,hough_circle,para] = hough_circle2(BW,step_r,step_angle,minr,maxr,thresh);  
% figure,imshow(I),title('原图')  
% figure,imshow(BW),title('边缘')  
figure,imshow(hough_circle),title('检测结果')  
