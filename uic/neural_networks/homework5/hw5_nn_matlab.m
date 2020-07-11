% ECE 559 Neural Networks - Fall 2018
% Marco Montagna
% Homework 5

close all
clear all 
clc

%% open and read the file

% training set image file
fileID=fopen('train-images.idx3-ubyte');
magic_nr=fread(fileID,1,'int32','ieee-be');
train_images=fread(fileID,1,'int32','ieee-be');
train_row=fread(fileID,1,'int32','ieee-be');
train_col=fread(fileID,1,'int32','ieee-be');
k = train_col * train_row;
xtrain=zeros(k,train_images);
for i=1:train_images
    xtrain(:,i)=fread(fileID,k,'uint8','ieee-be.l64');
end
fclose(fileID);

% training set label file
fileID=fopen('train-labels.idx1-ubyte');
magic_nr=fread(fileID,1,'int32','ieee-be');
train_labels=fread(fileID,1,'int32','ieee-be');
dtrain=zeros(train_labels,1);
for i=1:train_labels
    dtrain(i)=fread(fileID,1,'uint8','ieee-be'); 
end
fclose(fileID);

% test set image file
fileID=fopen('t10k-images.idx3-ubyte');
magic_nr=fread(fileID,1,'int32','ieee-be');
test_images=fread(fileID,1,'int32','ieee-be');
test_row=fread(fileID,1,'int32','ieee-be');
test_col=fread(fileID,1,'int32','ieee-be');
xtest=zeros(test_row*test_col,test_images);
for i=1:test_images
    xtest(:,i)=fread(fileID,test_row*test_col,'uint8','ieee-be');
end
fclose(fileID);

% test set label file
fileID=fopen('t10k-labels.idx1-ubyte');
magic_nr=fread(fileID,1,'int32','ieee-be');
test_labels=fread(fileID,1,'int32','ieee-be');
test_labels=zeros(test_labels,1);
for i=1:test_labels
    dtest(i)=fread(fileID,1,'uint8','ieee-be'); %saving test labels as number
end
fclose(fileID);
%% network description

% # inputs = 784 - # neurons hidden layer = 1000 - # output layer = 10

% activation function
% tanh = @(x) (exp(x)-exp(-x))./(exp(x)+exp(-x));

% normalization of inputs
% compute mean and subtract to training images
for i=1:train_images
   mean_in=mean(xtrain(:,i));
   xtrain(:,i)=xtrain(:,i)-mean_in;
end
% compute mean and subtract to test images
for i=1:test_images
   mean_in=mean(xtest(:,i));
   xtest(:,i)=xtest(:,i)-mean_in;
end


% layer dimension

n1 = 784;
n2 = 1000;
n3 = 500;

% eta
eta1 = 3;
eta2 = 2;
eta3 = 1;

% weights
w1=normrnd(0,sqrt(1/(n1+1)),n2,(n1+1));
w2=normrnd(0,sqrt(1/(n2+1)),n3,(n2+1));
w3=normrnd(0,sqrt(1/(n3+1)),1,(n3+1));

% insert here more w for deeper network

% momentum method
g_mom = 0.8;
momentum_w1 = 0;
momentum_w2 = 0;
momentum_w3 = 0;

epoch=1;
train_errors(epoch)=0;
MSE(epoch)=0;
for i=1:train_images
    out0=xtrain(:,i);
    in1=w1*[1;out0];
    out1=sigmf(in1,[1,0]);
    in2=w2*[1;out1];
    out2=sigmf(in2,[10,0]);
    in3=w3*[1;out2];
    out3=in3;
    if dtrain(i)~= round(out3,0)
      train_errors(epoch)=train_errors(epoch)+1;
    end  
    MSE(epoch)=MSE(epoch)+(1/train_images)*((dtrain(i)-out3)^2);
end


figure(1)
plot(1, train_errors(1), 'b.');
% axis([0 inf 0 (max(train_errors)+1e4)])
title('misclassifications vs Epochs');
xlabel('Epoch');
ylabel('misclassifications');
hold on
grid on

figure(2)
plot(1,MSE(1), 'b.');
% axis([0 inf 0 (max(MSE)+1)])
title('MSE vs Epochs');
xlabel('Epoch');
ylabel('MSE (Mean Squared Error)');
hold on
grid on

flag_while = true;
epoch = 2;

while (flag_while == true)
    for i=1:train_images
    out0=xtrain(:,i);
    in1=w1*[1;out0];
    out1=sigmf(in1,[1,0]);
    in2=w2*[1;out1];
    out2=sigmf(in2,[10,0]);
    in3=w3*[1;out2];
    out3=in3;
    
    % backpropagation method
    delta3=(dtrain(i)-out3)*1;
    delta2=w3(:,(2:length(w3)))'*delta3.*out2.*(1-out2);
    delta1=w2(:,(2:length(w2)))'*delta2.*out1.*(1-out1);
    
    % gradient
    g1=-(2/train_images)*delta1*[1;out0]';
    g2=-(2/train_images)*delta2*[1;out1]';
    g3=-(2/train_images)*delta3*[1;out2]';
    
    % update weights momentum
    
    momentum_w1=g_mom*momentum_w1-eta1*g1;%velocity
    momentum_w2=g_mom*momentum_w2-eta2*g2;
    momentum_w3=g_mom*momentum_w3-eta3*g3;
    
    w1=w1+momentum_w1;
    w2=w2+momentum_w2;
    w3=w3+momentum_w3;
        
    end

train_errors(epoch)=0;
MSE(epoch)=0;
for i=1:train_images
    out0=xtrain(:,i);
    in1=w1*[1;out0];
    out1=sigmf(in1,[1,0]);
    in2=w2*[1;out1];
    out2=sigmf(in2,[10,0]);
    in3=w3*[1;out2];
    out3=in3;
    if dtrain(i)~= round(out3,0)
      train_errors(epoch)=train_errors(epoch)+1;
    end  
    MSE(epoch)=MSE(epoch)+(1/train_images)*((dtrain(i)-out3)^2);
end

    figure(1), plot(epoch, train_errors(epoch), 'b.');
    %axis([0 inf 0 (max(train_errors(epoch))+1e4)])
    hold on
    figure(2), plot(epoch,MSE(epoch), 'b.');
   % axis([0 inf 0 (max(MSE(epoch))+1)])
    hold on
    drawnow
    

    % stop if error is below a threshold
    if (train_errors(epoch)/train_images)< 0.1
        flag_while = false;
    end
    
    epoch = epoch + 1;
end

% test section

    test_errors(epoch)=0;
    MSE_test(epoch)=0;
    for i=1:test_images
    out0=xtest(:,i);
    in1=w1*[1;out0];
    out1=sigmf(in1,[1,0]);
    in2=w2*[1;out1];
    %y2=v2;
    out2=sigmf(in2,[10,0]);
    in3=w3*[1;out2];
    out3=in3;
        if test_labels(i)~= round(out3,0)
           test_errors(epoch)=test_errors(epoch)+1; 
        end
    MSE_test(epoch)=MSE_test(epoch)+(1/test_images)*((dtest(i)-out3)^2);
    end

range = linspace(1,test_images,test_images);
figure(3)
plot(range, test_errors(range));
%axis([0 inf 0 (max(test_errors)+1)]);
title('misclassification test');
xlabel('step');
ylabel('misclassifications');
hold on
grid on

text = ['Test error:', num2str(test_errors(test_images))];
disp(text);
text = ['Percentage Test error:', num2str(test_errors(test_images)*100/test_images)];
disp(text);