close all
clear all
clc
format long eng
%% Open and save training and test images and labels
%%Open and save the training set images 
fileID=fopen('train-images.idx3-ubyte');
magic_number=fread(fileID,1,'int32','ieee-be');
nr_train_images=fread(fileID,1,'int32','ieee-be');
nr_train_row=fread(fileID,1,'int32','ieee-be');
nr_train_col=fread(fileID,1,'int32','ieee-be');
train_images=zeros(nr_train_row*nr_train_col,nr_train_images);
for i=1:nr_train_images
    train_images(:,i)=fread(fileID,nr_train_row*nr_train_col,'uint8','ieee-be.l64');
end
fclose(fileID);
%%Open and save the training set labels 
fileID=fopen('train-labels.idx1-ubyte');
magic_number=fread(fileID,1,'int32','ieee-be');
nr_train_items=fread(fileID,1,'int32','ieee-be');
train_labels=zeros(nr_train_items,1);
out_train_labels=zeros(10,nr_train_items);
for i=1:nr_train_items
    train_labels(i)=fread(fileID,1,'uint8','ieee-be'); %saving train labels as number
    out_train_labels(train_labels(i)+1,i)=1;
end
fclose(fileID);
%%Open and save the test set images 
fileID=fopen('t10k-images.idx3-ubyte');
magic_number=fread(fileID,1,'int32','ieee-be');
nr_test_images=fread(fileID,1,'int32','ieee-be');
nr_test_row=fread(fileID,1,'int32','ieee-be');
nr_test_col=fread(fileID,1,'int32','ieee-be');
test_images=zeros(nr_test_row*nr_test_col,nr_test_images);
for i=1:nr_test_images
    test_images(:,i)=fread(fileID,nr_test_row*nr_test_col,'uint8','ieee-be');
end
fclose(fileID);
%%Open and save the test set labels 
fileID=fopen('t10k-labels.idx1-ubyte');
magic_number=fread(fileID,1,'int32','ieee-be');
nr_test_items=fread(fileID,1,'int32','ieee-be');
test_labels=zeros(nr_test_items,1);
out_test_labels=zeros(10,nr_train_items);
for i=1:nr_test_items
    test_labels(i)=fread(fileID,1,'uint8','ieee-be'); %saving test labels as number
    out_test_labels(test_labels(i)+1,i)=1;
end
fclose(fileID);

%normalization of the inputs
for i=1:nr_train_images
   mean_input=mean(train_images(:,i));
   train_images(:,i)=train_images(:,i)-mean_input;
end
for i=1:nr_test_images
   mean_input=mean(test_images(:,i));
   test_images(:,i)=test_images(:,i)-mean_input;
end

%% Network
w1=normrnd(0,sqrt(1/785),600,785);
w2=normrnd(0,sqrt(1/601),200,601);
w3=normrnd(0,sqrt(1/201),1,201);

epoch=1;
errors(epoch)=0;
MSE(epoch)=0;
for i=1:nr_train_images
    y0=train_images(:,i);
    v1=w1*[1;y0];
    y1=sigmf(v1,[1,0]);
    v2=w2*[1;y1];
    %y2=v2;
    y2=sigmf(v2,[10,0]);
    v3=w3*[1;y2];
    y3=v3;
    if train_labels(i)~= round(y3,0)
      errors(epoch)=errors(epoch)+1;
    end  
    MSE(epoch)=MSE(epoch)+(1/nr_train_images)*((train_labels(i)-y3)^2);
end

test_errors(epoch)=0;
MSE_test(epoch)=0;
for i=1:nr_test_images
    y0=test_images(:,i);
    v1=w1*[1;y0];
    y1=sigmf(v1,[1,0]);
    %y1=tanh(v1);
    v2=w2*[1;y1];
    %y2=v2;
    y2=sigmf(v2,[10,0]);
    v3=w3*[1;y2];
    y3=v3;
    if test_labels(i)~= round(y3,0)
       test_errors(epoch)=test_errors(epoch)+1; 
    end
    MSE_test(epoch)=MSE_test(epoch)+(1/nr_test_images)*((test_labels(i)-y3)^2);
end
figure(1),subplot(2,2,1),plot(epoch,errors(epoch),'r*','Markersize',2);
xlabel('Epoch');
ylabel('Misclassifications');
title('Misclassifications vs Epoch (training images)')
hold on
grid on
subplot(2,2,2),plot(epoch,MSE(epoch),'r*','Markersize',2);
xlabel('Epoch');
ylabel('Energy');
title('Energy vs Epoch (training images)')
hold on
grid on
subplot(2,2,3),plot(epoch,test_errors(epoch),'r*','Markersize',2);
xlabel('Epoch');
ylabel('Misclassifications');
title('Misclassifications vs Epoch (test images)')
hold on
grid on
subplot(2,2,4),plot(epoch,MSE_test(epoch),'r*','Markersize',2);
xlabel('Epoch');
ylabel('Energy');
title('Energy vs Epoch (test images)')
hold on
grid on
drawnow

