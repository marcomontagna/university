% ECE 559 Neural Networks - Fall 2018
% Marco Montagna
% Homework 4

close all
clear all 
clc

%% homework 4
tanh = @(x) (exp(x)-exp(-x))./(exp(x)+exp(-x));
n = 300; % number of inputs
N = 24;
x = rand (n, 1); % inizialize randomly x vector
v = (1/10-(-1/10)).*rand(n,1)-1/10;

eta1 = 1;
eta2 = 0.8;

d = sin(20*x)+3*x+v;

% initialize weights
w1 = (10).*randn(24, 2);
w2 = (1).*randn(1, 25);

epoch = 1;
% initial energy
MSE(1) = 0;
for i=1:n
    % input layer
    out0 = x(i);
    % hidden layer
    v1 = w1*[1 ; out0];
    out1 = tanh(v1);
    % output layer
    v2 = w2*[1 ; out1];
    y = v2;
    MSE(1) = MSE(1) + (1/n)*((d(i)-y)^2);
end


figure(1)
plot(epoch,MSE(1));
axis([0 inf 0 1])
title('MSE vs Epochs');
xlabel('Epoch');
ylabel('MSE (Mean Squared Error)');
hold on
grid on

i = 1;
flag_while = true;
epoch = 2;

while (flag_while == true)
    for i=1:n
        % input layer
        out0 = x(i);
        % hidden layer
        v1 = w1*[1 ; out0];
        out1 = tanh(v1);
        % output layer
        v2 = w2*[1 ; out1];
        y = v2;
    
        % gradient, backpropagation method
        delta2 = (d(i)-y)*1;
        delta1 = w2(2:25)'*delta2.*(1-out1.^2);
        g1 = -(2/n)*delta1*[1;out0]';
        g2 = -(2/n)*delta2*[1;out1]';
    
        % update weights
        w1 = w1-eta1*g1;
        w2 = w2-eta2*g2;
    end
    
    MSE(epoch) = 0;
    for k=1:n
        % input layer
        out0 = x(k);
        % hidden layer
        v1 = w1*[1 ; out0];
        out1 = tanh(v1);
        % output layer
        v2 = w2*[1 ; out1];
        y = v2;
        MSE(epoch) = MSE(epoch) + (1/n)*((d(k)-y)^2);
        f_final(k) = y;
          
    end
    
    figure(1), plot(epoch,MSE(epoch), 'b.');
    
    if ((norm(g1)<10e-4 || norm(g2)<10e-4) && MSE(epoch)<5e-3)
        flag_while = false;
    end
    
    if MSE(epoch)>MSE(epoch-1)
        eta1 = 0.9*eta1;
        eta2 = 0.9*eta2;
    end
    
    epoch = epoch + 1;
    
end

figure(2), plot(x,d,'r.');
grid on 
hold on
plot(x, f_final', 'b*');
legend('desired', 'fitted')
title('Curve fitting')
xlabel('x')
ylabel('y')