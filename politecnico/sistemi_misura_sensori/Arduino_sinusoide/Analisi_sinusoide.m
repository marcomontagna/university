 %{
clear all;
clc;
close all;
f=10;
dt=1/f;
N=1e4;
N2=30;
Vref=1.08;
t=linspace(0,dt,N);
t2=linspace(0,dt,N2);
clock=16e6;
scaler=128;
f_ad=clock/scaler/13;
t_ad=1/f_ad;
Vmax=0.486;
C=0.546;
sin_gen=Vmax*sin(2*pi*f*t)+C;
sin_ard=Vmax*sin(2*pi*f*t2)+C;
omega=2*pi*f;
omega_vect=linspace(omega-0.1*omega,omega+0.1*omega,100);
%figure,plot(t,sin_gen),grid on;
%figure,plot(t2,sin_ard),grid on;
matrice=ones(N2,3);
kdeltat=10e-6;
% for j=1:1:N2
for i=1:1:N2
 matrice(i,1) =  sin(omega_vect(51)*i*kdeltat);       
 matrice(i,2) =  cos(omega_vect(51)*i*kdeltat);   
end
parametri=inv(matrice'*matrice)*matrice'*sin_ard';
seno=[835 847 832 794 734 658 567 471 375 284 206 145 105 89 98 131 187 261 349 446 541 633 715 780 824 845 840 812 760 689 ];


for asd=1:1:N2
    seno(asd)=seno(asd)*Vref/1024;
end;
figure,plot(t2,seno),grid on;
%}
 % QUESTE SONO COSE PER FRNACESCA IL VERO CODICE è DOPO
% nPoint sono il numero dei campioni
 
% nPoints=30;%%numero campioni
% cose di scilab 
% startParam=f0;
% [param]=lsqcurvefit(modelSin, startParam, samples, nPoints); %%//prende il risultato di modelSin lo eleva al quadrato, ne fa la sommatoria per tutti i valori di sample e minimizza il risultato e restituisce la f A B C
% [ABC,yStim]=compSin(samples,stim)%% // non ho capito esattamente cosa fa, dovrebbe tirare fuori lambda  e il valore atteso che e' salvato in ystim
% [residui]=samples-yStim ;%%//calcolo dei residui
% 
% 
% function [e]=modelSin(p, nP) 
% [ABD,s]=compSin(samples,p); 
% e=s-samples; %differenza tra valori attesi e valori misurati
% end
% 
% function [ABC, s]=compSin(samples, p) 
% frequency=p; 
% omega=2*pi*frequency; 
% n=size(samples,1) ;
% U=zeros(n,3); 
% U(:,1)=sin(omega*t); 
% U(:,2)=cos(omega*t); 
% U(:,3)=1; 
% ABC=U\samples; %ABC=lambda
% s=U*ABC; %valori attesi
% end
clc; clear all; close all;
parametri_1=[];
parametri_2=[];
parametri_3=[];

%%%%%%%%%%%%%%%%%%% INIZIO CODICE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
f0=100;
omega=2*pi*f0;
%k=950/2*10^-3 %ampiezza sinusoide %in realtà questi due parametri non ci
%servono
%phi=45.5; %fase sinusoide
%C= 500*10^-3;
% fc=125000/13;
soglia=33;
prescaler_timer=256;
fc=16e6/prescaler_timer/soglia;
nPoints=20;%numero campioni
T=nPoints/fc;
Vref=1.09;
Voff=500e-3;
Vmax=450e-3;
%%
%  file=fopen("test.bin",'r+');
%  samples=fread(file,'int32');
% fclose(file); 
% samples_128=[107 226 370 522 670 795 884 928 921 866 765 633 482 331 192 85 20 3 36 118 ];%adc prescaler 128
% samples_64=[886 884 841 760 647 514 378 252 147 74 40 53 106 199 317 449 583 708 808 871];%adc prescaler 64
% samples_32=[181 98 48 44 86 169 284 421 560 691 798 866 892 870 806 704 575 435 297 179 ];
% samples_16=[758 647 511 371 240 134 67 39 62 126 230 358 497 633 752 839 888 888 841 753 ];
% samples_8=[610 480 335 207 112 56 48 73 152 259 396 536 670 780 864 896 880 824 728 608];
% samples_4=[385 513 647 768 864 896 896 831 768 632 496 352 224 124 62 48 71 143 255 385 ];
samples_2=[385 513 647 768 864 896 896 831 768 632 496 352 224 124 62 48 71 143 255 385 ];

 samples=samples_2;
for asd=1:1:nPoints
   samples(asd)=samples(asd)*Vref/1024;
end
tot=fc*T;
samples=samples';
t1=(1:20)/fc;
t2=(1:20)/fc;
samples=samples';
figure,plot(t2,samples),grid on,hold on;
prova=Vmax*sin(omega*t1+46.2)+Voff; %sinusoide sfasata di 45.5°
%plot(t1,prova,'g');

%%
%%%%%%%%%%%%%%%%%primo metodo conosco la frequenza e mi calcolo U
%  omega=2*pi*f0; 
 U=zeros(nPoints,3); %U è xdata 
 U(:,1)=sin(omega*t1); 
 U(:,2)=cos(omega*t1); 
 U(:,3)=1; 
%  parametri=inv(U'*U)*U'*samples';
 %parametri=inv(U'*U)*U'*sin_ard';
 
 ABC=U\samples'; %ABC=lambda
 %s2=U*parametri;
 s=U*ABC; %valori attesi
 figure, plot(1:20, samples, 1:20, s)
 figure,plot(1:20,samples-s','bs-' ),hold on;
%  figure,plot(t1,s);
 e=s-samples'; %residui
 %figure,plot(e,'.');
V_max_metodo_1=sqrt(ABC(1)^2+ABC(2)^2);
Fase_metodo_1=atan(ABC(2)/ABC(1));
Freq_metodo_1=f0;
%}

%%
% %%%%%%%%%%%secondo metodo non conosco la frequenza diventano 4 le incognite
% % %parametri iniziali:
%{r
 startParam=[ABC(1) ABC(2) ABC(3) f0];
%  parametri=vertcat(parametri,f0);
% % i parametri iniziali li calcolo prendendo i valori che escono di A B C e
% % frequenza dal metodo 1
%   
 fun = @(x,t)x(1)*sin(x(4)*(2*pi)*t)+x(2)*cos(x(4)*(2*pi)*t)+x(3);
 [param]=lsqcurvefit(fun, startParam, t1, samples);
%  [parametri_sin_ard]=lsqcurvefit(fun, parametri, t1, sin_ard);

 s2=U*param(1:3)'; %valori attesi
 plot(1:20,samples-s2','ko-' ),hold on;
V_max_metodo_2=sqrt(param(1)^2+param(2)^2);
Fase_metodo_2=atan(param(2)/param(1));
Freq_metodo_2=param(4);
%}
%%
% metodo tre- uso il metodo due per calcolare la frequenza e invece il
% metodo uno per calcolare A B C
% devo fare una funzione dove mi arriva in ingresso una f0 iniziale calcola
% A B C con il metodo uno e poi riusa la formula del metodo due, tira fuori y' fa la
% differenza minima attraverso lsqcurvefit
% in fun3 devo stare attenta ai sample, perchè entrano ma bisogna stare
% attenti
% fun = @(x,t)ABC(1)*sin(x/(2*pi)*t)+ABC(2)*cos(x/(2*pi)*t)+ABC(3);
% [param_freq]=lsqcurvefit(fun, f0, t1, samples,f0-f0/10,f0+f0/10);
F=fun3(f0, t1, samples);
%   f0-f0/200,f0+f0/200
[freq]=lsqcurvefit(F, f0, t1, samples);
s3=U*ABC; %valori attesi
plot(1:20,samples-s3','r.-' ),title('Residui'),legend('Residui metodo 1','Residui metodo 2',...
    'Residui metodo 3'),xlabel('campioni'),ylabel('residuo');
V_max_metodo_3=sqrt(ABC(1)^2+ABC(2)^2);
Fase_metodo_3=atan(ABC(2)/ABC(1));
Freq_metodo_3=freq;
%%

temp=horzcat(V_max_metodo_1,Fase_metodo_1,Freq_metodo_1);
parametri_1=vertcat(parametri_1,temp);
temp=horzcat(V_max_metodo_2,Fase_metodo_2,Freq_metodo_2);
parametri_2=vertcat(parametri_2,temp);
temp=horzcat(V_max_metodo_3,Fase_metodo_3,Freq_metodo_3);
parametri_3=vertcat(parametri_3,temp);



function F=fun3(f0, t1, samples)
 nPoints=20;
 omega=2*pi*f0; 
 U=zeros(nPoints,3); %U è xdata 
 U(:,1)=sin(omega*t1); 
 U(:,2)=cos(omega*t1); 
 U(:,3)=1; 
 ABC=U\samples'; %ABC=lambda
 s3=U*ABC; %valori attesi
 % e così ho fatto il metodo uno e ho trovato A B C e calcolato i valori
 % attesi
 F=@(x,t)ABC(1)*sin(x*(2*pi)*t)+ABC(2)*cos(x*(2*pi)*t)+ABC(3);
end