% ECE 559 Neural Network - Fall 2018
% Montagna Marco
% Homework 1

clear all
close all
clc

% input patterns
x=rand(2,100);
d=zeros(100,1);

% plot boundaries
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

% plot inputs
flag=false;
for i=1:100
    if x(2,i)<(1/5)*sin(10*x(1,i))+0.3 || (x(2,i)-0.8)^2+(x(1,i)-0.5)^2<0.15^2
        d(i)=1;
        plot(x(1,i),x(2,i),'xr');
        if (x(2,i)-0.8)^2+(x(1,i)-0.5)^2<0.15^2
            flag=true;
        end
    else
        d(i)=-1;
        plot(x(1,i),x(2,i),'ok');
    end
end
if(flag==false)
    x(1,100)=0.5;
    x(2,100)=0.8;
end

% solve quadratic minimization problem
% NOTE: I want to MAXIMIZE the minimum distance
A=[];
b=[];
H=zeros(100,100);
f=-1*ones(100,1);
Aeq=d';
beq=0;

% Gaussian Kernel
K=@(x,y)exp((-(norm(x-y)).^2)/0.5);

% Polynomial Kernel
% K=@(x,y)(1+x'*y).^5;

for i=1:100
    for j=1:100
        H(i,j)=d(i)*d(j)*K(x(:,j),x(:,i));
    end
end
[al,fval,exitflag,output,lambda]=quadprog(H,f,A,b,Aeq,beq,zeros(100,1),[],[]);
if exitflag==1
    disp('Function converged to the solution.');
    flag=0;
elseif exitflag==0
    disp('Number of iterations exceeded options.MaxIterations.');
    flag=1;
else
    disp('Problem unsolved.')
    flag=1;
end

% if the optimization function converged
if flag==0
    k=find(al>=0.1,1);
    w=0;
    theta=0;
    for i=1:100
        w=w+al(i)*d(i)*K(x(:,i),x(:,k));
        theta=theta+al(i)*d(i)*K(x(:,i),x(:,k));
    end
    theta=d(k)-theta;
    g=w+theta;
    norm=abs(g);
    
    figure(2)
    % Support vectors
    k=find(al>=0.1);
    for i=1:length(k)
        if x(2,k(i))<(1/5)*sin(10*x(1,k(i)))+0.3 || (x(2,k(i))-0.8)^2+(x(1,k(i))-0.5)^2<0.15^2      
            plot(x(1,k(i)),x(2,k(i)),'rO','Markersize',10);
            hold on
        else
            plot(x(1,k(i)),x(2,k(i)),'kO','Markersize',10);
            hold on
        end
    end
    for i=1:100
        if x(2,i)<(1/5)*sin(10*x(1,i))+0.3 || (x(2,i)-0.8)^2+(x(1,i)-0.5)^2<0.15^2
            d(i)=1;
            plot(x(1,i),x(2,i),'rx');
            hold on
        else
            d(i)=-1;
            plot(x(1,i),x(2,i),'ko');
            hold on
        end
    end
    %plot of the decision boundaries
    x1=linspace(0,1,1000);
    x2=linspace(0,1,1000);
    for i=1:1000
        for j=1:1000
            w=0;
            for k=1:100
                w=w+al(k)*d(k)*K(x(:,k),[x1(i);x2(j)]);
            end
            g=(w+theta)/norm;
            if abs(g)<0.1
                plot(x1(i),x2(j),'bl.','Markersize',0.5);
                hold on
            elseif abs(g-1)<0.1
                plot(x1(i),x2(j),'r.','Markersize',0.5);
                hold on
            elseif abs(g+1)<0.1
                plot(x1(i),x2(j),'k.','Markersize',0.5);
                hold on
            end
        end
    end
end
xlabel('x1');
ylabel('x2');
title('SVM')
