[filename,pathname] =uigetfile("MultiSelect","off",'*.wav');
[y,fs] = audioread([pathname filename]);
y1 = decimate(y,100); fs=fs/100;
[b,a] = cheby1(2,2,[20 160]/fs,'bandpass');
y2 = filter(b,a,y1);
t = 0:1/fs:(length(y1)-1)/fs;
figure
subplot(211)
plot(t,y1);
xlabel('Time(s)');
ylabel('Amplitude (V)');
title('Original Signal');
subplot(212)
plot(t,y2);
xlabel('Time(s)');
ylabel('Amplitude (V)');
title('Filtered Signal');
figure
[cfs,f] = cwt(y2,'amor',fs);
surface(t,f,abs(cfs))
axis tight
shading flat
xlabel('Time (s)')
ylabel('Frequency (Hz)')
title('2D Plot of Continuous Wavelet Transform');
set(gca,'yscale','log');
view(2);
[xx,yy] = size(abs(cfs));%f,t=i,
sum1 = mean(abs(cfs),1);
windowSize = 10;
b = (1/windowSize)*ones(1,windowSize);
a = 1;
smoothsum1 = filter(b,a,sum1);
    figure
    tt1 = 0:1/fs:(length(sum1)-1)/fs;

    subplot(311)
plot(tt1,sum1);
xlabel('Time(s)');
ylabel('Amplitude (V)');
title('Wavelet Energy Plot');
subplot(312)
plot(tt1,smoothsum1);
xlabel('Time(s)');
ylabel('Amplitude (V)');
title('Smoothened Wavelet Energy Plot');
savg = smoothsum1-mean(smoothsum1);
subplot(313)
hold on
t1 = 0:1/fs:(length(savg)-1)/fs;
plot(t1,savg);
xlabel('Time(s)');
ylabel('Amplitude (V)');
title('Corrected Smoothened Wavelet Energy Plot with Segmented Boundaries');
zci = @(v) find(v(:).*circshift(v(:), [-1 0]) <= 0);
[locs]=zci(savg);
%plot(t1(locs),0,'*r');
%hold off;
indx = find(locs);
for i=0:round(length(indx))/4-1
  plot(t(locs(i*4+1)),0,'*r');
end
for i=0:round(length(indx))/4-1
  plot(t(locs(i*4+2)),0,'*r');
end
for i=0:round(length(indx))/4-1
  plot(t(locs(i*4+3)),0,'*m');
end
for i=0:round(length(indx))/4-1
  plot(t(locs(i*4+4)),0,'*m');
end
hold off;
figure
hold on
plot(t,y1);
for i=0:round(length(indx))/4-1
  plot(t(locs(i*4+1)),0,'*r');
end
for i=0:round(length(indx))/4-1
  plot(t(locs(i*4+2)),0,'*r');
end
for i=0:round(length(indx))/4-1
  plot(t(locs(i*4+3)),0,'*m');
end
for i=0:round(length(indx))/4-1
  plot(t(locs(i*4+4)),0,'*m');
end
hold off;
xlabel('Time(s)');
ylabel('Amplitude (V)');
title('Original Segmented Signal');