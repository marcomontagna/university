% ECE 559 Neural Networks - Fall 2018
% Marco Montagna
% Homework 5

close all
clear all 
clc

%% open and read the file

% training set images file 
fileID=fopen('train-images.idx3-ubyte');
magic_number=fread(fileID,1,'int32','ieee-be');
train_images=fread(fileID,1,'int32','ieee-be');
train_row=fread(fileID,1,'int32','ieee-be');
train_col=fread(fileID,1,'int32','ieee-be');
xtrain=zeros(train_row*train_col,train_images);
for i=1:train_images
    xtrain(:,i)=fread(fileID,train_row*train_col,'uint8','ieee-be.l64');
end
fclose(fileID);

% training set labels file
fileID=fopen('train-labels.idx1-ubyte');
magic_number=fread(fileID,1,'int32','ieee-be');
train_labels=fread(fileID,1,'int32','ieee-be');
dtrain=zeros(train_labels,1);
for i=1:train_labels
    dtrain(i)=fread(fileID,1,'uint8','ieee-be'); %saving train labels as number
end
fclose(fileID);

% test set images file
fileID=fopen('t10k-images.idx3-ubyte');
magic_number=fread(fileID,1,'int32','ieee-be');
test_images=fread(fileID,1,'int32','ieee-be');
test_row=fread(fileID,1,'int32','ieee-be');
test_col=fread(fileID,1,'int32','ieee-be');
xtest=zeros(test_row*test_col,test_images);
for i=1:test_images
    xtest(:,i)=fread(fileID,test_row*test_col,'uint8','ieee-be');
end
fclose(fileID);

% test set labels file
fileID=fopen('t10k-labels.idx1-ubyte');
magic_number=fread(fileID,1,'int32','ieee-be');
test_items=fread(fileID,1,'int32','ieee-be');
dtest=zeros(test_items,1);
for i=1:test_items
    dtest(i)=fread(fileID,1,'uint8','ieee-be'); %saving test labels as number
end
fclose(fileID);

%normalization of the inputs
for i=1:train_images
   mean_in=mean(xtrain(:,i));
   xtrain(:,i)=xtrain(:,i)-mean_in;
end
for i=1:test_images
   mean_in=mean(xtest(:,i));
   xtest(:,i)=xtest(:,i)-mean_in;
end

%% Network

% layer dimension

n1 = 784;
n2 = 25;

% eta
eta1 = 10;
eta2 = 5;


% weights
w1=normrnd(0,sqrt(1/(n1+1)),n2,(n1+1));
w2=normrnd(0,sqrt(1/(n2+1)),1,(n2+1));

% momentum method
g_mom = 0.8;
momentum_w1 = 0;
momentum_w2 = 0;

epoch=1;
train_errors(epoch)=0;
MSE(epoch)=0;
for i=1:train_images
    out0=xtrain(:,i);
    in1=w1*[1;out0];
    out1=sigmf(in1,[10,0]);
    in2=w2*[1;out1];
    out2 = in2;
    if xtrain(i)~= round(out2,0)
      train_errors(epoch)=train_errors(epoch)+1;
    end  
    MSE(epoch)=MSE(epoch)+(1/train_images)*((dtrain(i)-out2)^2);
end

figure(1),plot(epoch,train_errors(epoch),'r*','Markersize',2);
xlabel('Epoch');
ylabel('Misclassifications');
title('Training Misclassification')
hold on
grid on

figure(2),plot(epoch,MSE(epoch),'r*','Markersize',2);
xlabel('Epoch');
ylabel('Energy');
title('Training Energy')
hold on
grid on
drawnow

flag=true;
epoch=2;

