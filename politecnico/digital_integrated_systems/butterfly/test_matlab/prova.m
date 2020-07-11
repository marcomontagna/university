close all
clear all


parola = 24;
frazione = 23;
%%
Ar = fi(1-1/2^23, 1, parola, frazione,'SumMode', 'SpecifyPrecision', 'SumWordLength', 2 * parola + 1, 'SumFractionLength', 2 * frazione,'ProductMode', 'KeepLSB', 'ProductWordLength', 2 * parola - 1,'RoundingMethod','Nearest');
Ai = fi(0.875, 1, parola, frazione,'SumMode', 'SpecifyPrecision', 'SumWordLength', 2 * parola + 1, 'SumFractionLength', 2 * frazione, 'ProductMode', 'KeepLSB', 'ProductWordLength', 2 * parola - 1,'RoundingMethod','Nearest');
Br = fi(1-1/2^23, 1, parola, frazione, 'SumMode', 'SpecifyPrecision', 'SumWordLength', 2 * parola + 1, 'SumFractionLength', 2 * frazione,'ProductMode', 'KeepLSB', 'ProductWordLength', 2 * parola - 1, 'RoundingMethod', 'Nearest');
Bi = fi(1-1/2^23, 1, parola, frazione,'SumMode', 'SpecifyPrecision', 'SumWordLength', 2 * parola + 1, 'SumFractionLength', 2 * frazione, 'ProductMode', 'KeepLSB', 'ProductWordLength', 2 * parola - 1, 'RoundingMethod', 'Nearest');
Wr = fi(1-1/2^23, 1, parola, frazione,'SumMode', 'SpecifyPrecision', 'SumWordLength', 2 * parola + 1, 'SumFractionLength', 2 * frazione, 'ProductMode', 'KeepLSB', 'ProductWordLength', 2 * parola - 1,'RoundingMethod', 'Nearest' );
Wi = fi(-1+1/2^23, 1, parola, frazione,'SumMode', 'SpecifyPrecision', 'SumWordLength', 2 * parola + 1, 'SumFractionLength', 2 * frazione, 'ProductMode', 'KeepLSB', 'ProductWordLength', 2 * parola - 1,'RoundingMethod', 'Nearest');
Ar1_max = Ar+Br*Wr-Bi*Wi;
Ai1_max = Ai+Br*Wi+Bi*Wr;
Br1_max = 2*Ar-Ar1_max;
Bi1_max = 2*Ai-Ai1_max;


Ar1_din = fi(Ar1_max, 1, parola, frazione-2,'RoundingMethod', 'Floor');
Ai1_din = fi(Ai1_max, 1, parola, frazione-2,'RoundingMethod', 'Floor');
Br1_din = fi(Br1_max, 1, parola, frazione-2,'RoundingMethod', 'Floor');
Bi1_din = fi(Bi1_max, 1, parola, frazione-2,'RoundingMethod', 'Floor');
% massimizzo ar primo
a=Br1_din.bin
b=Bi1_din.bin
c=Ar1_din.bin
d=Ai1_din.bin
%% prova




Ar = fi(-0.25, 1, parola, frazione,'SumMode', 'SpecifyPrecision', 'SumWordLength', 2 * parola + 1, 'SumFractionLength', 2 * frazione,'ProductMode', 'KeepLSB', 'ProductWordLength', 2 * parola - 1, 'RoundingMethod', 'Nearest' );
Ai = fi(0.875, 1, parola, frazione,'SumMode', 'SpecifyPrecision', 'SumWordLength', 2 * parola + 1, 'SumFractionLength', 2 * frazione, 'ProductMode', 'KeepLSB', 'ProductWordLength', 2 * parola - 1,'RoundingMethod', 'Nearest');
Br = fi(0.75, 1, parola, frazione, 'SumMode', 'SpecifyPrecision', 'SumWordLength', 2 * parola + 1, 'SumFractionLength', 2 * frazione,'ProductMode', 'KeepLSB', 'ProductWordLength', 2 * parola - 1, 'RoundingMethod', 'Nearest');
Bi = fi(-0.5, 1, parola, frazione,'SumMode', 'SpecifyPrecision', 'SumWordLength', 2 * parola + 1, 'SumFractionLength', 2 * frazione, 'ProductMode', 'KeepLSB', 'ProductWordLength', 2 * parola - 1, 'RoundingMethod', 'Nearest');
Wr = fi(0.5, 1, parola, frazione,'SumMode', 'SpecifyPrecision', 'SumWordLength', 2 * parola + 1, 'SumFractionLength', 2 * frazione, 'ProductMode', 'KeepLSB', 'ProductWordLength', 2 * parola - 1,'RoundingMethod', 'Nearest' );
Wi = fi(0.5, 1, parola, frazione,'SumMode', 'SpecifyPrecision', 'SumWordLength', 2 * parola + 1, 'SumFractionLength', 2 * frazione, 'ProductMode', 'KeepLSB', 'ProductWordLength', 2 * parola - 1,'RoundingMethod', 'Nearest');
Ar1_max = Ar+Br*Wr-Bi*Wi;
Ai1_max = Ai+Br*Wi+Bi*Wr;
Br1_max = 2*Ar-Ar1_max;
Bi1_max = 2*Ai-Ai1_max;


