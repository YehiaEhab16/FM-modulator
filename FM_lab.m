%%%% (1) %%%%
[signal,fs]=audioread('eric.wav'); %reading song
signal_f=fftshift(fft(signal));    %convert signal to frequency domain
signal_f_MAG=abs(signal_f);        %getting magnitude of spectrum
signal_f_PHASE=angle(signal_f);    %getting phase of spectrum
f=linspace(-fs/2,fs/2,length(signal_f));    %defining frequency interval

figure
subplot(2,1,1)
plot(f,signal_f_MAG);
title('MAGNITUDE');
subplot(2,1,2)
plot(f,signal_f_PHASE);
title('PHASE');        %plotting magnitude and phase of spectrum


%%%% (2) %%%%
signal_f([1:172000 length(signal_f)-172000+1:length(signal_f)])=0;  
%implementing low pass filter at 4kHz
signal_f_MAG=abs(signal_f); %getting magnitude of spectrum

figure
plot(f,signal_f_MAG);
title('MAGNITUDE AFTER FILTER'); %plotting magnitude of spectrum 


%%%% (3) %%%%
signal_t=real(ifft(ifftshift(signal_f)));  %convert signal to time domain
t=linspace(0,length(signal_f)/fs,length(signal_f)); %defining time interval

figure
plot(t,signal_t);
title('TIME DOMAIN AFTER FILTER');  %plotting signal after filter 


%%%% (4) %%%%
sound(signal_t,fs);     %playing sound after filter

figure
subplot(2,1,1)
plot(t,signal);
title('TIME DOMAIN BEFORE FILTER');
subplot(2,1,2)
plot(t,signal_t);
title('TIME DOMAIN AFTER FILTER'); %plotting signal before and after filter 


%%%% (5) %%%%
A=10;
kf=0.1;
fc=100000;
fs2=5*fc;   %defining constants for NBFM

NBFM_Signal = A*cos(2*pi*fc.*t'+kf*cumsum(signal_t));%generating NBFM signal
NBFM_Signal_f=abs(fftshift(fft(NBFM_Signal)));%convert signal to frequency domain
f=linspace(-fs2/2,fs2/2,length(NBFM_Signal_f));%defining new frequency range

figure
plot(f,NBFM_Signal_f);
title('FREQUENCY DOMAIN');  %plot signal in frequency domain


%%%% (7) %%%%
DEMOD_Signal=diff(NBFM_Signal);
envelope = abs(hilbert(DEMOD_Signal));
mean_signal=mean(envelope);
RECEIVED_Signal=envelope-mean_signal;   %demodulating signal
pause(9);
sound(RECEIVED_Signal,fs);  %playing sound after demodulation