while flag==true
    %% Training
    for i=1:train_images
    out0=xtrain(:,i);
    in1=w1*[1;out0];
    out1=sigmf(in1,[10,0]);
    in2=w2*[1;out1];
    out2=in2;
    
    % backpropagation method
    delta2=(dtrain(i)-out2)*1;
    delta1=w2(:,(2:length(w2)))'*delta2.*out1.*(1-out1);
 
    g1=-(2/train_images)*delta1*[1;out0]';
    g2=-(2/train_images)*delta2*[1;out1]';

    
    % update weights momentum
    % velocity
    momentum_w1=g_mom*momentum_w1-eta1*g1;
    momentum_w2=g_mom*momentum_w2-eta2*g2;
  
    
    w1=w1+momentum_w1;
    w2=w2+momentum_w2;
    
        %weights update(Stochastic Gradient Descent)
%     w1=w1-eta1*g1;
%     w2=w2-eta2*g2;
%     w3=w3-eta3*g3;
    end

    
    train_errors(epoch)=0;
    MSE(epoch)=0;
    for i=1:train_images
        out0=xtrain(:,i);
        in1=w1*[1;out0];
        out1=sigmf(in1,[10,0]);
        in2=w2*[1;out1];
        out2=in2;
        if dtrain(i)~= round(out2,0)
            train_errors(epoch)=train_errors(epoch)+1;
        end
        MSE(epoch)=MSE(epoch)+(1/train_images)*((dtrain(i)-out2)^2);
    end
    
    figure(1),plot(epoch,train_errors(epoch),'r*','Markersize',2);
    hold on
    figure(2),plot(epoch,MSE(epoch),'r*','Markersize',2);
    hold on
    drawnow
    
    if MSE(epoch)>MSE(epoch-1)
        eta1 = 0.9*eta1;
        eta2 = 0.9*eta2;

    end
    
    % stop if error is below a threshold
    if (train_errors(epoch)/train_images)< 0.1
        flag_while = false;
    end
    
%     %% Test
%     test_errors(epoch)=0;
%     MSE_test(epoch)=0;
%     for i=1:test_images
%     out0=test_images(:,i);
%     in1=w1*[1;out0];
%     out1=sigmf(in1,[1,0]);
%     %y1=tanh(v1);
%     in2=w2*[1;out1];
%     %y2=v2;
%     out2=sigmf(in2,[10,0]);
%     in3=w3*[1;out2];
%     out3=in3;
%         if test_labels(i)~= round(out3,0)
%            test_errors(epoch)=test_errors(epoch)+1; 
%         end
%     MSE_test(epoch)=MSE_test(epoch)+(1/test_images)*((test_labels(i)-out3)^2);
%     end
%     subplot(2,2,3),plot(epoch,test_errors(epoch),'r*','Markersize',2);
%     hold on
%     subplot(2,2,4),plot(epoch,MSE_test(epoch),'r*','Markersize',2);
%     hold on
%     drawnow
%     %% Early stopping
%     if test_errors(epoch)>test_errors(epoch-1) && test_errors(epoch-1)>test_errors(epoch-2)
%         flag=false;
%     else 
%         flag=true;
%     end
    epoch=epoch+1;
end

%% Test
    test_errors(epoch)=0;
    MSE_test(epoch)=0;
    for i=1:test_images
    out0=xtest(:,i);
    in1=w1*[1;out0];
    out1=sigmf(in1,[1,0]);
    in2=w2*[1;out1];
    out2=in2;
        if dtest(i)~= round(out2,0)
           test_errors(epoch)=test_errors(epoch)+1; 
        end
    MSE_test(epoch)=MSE_test(epoch)+(1/test_images)*((dtest(i)-out2)^2);
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

% if epoch==1
%     s= [' Number of test errors : ',num2str(test_errors(epoch))];
%     disp(s);
%     s=[' Percentage of error : ',num2str(test_errors(epoch)*100/test_images),' %'];
%     disp(s);
%     s=[' Success rate : ',100-(num2str(test_errors(epoch)*100/test_images)),' %'];   
% else
%     s= [' Number of test errors : ',num2str(test_errors(epoch-3))];
%     disp(s);
%     s=[' Percentage of error : ',num2str(test_errors(epoch-3)*100/test_images),' %'];
%     disp(s);
%     s=[' Success rate : ',num2str(100-test_errors(epoch-3)*100/test_images),' %'];  
%     disp(s);
% end
