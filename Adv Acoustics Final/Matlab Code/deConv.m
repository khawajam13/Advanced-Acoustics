function [ y_Circ ] = deConv( recorded, signal, OUTfile)

[ir, irFS] = audioread(recorded);
[sig, sigFS] = audioread(signal);



%check and convert sample rates if necessary
if irFS > sigFS % if impulse response has higher sample rate
    ir=resample(ir,sigFS,irFS); % resample
    disp('Sample rate of impulse response changed to match sig file.');
elseif sigFS > irFS % if signal has higher sample rate
    sig=resample(sig,irFS,sigFS); % resample
    disp('Sample rate of sig file changed to match impulse response.');
    sigFS = irFS; % change sample rate, so output file is written in right SR
end

% Create time and frequency vector for final spectrum
timeVec = linspace(0, length(sig)/sigFS,length(sig));


%CIRCDECONV Circular Deconvolution using FFT
if isrow(ir) ir = ir'; end
if isrow(sig) sig = sig'; end

ir = [zeros(round(0.5*sigFS),1); ir; zeros(0.5*sigFS,1)];
sig = [zeros(round(0.5*sigFS),1); sig; zeros(0.5*sigFS,1)];

h_Freq = fft(ir, 2^nextpow2(length(ir)));
x_Freq = fft(sig, 2^nextpow2(length(ir)));

y_Circ = real(ifft(h_Freq./x_Freq));

%Saves file as wav
audiowrite(OUTfile, y_Circ, sigFS)

% % Create time and frequency vector for final spectrum
% timeVec = linspace(0, length(sig)/sigFS,length(sig));
% create freq axis vector
freqs = linspace(0,sigFS/2, 2^nextpow2(length(ir))); 

%Final Spectrum
imagesc( y_Circ);
set(gca,'YDir','normal')
axis('xy');


end

