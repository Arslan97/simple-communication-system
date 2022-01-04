%1-transmitter 
[s,fs]=audioread('Galneryus - A Far-off Distance (sub. español)_2.mp3'); n=0 ;
s=s(1:40*fs,:);
s = s(:,1);                              % defining the signal vector size 
dt = 1/fs;
t = 0:dt:(length(s)*dt)-dt;

%plotting signal in time domain
plot(t,s); xlabel('Seconds'); ylabel('Amplitude');title('time signal');

%transforming signal into frequency domain 
fdomain=linspace(-fs/2,fs/2,length(s));               %frequency base vector
sfd=fftshift(fft(s));
sfdmag=abs(sfd);

%plotting siganl in frequency domain
figure; plot(fdomain,sfdmag) ;title('frequency signal');

%playing sound file
ready = true 
while ready
player= input('Select option\n  (1)play file\n  (2)stop file\n (3)Exit\n ');
switch player
    case 1
        sound(s,fs);
    case 2
        clear sound
    case 3
        ready = false ;
end
end 

%2-Channels
Channel = input ('Select Channel\n (1)Channel 1 \n (2)Channel 2 \n (3)Channel 3 \n (4)Channel 4 \n ');
 switch Channel
    
     case 1
         d=zeros(1,length(s)); %delta function
         d(1)=1; 
         y=conv(s,d);  %convolution
         
         %time base vector
          t1 = 0:dt:(length(y)*dt)-dt;
          figure
          plot(t1,y) ; title('impulse response');
          n=1;
         
    
     case 2
         d=exp(-2*pi*5000/fs);
         y=conv(s,d);
         
         %time base vector
         t1 = 0:dt:(length(y)*dt)-dt;
         figure
         plot(t1,y) ; title('exponent1');
     
     case 3
         d=exp(-2*pi*1000/fs);
         y=conv(s,d);
         
         %time base vector
         t1 = 0:dt:(length(y)*dt)-dt;
         sound (y,fs);
         figure;
         plot(t1,y) ; title('exponent2') ;  
         
     case 4
         d=zeros(1,length(s));
         d(1)=2;
         d(2)=0.5;
         y=conv(s,d);
         
         %time base vector
         t1 = 0:dt:(length(y)*dt)-dt;
         figure
         plot(t1,y) ; title('the drawing delta function') ;
         n=1;
 end
      
 %3-Noise
sigma = input ('Noise>>please enter the value of sigma: \n ');
noise=sigma.*randn(1,length(y));

if n==1
    ynew=y+noise;                                                   %defining new variable for extracting noise 
    sound(ynew,fs)                                                  %hearing noise + song  
    t2 = 0:dt:(length(ynew)*dt)-dt;                           %defining new time base
    fdomain=linspace(-fs/2,fs/2,length(ynew));      %defining new frequency base 
    
    figure
    plot(t2,ynew); title('time domain noise') ;
    ynew1=fftshift(fft(ynew));
    ymag=abs(ynew1);
    figure
    plot(fdomain,ymag); title('frequency domain noise ');
else
     ynew=y'+noise;
     sound(ynew,fs)
     t2 = 0:dt:(length(ynew)*dt)-dt;
     fdomain=linspace(-fs/2,fs/2,length(ynew));
   
     figure
     plot(t2,ynew); title('n=~1 time domain noise') ;
     ynew1=fftshift(fft(ynew));
     ymag=abs(ynew1);
     figure
     plot(fdomain,ymag) ; title('n=~1 frequency domain noise');
 end
 
% 4- Filter
go = true;
while go
filter = input ('choose an option \n (1)Continue \n   (2)Exit \n ');
 switch filter 
     case 1
        a=((length (ynew))/fs)*(fs/2-3400); %initial index @ -3.4KHz 
        b=((length (ynew))/fs)*(fs/2+3400); %final index @ 3.4KHz
       
        % rounding each element of "ynew" to the nearest integer
        e=round(a); 
        c=round(b);
        ynew1([1:e c:length(ynew)])=0; %filter range
        x=ynew1;
        ynew2mag=abs(x);
        figure
        plot(fdomain,ynew2mag); title('sound output after filtering in frequency domain');

        %plot sound output in time domain 
        x1=real(ifftshift(ifft(x)));
        figure
        plot(t2,x1);title('sound output after filtering in time domain');
        sound(x1,fs);
    
     case 2
         go=false ;
         clear sound
  
 end
 end
 
 