Ar1_din = fi(Ar1_max, 1, parola, frazione-2,'RoundingMethod', 'Floor');
Ai1_din = fi(Ai1_max, 1, parola, frazione-2,'RoundingMethod', 'Floor');
Br1_din = fi(Br1_max, 1, parola, frazione-2,'RoundingMethod', 'Floor');
Bi1_din = fi(Bi1_max, 1, parola, frazione-2,'RoundingMethod', 'Floor');

a=Br1_din.bin
b=Bi1_din.bin

c=Ar1_din.bin
d=Ai1_din.bin
%% minimizzo Br' pos
Ar = fi(1-1/2^23, 1, parola, frazione,'SumMode', 'SpecifyPrecision', 'SumWordLength', 2 * parola + 1, 'SumFractionLength', 2 * frazione,'ProductMode', 'KeepLSB', 'ProductWordLength', 2 * parola - 1, 'RoundingMethod', 'Nearest' );
Ai = fi(0.875, 1, parola, frazione,'SumMode', 'SpecifyPrecision', 'SumWordLength', 2 * parola + 1, 'SumFractionLength', 2 * frazione, 'ProductMode', 'KeepLSB', 'ProductWordLength', 2 * parola - 1,'RoundingMethod', 'Nearest');
Br = fi(1-1/2^23, 1, parola, frazione, 'SumMode', 'SpecifyPrecision', 'SumWordLength', 2 * parola + 1, 'SumFractionLength', 2 * frazione,'ProductMode', 'KeepLSB', 'ProductWordLength', 2 * parola - 1, 'RoundingMethod', 'Nearest');
Bi = fi(1/2^23, 1, parola, frazione,'SumMode', 'SpecifyPrecision', 'SumWordLength', 2 * parola + 1, 'SumFractionLength', 2 * frazione, 'ProductMode', 'KeepLSB', 'ProductWordLength', 2 * parola - 1, 'RoundingMethod', 'Nearest');
Wr = fi(1-1/2^23, 1, parola, frazione,'SumMode', 'SpecifyPrecision', 'SumWordLength', 2 * parola + 1, 'SumFractionLength', 2 * frazione, 'ProductMode', 'KeepLSB', 'ProductWordLength', 2 * parola - 1,'RoundingMethod', 'Nearest' );
Wi = fi(1/2^23, 1, parola, frazione,'SumMode', 'SpecifyPrecision', 'SumWordLength', 2 * parola + 1, 'SumFractionLength', 2 * frazione, 'ProductMode', 'KeepLSB', 'ProductWordLength', 2 * parola - 1,'RoundingMethod', 'Nearest');
Ar1_max = Ar+Br*Wr-Bi*Wi;
Ai1_max = Ai+Br*Wi+Bi*Wr;
Br1_max = 2*Ar-Ar1_max;
Bi1_max = 2*Ai-Ai1_max;


Ar1_din = fi(Ar1_max, 1, parola, frazione-2,'RoundingMethod', 'Floor');
Ai1_din = fi(Ai1_max, 1, parola, frazione-2,'RoundingMethod', 'Floor');
Br1_din = fi(Br1_max, 1, parola, frazione-2,'RoundingMethod', 'Floor');
Bi1_din = fi(Bi1_max, 1, parola, frazione-2,'RoundingMethod', 'Floor');

a=Br1_din.bin
b=Bi1_din.bin
c=Ar1_din.bin
d=Ai1_din.bin

%% ora massimizzo Ai' in neg
Ar = fi(0.9375, 1, parola, frazione,'SumMode', 'SpecifyPrecision', 'SumWordLength', 2 * parola + 1, 'SumFractionLength', 2 * frazione,'ProductMode', 'KeepLSB', 'ProductWordLength', 2 * parola - 1, 'RoundingMethod', 'Nearest' );
Ai = fi(-1+1/2^23, 1, parola, frazione,'SumMode', 'SpecifyPrecision', 'SumWordLength', 2 * parola + 1, 'SumFractionLength', 2 * frazione, 'ProductMode', 'KeepLSB', 'ProductWordLength', 2 * parola - 1,'RoundingMethod', 'Nearest');
Br = fi(-1+1/2^23, 1, parola, frazione, 'SumMode', 'SpecifyPrecision', 'SumWordLength', 2 * parola + 1, 'SumFractionLength', 2 * frazione,'ProductMode', 'KeepLSB', 'ProductWordLength', 2 * parola - 1, 'RoundingMethod', 'Nearest');
Bi = fi(-1+1/2^23, 1, parola, frazione,'SumMode', 'SpecifyPrecision', 'SumWordLength', 2 * parola + 1, 'SumFractionLength', 2 * frazione, 'ProductMode', 'KeepLSB', 'ProductWordLength', 2 * parola - 1, 'RoundingMethod', 'Nearest');
Wr = fi(1-1/2^23, 1, parola, frazione,'SumMode', 'SpecifyPrecision', 'SumWordLength', 2 * parola + 1, 'SumFractionLength', 2 * frazione, 'ProductMode', 'KeepLSB', 'ProductWordLength', 2 * parola - 1,'RoundingMethod', 'Nearest' );
Wi = fi(1-1/2^23, 1, parola, frazione,'SumMode', 'SpecifyPrecision', 'SumWordLength', 2 * parola + 1, 'SumFractionLength', 2 * frazione, 'ProductMode', 'KeepLSB', 'ProductWordLength', 2 * parola - 1,'RoundingMethod', 'Nearest');
Ar1_max = Ar+Br*Wr-Bi*Wi;
Ai1_max = Ai+Br*Wi+Bi*Wr;
Br1_max = 2*Ar-Ar1_max;
Bi1_max = 2*Ai-Ai1_max;


