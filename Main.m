clear all;clc
[z,fs] = audioread('EQ2401project1data2019.wav');
%soundsc(z,fs)
%figure
%plot(z);
%f=linspace(-fs/2,fs/2,length(z));
%SpecM=fftshift(fft(z,length(z)));
%figure
%plot(f,abs(SpecM))
q=z(41500:51000);

%FIR Wiener Filtering order

%Theta optimal parametric estimation
r=xcorr(z,z,'biased'); rz = r(70001:70001+5000); r1 = xcorr(q,q,'biased');
rq = r1(9501:9501+5000); rzx = rz - rq;rxz = rzx.';
E = 0;
%Wiener Filter order estimation
for M = 1:1:100
    R = toeplitz(rz(1:M),rz(1:M));  
    a =  R \ rzx(1:M);
    MSE_Y(M) = rzx(1)-rxz(1:M)*inv(R)*rzx(1:M);
end
%figure;bar(MSE_Y);
R = toeplitz(rz(1:35),rz(1:35));
theta_opt = inv(R)*rzx(1:35);
y = filter(theta_opt,1,z);
%soundsc(y);
%AR order estimation of speech
sigma_X = 0;
for M = 1:1:35
    Rzx = toeplitz(rzx(1:M),rzx(1:M));  
    b =  -Rzx \ rzx(2:M+1);
    c = [1;b];
    sigma_X(M) = rzx(1:M+1).'*c;
end
figure;bar(sigma_X);title('MSE of signal');
M = 20;
Rzx = toeplitz(rzx(1:M),rzx(1:M));  
b =  -Rzx \ rzx(2:M+1);
c = [1;b];
theta_speech = c;
sigma_XX=sigma_X(M);
%AR order estimation of noise
sigma_Q = 0;
for M = 1:1:35
    R1 = toeplitz(rq(1:M),rq(1:M));  
    b =  -R1 \ rq(2:M+1);
    c = [1;b];
    sigma_Q(M) = rq(1:M+1).'*c;
end
M= 19;
R1 = toeplitz(rq(1:M),rq(1:M));  
b =  -R1 \ rq(2:M+1);
c = [1;b];
theta_noise = c;
sigma_QQ = sigma_Q(M);

figure;bar(sigma_Q);title('MSE of noise');
[PhixyNum,PhixyDen,PhiyyNum,PhiyyDen] = spec_add_0216(theta_speech,sigma_XX,theta_noise,sigma_QQ);


y_nc = ncw(z,PhixyNum,PhixyDen,PhiyyNum,PhiyyDen);
%y_nc = ncfilt(z,PhixyNum,PhixyDen,PhiyyNum,PhiyyDen);
%soundsc(y_nc);
[y_c,num,den]=cw(z,PhixyNum,PhixyDen,PhiyyNum,PhiyyDen,0);
%soundsc(y_c)

figure;
subplot(3,1,1)
plot(z);%title('The original Signal');
hold on;
plot(y,'r');title('FIR Wiener Filtered Signal');
hold off;
subplot(3,1,2)
plot(z);hold on;
plot(y_nc,'r');title('NCIIR Wiener Filtered Signal');
hold off;
subplot(3,1,3)
plot(z);hold on;
plot(y_c,'r');title('CIIR Wiener Filtered Signal');
hold off;
figure;
freqz(theta_opt,1,1024);title('Frequency response of FIR WF');
figure;
freqz(conv(PhixyNum,PhiyyDen),conv(PhixyDen,PhiyyNum),1024);
title('Frequency response of NCIIR WF');
figure;
freqz(num,den,1024);title('Frequency response of CIIR WF');