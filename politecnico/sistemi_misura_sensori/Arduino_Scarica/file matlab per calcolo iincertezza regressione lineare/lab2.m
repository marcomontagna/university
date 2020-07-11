tau=987.86*10^3*1*10^-6;
V0=1.1;
istanti=0:1:49;
R=987.86*10^3;
delta_r=198.79*10^3;
C=0.9801990*10^-6;
a=-1/(R*1000*C);

for i=1:1:50
    tensione(i)=V0*exp(-((i-1)/50)/tau);
end
incertezza_v=0.02./tensione;

vettore_tempo = istanti/50;
sum_parz=0;
for j=1:1:50
    sum_parz=sum_parz+vettore_tempo(j);
end 

media=sum_parz/50;

sum_quad=0;
sum_norm=0;
for l=1:1:50
    sum_quad=(vettore_tempo(i))^2+sum_quad;
    sum_norm=vettore_tempo(i)+sum_norm;  
end
denominatore=sum_quad-media^2*50;
sum_incertezze=(abs(vettore_tempo - media)).*incertezza_v;
delta_a=0;
for k=1:1:50
  delta_a=delta_a+sum_incertezze(k);
end
delta_a=delta_a/denominatore;
prima_parte=abs((1000*a)/(1000*R*a)^2)*delta_r
seconda_parte=abs((1000*R)/(1000*R*a)^2)*delta_a
delta_C=abs((1000*a)/(1000*R*a)^2)*delta_r+abs((1000*R)/(1000*R*a)^2)*delta_a