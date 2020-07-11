% ECE 559 Neural Networks - Fall 2018
% Montagna Marco
% Homework 8

clear all
close all
clc

n_in=100;
x=rand(2,n_in); 
n_c=2;

%% plot the boundaries

angle=0:0.01:2*pi; 
r=0.15;
x1=0.5;
x2=0.8;
xp=r*cos(angle);
yp=r*sin(angle);

figure(1);
plot(x1+xp,x2+yp,'b');
hold on
x1=linspace(0,1);
x2=(1/5)*sin(10*x1)+0.3;
plot(x1,x2,'b')
hold on

axis([0 1 0 1]);
hold on
grid on
xlabel('x1');
ylabel('x2');

figure(2);
axis([0 1 0 1]);
hold on
grid on
xlabel('x1');
ylabel('x2');

%% plot inputs
p = 1;
n = 1;
c=zeros(2,n_c*2);
flag=0;

for i=1:100
    if x(2,i)<(1/5)*sin(10*x(1,i))+0.3 || (x(2,i)-0.8)^2+(x(1,i)-0.5)^2<0.15^2
        d(i)=1;
        figure(1),plot(x(1,i),x(2,i),'xr');
        figure(2),plot(x(1,i),x(2,i),'xr');
        if (x(2,i)-0.8)^2+(x(1,i)-0.5)^2<0.15^2
            flag=1;
        end
    else
        d(i)=-1;
        figure(1),plot(x(1,i),x(2,i),'ok');
        figure(2),plot(x(1,i),x(2,i),'ok');
    end
end
if(flag==0)
    x(1,100)=0.5;
    x(2,100)=0.8;
end

%% initialize cluster centres

c=rand(2,n_c*2);
i=1;
while i<n_c+1
    c(:,i)=rand(2,1);
    if c(2,i)<(1/5)*sin(10*c(1,i))+0.3 || (c(2,i)-0.8)^2+(c(1,i)-0.5)^2<0.15^2
        min_d=100;
        if i>1
            for j=1:i-1
                distance=norm(c(:,i)-c(:,j));
                if distance<min_d
                    min_d=distance;
                end
            end
            
            if min_d>0.2
                i=i+1;
            end
        else
            i=i+1;
        end
    end
end
j=1+n_c;
while j<2*n_c+1
    c(:,j)=rand(2,1);
    if ~(c(2,j)<(1/5)*sin(10*c(1,j))+0.3 || (c(2,j)-0.8)^2+(c(1,j)-0.5)^2<0.15^2)
        min_d=100;
        if j>1+n_c
            for k=1+n_c:j-1
                distance=norm(c(:,i)-c(:,j));
                if distance<min_d
                    min_d=distance;
                end
            end
            
            if min_d>0.3
                j=j+1;
            end
        else
            j=j+1;
        end
    end
end

%% k-means

% class 1
class=1;
c(:,(1:n_c))=k_means(x,c(:,(1:n_c)),n_in,n_c,d,class);
plot(c(1,1:n_c),c(2,1:n_c),'rd','MarkerFaceColor','red');

% class -1
class=-1;
c(:,(n_c+1:2*n_c))=k_means(x,c(:,(n_c+1:2*n_c)),n_in,n_c,d,class);
plot(c(1,n_c+1:2*n_c),c(2,n_c+1:2*n_c),'kd','MarkerFaceColor','black');
drawnow

f=@(x,c) exp(-(norm(x-c)).^2);

y=zeros(n_c,n_in);
%initial weights
w=normrnd(0,1/sqrt(20),1,2*n_c+1); 
for i=1:n_in
    for j=1:2*n_c
        y(j,i)=f(x(:,i),c(:,j));
    end
end
flag=1;
epoch=1;
eta=100;
%% PTA

% activation function
sgn=@(x) 1*(x>=0)-1*(x<0);

while flag==1
    %%update the weights
    for i=1:n_in
        w=w+eta*(d(i)-sgn(w*[1;y(:,i)]))*[1;y(:,i)]';
    end
    
    errors(epoch)=0;
    %%loop to count the number of misclassifications errors
    for i=1:n_in
        g=sgn(w*[1;y(:,i)]);
        if d(i)~=g
            errors(epoch)=errors(epoch)+1;
        end
    end
    
    if epoch>1
        if errors(epoch)>errors(epoch-1) && eta>5 && errors(epoch)<10
            eta=eta*0.999;
         elseif errors(epoch)>errors(epoch-1) && errors(epoch)<5
             eta=5;
        end
    end
    
    if errors(epoch)>0 %%check condition on the number of errors
        flag=1;
    else
        flag=0;
    end
    epoch=epoch+1;
end

%%sketch of the decision boundary
figure(2)
x1=linspace(0,1,5000);
x2=linspace(0,1,5000);
y=zeros(2*n_c,1);
for i=1:5000
    for j=1:5000
        for k=1:2*n_c
            y(k)=f([x1(i);x2(j)],c(:,k));
        end
        g=(w*[1;y]);
        if abs(g)<1e-2
            plot(x1(i),x2(j),'bl.','Markersize',2);
            hold on
        end
    end
end