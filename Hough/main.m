clear;
clc;
close all;
% ******************************************************
% auther: later
% time  : 2020/4/19 19:56
% tip   : pointer identitfication
% change: ����
% Todo: ȥ�߿� finished!!
% Todo: ȥ�������� finished!!
% Todo: ׼ȷ��λ finished!!
% ******************************************************
% email: latermvp@163.com
% ******************************************************
%% Image preprocessing-ͼ��Ԥ����
% RGB=imread('pointer2.jpg'); 
RGB=imread('002.jpg'); 
figure(1),imshow(RGB);     title('RGB');   imwrite(RGB,'1.RGB.jpg','jpg');
% �ҶȻ�
GRAY=rgb2gray(RGB);     
% Median filtering-��ֵ�˲�
GRAY=medfilt2(GRAY,[3 3]);
figure(2),imshow(GRAY);    title('GRAY');  imwrite(GRAY,'2.GRAY.jpg','jpg');
% ��ֵ��
threshold=graythresh(GRAY);
BW=im2bw(GRAY,threshold);
figure(3),imshow(BW);      title('BW');    imwrite(BW,'3.BW.jpg','jpg');
% Inverse transformation-���任
% BW=~BW;                  
% figure(4),imshow(BW);      title('~BW');   imwrite(BW,'4.~BW.jpg','jpg');
% ��Ե���
BW=edge(BW,'Canny',0.2);
figure(4),imshow(BW);      title('Canny'); 
% ϸ��
I3=bwmorph(BW,'thin',Inf);
figure(5),imshow(I3);      title('ϸ��'); 

%% Straight line fitting
% ����任
[H,T,R] = hough(BW);   
% ��ʾ�任�� : \rho-\theta�ռ�
figure(8);
imshow(H,[],'XData',T,'YData',R,'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
% Detection peak value - ����任���ֵ
P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
x = T(P(:,2)); % xy - \rho-\theta
y = R(P(:,1));
plot(x,y,'s','color','white');       print(8, '-djpeg', '8_H');%imwrite(H,'8.H.jpg','jpg');
% Find lines and plot them-���ֱ��
lines = houghlines(BW,T,R,P,'FillGap',2,'MinLength',340); 
% ��ע������ϳ���ֱ��
figure(9), imshow(RGB), hold on
max_len = 0;
% length(lines)
%%
for k = 1:length(lines)
    % draw lines-������ϵ���ֱ
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
    
    % Plot beginnings and ends of lines-��עֱ����β
    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
    
    % Determine the endpoints of the longest line segment-ֱ�߳���
    len = norm(lines(k).point1 - lines(k).point2);
    
    % Determine the longest line-�����ֱ��
    if ( len > max_len)
        max_len = len;
        xy_long = xy;
    end
end
% Highlight the longest line segment-�����ֱ��
plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','blue');   print(gcf, '-djpeg', '9_Final');%imwrite(RGB,'9.Final.jpg','jpg');

%% Computational readings-����

% ����б��k
k=(xy_long(1,2)-xy_long(2,2))/(xy_long(1,1)-xy_long(2,1)); 
% ���x������Ϊ���,˳ʱ�뷽��ĽǶ�
theta=atan(k);  
% Calculated voltage-�����ѹֵ
voltage=theta*(20/90)*(360/(2*pi));
disp('k:');disp (k);
disp('��:');disp (theta*(360/(2*pi)));
disp('voltage:');disp (voltage); 