eta1=3;
eta2=2;
eta3=1;
delta_w1=0;
delta_w2=0;
delta_w3=0;
gamma=0.8;
if test_errors(epoch)<(5*nr_test_images/100)
    flag=false;
else
    flag=true;
    epoch=2;
end

while flag==true
    %% Training
    for i=1:nr_train_images
    y0=train_images(:,i);
    v1=w1*[1;y0];
    y1=sigmf(v1,[1,0]);
    %y1=tanh(v1);
    v2=w2*[1;y1];
    %y2=v2;
    y2=sigmf(v2,[10,0]);
    v3=w3*[1;y2];
    y3=v3;
    delta3=(train_labels(i)-y3)*1;
    delta2=w3(:,(2:length(w3)))'*delta3.*y2.*(1-y2);
    delta1=w2(:,(2:length(w2)))'*delta2.*y1.*(1-y1);
 
    g1=-(2/nr_train_images)*delta1*[1;y0]';
    g2=-(2/nr_train_images)*delta2*[1;y1]';
    g3=-(2/nr_train_images)*delta3*[1;y2]';
    
    %velocity calculation and weights update (Momentum method)
    delta_w1=gamma*delta_w1-eta1*g1;%velocity
    delta_w2=gamma*delta_w2-eta2*g2;
    delta_w3=gamma*delta_w3-eta3*g3;
    w1=w1+delta_w1; %position
    w2=w2+delta_w2;
    w3=w3+delta_w3;
 
%     %weights update(Stochastic Gradient Descent)
%     w1=w1-eta1*g1;
%     w2=w2-eta2*g2;
%     w3=w3-eta3*g3;
    end
  
    errors(epoch)=0;
    MSE(epoch)=0;
    for i=1:nr_train_images
        y0=train_images(:,i);
        v1=w1*[1;y0];
        y1=sigmf(v1,[1,0]);
        %y1=tanh(v1);
        v2=w2*[1;y1];
        %y2=v2;
        y2=sigmf(v2,[10,0]);
        v3=w3*[1;y2];
        y3=v3;
        if train_labels(i)~= round(y3,0)
            errors(epoch)=errors(epoch)+1;
        end
        MSE(epoch)=MSE(epoch)+(1/nr_train_images)*((train_labels(i)-y3)^2);
    end
    
    subplot(2,2,1),plot(epoch,errors(epoch),'r*','Markersize',2);
    hold on
    subplot(2,2,2),plot(epoch,MSE(epoch),'r*','Markersize',2);
    hold on
    
    %% Test
    test_errors(epoch)=0;
    MSE_test(epoch)=0;
    for i=1:nr_test_images
    y0=test_images(:,i);
    v1=w1*[1;y0];
    y1=sigmf(v1,[1,0]);
    %y1=tanh(v1);
    v2=w2*[1;y1];
    %y2=v2;
    y2=sigmf(v2,[10,0]);
    v3=w3*[1;y2];
    y3=v3;
        if test_labels(i)~= round(y3,0)
           test_errors(epoch)=test_errors(epoch)+1; 
        end
    MSE_test(epoch)=MSE_test(epoch)+(1/nr_test_images)*((test_labels(i)-y3)^2);
    end
    subplot(2,2,3),plot(epoch,test_errors(epoch),'r*','Markersize',2);
    hold on
    subplot(2,2,4),plot(epoch,MSE_test(epoch),'r*','Markersize',2);
    hold on
    drawnow
    %% Early stopping
    if test_errors(epoch)>test_errors(epoch-1) && test_errors(epoch-1)>test_errors(epoch-2)
        flag=false;
    else 
        flag=true;
    end
    epoch=epoch+1;
end

if epoch==1
    s= [' Number of test errors : ',num2str(test_errors(epoch))];
    disp(s);
    s=[' Percentage of error : ',num2str(test_errors(epoch)*100/nr_test_images),' %'];
    disp(s);
    s=[' Success rate : ',100-(num2str(test_errors(epoch)*100/nr_test_images)),' %'];   
else
    s= [' Number of test errors : ',num2str(test_errors(epoch-3))];
    disp(s);
    s=[' Percentage of error : ',num2str(test_errors(epoch-3)*100/nr_test_images),' %'];
    disp(s);
    s=[' Success rate : ',num2str(100-test_errors(epoch-3)*100/nr_test_images),' %'];  
    disp(s);
end
