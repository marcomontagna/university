% ECE 559 Neural Networks - Fall 2018
% Montagna Marco
% Hw 6

clear all
close all
clc

sign=@(x) 1*(x>=0)-1*(x<0);
%% spurious memory pattern search
n=16;
m=4;
flag=0;

while flag==0
    W=0;
    x=sign(randi([-1 1],m,n));
    for i=1:n
        W=W+x(:,i)*x(:,i)';
    end
    
    trial=0;
    
    while flag==0 && trial<2*2^m
        z=sign(randi([-1 1],m,1));
        y=sign(W*z);
        % check proprieties z
        if isequal(y,z) 
            equal=0;
            for i=1:n
                if isequal(z,x(:,i)) || isequal(z,-x(:,i))
                    equal=1;
                end
            end

            if equal==0
                s=('X =');
                disp(s);
                disp(x);
                s=('Spourious pattern found.');
                disp(s);
                s=('Z=');
                disp(s);
                disp(z);
                flag=1;
            end
        end
        trial=trial+1;
    end
end