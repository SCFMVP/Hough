clc;
clear;  
clear all;
close all;
% ******************************************************
% auther: later
% time  : 2020/7/9 6:56
% tip   : circles identitfication
% change: ����
% Todo: ȥ�߿� finished!!
% Todo: ȥ�������� finished!!
% Todo: ׼ȷ��λ finished!!
% ******************************************************
% email: latermvp@163.com
% ******************************************************
%% Ԥ����
I=imread('002.jpg'); 
figure,imshow(I);     title('RGB');   imwrite(I,'1.RGB.jpg','jpg');
% �ҶȻ�
GRAY=rgb2gray(I);     
% Median filtering-��ֵ�˲�
GRAY=medfilt2(GRAY,[3 3]);
figure,imshow(GRAY);    title('GRAY');  imwrite(GRAY,'2.GRAY.jpg','jpg');
% ��ֵ��
threshold=graythresh(GRAY);
BW=im2bw(GRAY,threshold);
figure,imshow(BW);      title('BW');    imwrite(BW,'3.BW.jpg','jpg');
% �Ƴ�С��ͨ����
figure
subplot(1,2,1);
imshow(BW);  title('~BW');
BW = bwareaopen(BW, 100000);
subplot(1,2,2);
imshow(BW);     title('Remove Pointer');    
% ��Ե���
BW=edge(BW,'Canny',0.2);
figure,imshow(BW);      title('Canny'); 
% ϸ��
BW=bwmorph(BW,'thin',Inf);
figure,imshow(BW);      title('ϸ��'); 

%% ����任
% ����Ϊ1����ÿ�μ���ʱ�����ӵİ뾶����
step_r = 1;  
%����ʱ��ÿ��ת���ĽǶ�
step_angle = 0.1; 
% �Լ���Բ�Ĵ�С��ΧԤ������ʵ����Ŀ����Ϊ��Ʒ��С�̶������Կ��Ը�����С��Χ����������ٶ� 
minr = 72;  
maxr = 75;  
% �Զ�ȡ���ŵĻҶ���ֵ
thresh = graythresh(GRAY);  
% ����hough_circle�������л���任���Բ
[hough_space,hough_circle,para] = hough_circle2(BW,step_r,step_angle,minr,maxr,thresh);  
% figure,imshow(I),title('ԭͼ')  
% figure,imshow(BW),title('��Ե')  
figure,imshow(hough_circle),title('�����')  
