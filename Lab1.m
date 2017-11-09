%% 2.1Contrast Stretching 
Pc=imread('mrt-train.jpg');
whos Pc
P = rgb2gray(Pc);
imshow(P);
min(P(:)), max(P(:))
a=double(P);
b=(a-13)*(255-0)/(204-13)+0;
P2=uint8(b);
min(P2(:)), max(P2(:))
imshow(P2)
%% 2.2  Histogram Equalization
imhist(P,10);
imhist(P,256);
P3=histeq(P,255);
imhist(P3,10);
imhist(P3,256);
P3=histeq(P3,255);
imhist(P3,10);
imhist(P3,256);
%% 2.3  Linear Spatial Filtering 
N=5;
sigma1=1;
sigma2=2;
ind=-floor(N/2) : floor(N/2);
[X Y] = meshgrid(ind,ind);
h1=(1/(2*pi*sigma1*sigma1))*exp(-(X.^2 + Y.^2) / (2*sigma1*sigma1)); %//create Gaussian Mask
h2=(1/(2*pi*sigma2*sigma2))*exp(-(X.^2 + Y.^2) / (2*sigma2*sigma2))
h1=h1/sum(h1(:));
h2=h2/sum(h2(:));
mesh(double(h1));
mesh(double(h2));
P=imread('ntu-gn.jpg');
imshow(P);
Pn=double(P);
h1d=double(h1);
Pn=conv2(h1d,Pn);
Pnd=uint8(Pn);
imshow(Pnd);
h2d=double(h2);
Pn2=conv2(h2d,Pn);
Pnd2=uint8(Pn2);
imshow(Pnd2);
P2=imread('ntu-sp.jpg');
imshow(P2);
Pn22=double(P2);
P2n=conv2(h1d,Pn22);
P2nd=uint8(P2n);
imshow(P2nd);
P2n2=conv2(h2d,Pn22);
Pn22nd=uint8(P2n2);
imshow(Pn22nd);
%% 2.4  Median Filtering
P41=imread('ntu-gn.jpg');
P42=imread('ntu-sp.jpg');
M31=medfilt2(P41,[3,3]);
M51=medfilt2(P41,[5,5]);
M32=medfilt2(P42,[3,3]);
M52=medfilt2(P42,[5,5]);
imshow(M31);
imshow(M51);
imshow(M32);
imshow(M52);
%% 2.5  Suppressing Noise Interference Patterns 
P5=imread('pck-int.jpg');
imshow(P5);
F=fft2(P5);
S=abs(F);
imagesc(fftshift(S.^0.1));
colormap('default')
imagesc(S.^0.1);
colormap('default')
%coord[9,241;249,17]
a=2;
F1=F;
F1(241-a:241+a,9-a:9+a)=zeros(2*a+1);
F1(17-a:17+a,249-a:249+a)=zeros(2*a+1);
S1=abs(F1);
imagesc(fftshift(S1.^0.1));
colormap('default')
F3=ifft2(F1);
F4=uint8(F3);
imshow(F4);
F2=F1;
[v, h]=size(F1);
F2(:,9) = zeros(v,1);
F2(:,249)=zeros(v,1);
F2(17,:)=zeros(1,h);
F2(241,:)=zeros(1,h);
S2=abs(F2);
imagesc(S2.^0.1);
colormap('default')
F5=ifft2(F2);
F6=uint8(F5);
imshow(F6);
%{
P6=imread('primate-caged.jpg');
P6=rgb2gray(P6);
imshow(P6);
FF=fft2(P6);
SS=abs(FF);
imagesc(SS.^0.1);
colormap('default')
%coord[11,252;248,4;22,248;237,11]
a=2
FF(252-a:252+a,11-a:11+a)=zeros(2*a+1);
FF(4-a:4+a,248-a:248+a)=zeros(2*a+1);
FF(248-a:248+a,22-a:22+a)=zeros(2*a+1);
FF(11-a:11+a,237-a:237+a)=zeros(2*a+1);
[h, w]=size(FF);
FF(:,11) = zeros(h,1);
FF(:,248)=zeros(h,1);
FF(:,22)=zeros(h,1);
FF(:,237)=zeros(h,1);
FF(252,:)=zeros(1,w);
FF(4,:)=zeros(1,w);
FF(248,:)=zeros(1,w);
FF(11,:)=zeros(1,w);
RR=ifft2(FF);
R=uint8(RR);
imshow(R);
%}
%% 2.6  Undoing Perspective Distortion of Planar Surface
P61=imread('book.jpg');
imshow(P61);

%counterclockwise 
coord=[143,28;6,159;257,214;308,47];
x=[143;6;257;308];
xn=[0;0;210;210];
desired=[0,0;0,297;210,297;210,0];
y=[28;159;214;47];
yn=[0,297,297,0];
X=coord(:,1);
Y=coord(:,2);
A=[
x(1),y(1),1,0,0,0,-xn(1)*x(1),-xn(1)*y(1);
0,0,0,x(1),y(1),1,-yn(1)*x(1),-yn(1)*y(1);
x(2),y(2),1,0,0,0,-xn(2)*x(2),-xn(2)*y(2);
0,0,0,x(2),y(2),1,-yn(2)*x(2),-yn(2)*y(2);
x(3),y(3),1,0,0,0,-xn(3)*x(3),-xn(3)*y(3);
0,0,0,x(3),y(3),1,-yn(3)*x(3),-yn(3)*y(3);
x(4),y(4),1,0,0,0,-xn(4)*x(4),-xn(4)*y(4);
0,0,0,x(4),y(4),1,-yn(4)*x(4),-yn(4)*y(4);
];
V=[0;0;0;297;210;297;210;0];   
u=A\V;
U = reshape([u;1], 3, 3)'; 
w = U*[x'; y'; ones(1,4)];  
w = w ./ (ones(3,1) * w(3,:));
T= maketform('projective', U'); 
P2 = imtransform(P61, T, 'XData', [0 210], 'YData', [0 297]);
imshow(P2);