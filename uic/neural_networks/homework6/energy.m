clear all
close all
clc

%% Computation of the energy of the states

x=[+1;+1];
b=[0.5;-1];
w=[0 -1; -1 1];
E=-(x'*w*x+2*b'*x)
