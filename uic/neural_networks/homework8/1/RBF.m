% ECE 559 Neural Networks - Fall 2018
% Montagna Marco
% Homework 8

clear all
close all
clc


% input patterns
x=rand(2,100);
d=zeros(100,1);
N = 100;

%% plot boundaries
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

%% plot inputs & position clustering centres
p = 1;
n = 1;
centres = 10;
c=zeros(2,centres*2);
flag=false;
for i=1:100
    if x(2,i)<(1/5)*sin(10*x(1,i))+0.3 || (x(2,i)-0.8)^2+(x(1,i)-0.5)^2<0.15^2
        d(i)=1;
%         if p<=10
%             c(:, p) = x(:,i);
%             p=p+1;
%         end
        figure(1),plot(x(1,i),x(2,i),'xr');
        figure(2),plot(x(1,i),x(2,i),'xr');
        if (x(2,i)-0.8)^2+(x(1,i)-0.5)^2<0.15^2
            flag=true;
        end
    else
        d(i)=-1;
%         if n<=10
%             c(:, centres+n) = x(:,i);
%             n=n+1;
%         end
        figure(1),plot(x(1,i),x(2,i),'ok');
        figure(2),plot(x(1,i),x(2,i),'ok');
    end
end
if(flag==false)
    x(1,100)=0.5;
    x(2,100)=0.8;
end

%% RBF
i=1;
while i<1+centres
    c(:,i)=rand(2,1);
    if c(2,i)<(1/5)*sin(10*c(1,i))+0.3 || (c(2,i)-0.8)^2+(c(1,i)-0.5)^2<0.15^2
        min_d=100;
        if i>1
            for j=1:i-1
                distance=norm(c(:,i)-c(:,j));
                if distance<min_d;
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
j=1+centres;
while j<1+2*centres
    c(:,j)=rand(2,1);
    if (~c(2,j)<(1/5)*sin(10*c(1,j))+0.3 || (c(2,j)-0.8)^2+(c(1,j)-0.5)^2<0.15^2)
        min_d=100;
        if j>1+centres
            for k=1+centres:j-1
                distance=norm(c(:,j)-c(:,k));
                if distance<min_d;
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

% plot centres for classes C1 and C-1
figure(2)
plot(c(1,1:centres),c(2,1:centres),'rs','MarkerFaceColor','red');
hold on
plot(c(1,centres+1:2*centres),c(2,centres+1:2*centres),'ks','MarkerFaceColor','black');

% k-means class C1
class=1;
c(:,(1:centres))=k_means(x,c(:,(1:centres)),N,centres,d,class);
plot(c(1,1:centres),c(2,1:centres),'rs','MarkerFaceColor','green');

% k-means class C-1
class=-1;
c(:,(centres+1:2*centres))=k_means(x,c(:,(centres+1:2*centres)),N,centres,d,class);
plot(c(1,centres+1:2*centres),c(2,centres+1:2*centres),'ks','MarkerFaceColor','blue');

% gaussian RBF
f=@(x,c) exp(-(norm(x-c)).^2);

y=zeros(centres,N);
% initial weights
w1=normrnd(1,sqrt(1/(2*centres)),1,centres+1);
w2=normrnd(-1,sqrt(1/(2*centres)),1,centres);
w=[w1,w2];
for i=1:N
    for j=1:2*centres
        y(j,i)=f(x(:,i),c(:,j));
    end
end
flag=1;
epoch=1;
eta=1;
j=1;

%% PTA
% activation function
% sgn=@(x) 1*(x>=0)-1*(x<0);
sympref('HeavisideAtOrigin',1); % set 1 at heaviside origin
for i=1:100
    if d(i)==-1;
        d(i)=0;
    end
end

errors(epoch)=0;
    for i=1:N
        g=heaviside(w*[1;y(:,i)]);
        if d(i)~=g
            errors(epoch)=errors(epoch)+1;
        end
    end
    
epoch=2;
while flag==1
    % update weights
    w=w+eta*(d(j)-heaviside(w*[1;y(:,j)]))*[1;y(:,j)]';
    
    % misclassifications
    errors(epoch)=0;
    for i=1:N
        g=heaviside(w*[1;y(:,i)]);
        if d(i)~=g
            errors(epoch)=errors(epoch)+1;
        end
    end
    
    if ((errors(epoch)>errors(epoch-1)) && (eta>0.01))
        eta=eta*0.999;
    elseif errors(epoch)>errors(epoch-1) && (errors(epoch)<10)
        eta=eta*0.01
        
    end
    
    % check loop condition
    if errors(epoch)>5
        flag=1;
    else
        flag=0;
    end
    epoch=epoch+1;
    
    if j<N
        j=j+1;
    else
        j=1;
    end
end

%% plot decision boundary
x1=linspace(0,1,500);
x2=linspace(0,1,500);
y=zeros(1,2*centres);
for i=1:500
    for j=1:500
        for k=1:2*centres
            y(k)=f([x1(i);x2(j)],c(:,k));
        end
        g=(w*[1;y']);
        if abs(g)<1e-3
            plot(x1(i),x2(j),'c-','Markersize',0.8);
            hold on
        end
    end
end