Ar1_din = fi(Ar1_max, 1, parola, frazione-2,'RoundingMethod', 'Floor');
Ai1_din = fi(Ai1_max, 1, parola, frazione-2,'RoundingMethod', 'Floor');
Br1_din = fi(Br1_max, 1, parola, frazione-2,'RoundingMethod', 'Floor');
Bi1_din = fi(Bi1_max, 1, parola, frazione-2,'RoundingMethod', 'Floor');

a=Br1_din.bin
b=Bi1_din.bin
c=Ar1_din.bin
d=Ai1_din.bin
%% modalita continua 
vAr=[0.5,2^-23+2^-7];
vAi=[-0.875,-1+2^-12+2^-8];
vBr=[0.125,-1+2^-11+2^-18];
vBi=[-1+2^-12+2^-8+2^-16+2^-5,1-(+2^-5+2^-3)];
vWr=[2^-23,1-2^-23];
vWi=[0.375,0.75];
Ar = fi(vAr, 1, parola, frazione,'SumMode', 'SpecifyPrecision', 'SumWordLength', 2 * parola + 1, 'SumFractionLength', 2 * frazione,'ProductMode', 'KeepLSB', 'ProductWordLength', 2 * parola - 1, 'RoundingMethod', 'Nearest' );
Ai = fi(vAi, 1, parola, frazione,'SumMode', 'SpecifyPrecision', 'SumWordLength', 2 * parola + 1, 'SumFractionLength', 2 * frazione, 'ProductMode', 'KeepLSB', 'ProductWordLength', 2 * parola - 1,'RoundingMethod', 'Nearest');
Br = fi(vBr, 1, parola, frazione, 'SumMode', 'SpecifyPrecision', 'SumWordLength', 2 * parola + 1, 'SumFractionLength', 2 * frazione,'ProductMode', 'KeepLSB', 'ProductWordLength', 2 * parola - 1, 'RoundingMethod', 'Nearest');
Bi = fi(vBi, 1, parola, frazione,'SumMode', 'SpecifyPrecision', 'SumWordLength', 2 * parola + 1, 'SumFractionLength', 2 * frazione, 'ProductMode', 'KeepLSB', 'ProductWordLength', 2 * parola - 1, 'RoundingMethod', 'Nearest');
Wr = fi(vWr, 1, parola, frazione,'SumMode', 'SpecifyPrecision', 'SumWordLength', 2 * parola + 1, 'SumFractionLength', 2 * frazione, 'ProductMode', 'KeepLSB', 'ProductWordLength', 2 * parola - 1,'RoundingMethod', 'Nearest' );
Wi = fi(vWi, 1, parola, frazione,'SumMode', 'SpecifyPrecision', 'SumWordLength', 2 * parola + 1, 'SumFractionLength', 2 * frazione, 'ProductMode', 'KeepLSB', 'ProductWordLength', 2 * parola - 1,'RoundingMethod', 'Nearest');

primo=Br.bin
secondo=Wr.bin
terzo=Bi.bin
quarto=Ar.bin
quinto=Wi.bin
sesto=Ai.bin
for i=1:2
Ar1_max(i) = Ar(i)+Br(i).*Wr(i)-Bi(i).*Wi(i);
Ai1_max(i) = Ai(i)+Br(i).*Wi(i)+Bi(i).*Wr(i);
Br1_max(i) = 2*Ar(i)-Ar1_max(i);
Bi1_max(i)= 2*Ai(i)-Ai1_max(i);
end

Ar1_din = fi(Ar1_max, 1, parola, frazione-2,'RoundingMethod','Floor');
Ai1_din = fi(Ai1_max, 1, parola, frazione-2,'RoundingMethod','Floor');
Br1_din = fi(Br1_max, 1, parola, frazione-2,'RoundingMethod','Floor');
Bi1_din = fi(Bi1_max, 1, parola, frazione-2,'RoundingMethod','Floor');

a=Br1_din.bin
b=Bi1_din.bin
c=Ar1_din.bin
d=Ai1_din.bin