clear;
clc;
close all;
% ******************************************************
% auther: later
% time  : 2020/4/19 19:56
% tip   : pointer identitfication
% change: 哈夫法
% Todo: 去边框 finished!!
% Todo: 去椒盐噪声 finished!!
% Todo: 准确定位 finished!!
% ******************************************************
% email: latermvp@163.com
% ******************************************************
%% Image preprocessing-图像预处理
% RGB=imread('pointer2.jpg'); 
RGB=imread('002.jpg'); 
figure(1),imshow(RGB);     title('RGB');   imwrite(RGB,'1.RGB.jpg','jpg');
% 灰度化
GRAY=rgb2gray(RGB);     
% Median filtering-中值滤波
GRAY=medfilt2(GRAY,[3 3]);
figure(2),imshow(GRAY);    title('GRAY');  imwrite(GRAY,'2.GRAY.jpg','jpg');
% 二值化
threshold=graythresh(GRAY);
BW=im2bw(GRAY,threshold);
figure(3),imshow(BW);      title('BW');    imwrite(BW,'3.BW.jpg','jpg');
% Inverse transformation-反变换
% BW=~BW;                  
% figure(4),imshow(BW);      title('~BW');   imwrite(BW,'4.~BW.jpg','jpg');
% 边缘检测
BW=edge(BW,'Canny',0.2);
figure(4),imshow(BW);      title('Canny'); 
% 细化
I3=bwmorph(BW,'thin',Inf);
figure(5),imshow(I3);      title('细化'); 

%% Straight line fitting
% 哈夫变换
[H,T,R] = hough(BW);   
% 显示变换域 : \rho-\theta空间
figure(8);
imshow(H,[],'XData',T,'YData',R,'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
% Detection peak value - 计算变换域峰值
P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
x = T(P(:,2)); % xy - \rho-\theta
y = R(P(:,1));
plot(x,y,'s','color','white');       print(8, '-djpeg', '8_H');%imwrite(H,'8.H.jpg','jpg');
% Find lines and plot them-拟合直线
lines = houghlines(BW,T,R,P,'FillGap',2,'MinLength',340); 
% 标注所有拟合出的直线
figure(9), imshow(RGB), hold on
max_len = 0;
% length(lines)
%%
for k = 1:length(lines)
    % draw lines-绘制拟合到的直
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
    
    % Plot beginnings and ends of lines-标注直线首尾
    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
    
    % Determine the endpoints of the longest line segment-直线长度
    len = norm(lines(k).point1 - lines(k).point2);
    
    % Determine the longest line-发现最长直线
    if ( len > max_len)
        max_len = len;
        xy_long = xy;
    end
end
% Highlight the longest line segment-高亮最长直线
plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','blue');   print(gcf, '-djpeg', '9_Final');%imwrite(RGB,'9.Final.jpg','jpg');

%% Computational readings-读数

% 计算斜率k
k=(xy_long(1,2)-xy_long(2,2))/(xy_long(1,1)-xy_long(2,1)); 
% 获得x负半轴为起点,顺时针方向的角度
theta=atan(k);  
% Calculated voltage-计算电压值
voltage=theta*(20/90)*(360/(2*pi));
disp('k:');disp (k);
disp('θ:');disp (theta*(360/(2*pi)));
disp('voltage:');disp (voltage); 
