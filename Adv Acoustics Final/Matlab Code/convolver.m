%Name: Mahin Salman
%ID: N17316068
%Net id: ms6617
%
% CONVOLVER
%
% IRfilename: name of .wav file containing an impulse response
%
% SIGfilename: name of .wav file containing a signal
%
%outfile: name of .wav file to which the resulting (convolved) signal will be written
%
% convMethod: convolution method
% 1 = direct convolution
% 2 = fast convolution
%
%
% Outputs - None
%

function convolver (IRfilename, SIGfilename, OUTfile, convMethod)



validateattributes(IRfilename,{'char'},{},'','valid filename',1);

if length(IRfilename) >= 5
validatestring(IRfilename(end-3:end),{'.wav'},'','filename extension');

else error('filename must be longer than 5 characters and end with .wav')
end 

validateattributes(SIGfilename,{'char'},{},'','valid filename',2);
validatestring(SIGfilename(end-3:end),{'.wav'},'','filename extension');

if length(SIGfilename) >= 5
validatestring(SIGfilename(end-3:end),{'.wav'},'','filename extension');

else error('filename must be longer than 5 characters and end with .wav')
end

if length(OUTfile) >= 5
validatestring(OUTfile(end-3:end),{'.wav'},'','filename extension');

else error('filename must be longer than 5 characters and end with .wav')
end 


validateattributes(convMethod,{'double'}, {'positive','integer','<=', 2, '>=', 1}, '', ' Convolution method');


% Convolution method
[ir, irFS] = audioread(IRfilename);
[sig, sigFS] = audioread(SIGfilename);

%check and convert sample rates if necessary
if irFS > sigFS % if impulse response has higher sample rate
    ir=resample(ir,sigFS,irFS); % resample
    disp('Sample rate of impulse response changed to match signal file.');
elseif sigFS > irFS % if signal has higher sample rate
    sig=resample(sig,irFS,sigFS); % resample
    disp('Sample rate of signal file changed to match impulse response.');
    sigFS = irFS; % change sample rate, so output file is written in right SR
end


lenIr = length(ir);
lenSig = length(sig); 

if convMethod == 1 %1 is direct
    
% Direct Convolve 

outVec = zeros(lenSig + lenIr -1,1); 

for i=1:lenIr
   outVec(i:lenSig + i -1) = outVec(i:lenSig + i -1) + ir(i) * sig;    
end

convolvedSig = outVec;

else

% Fast convolve using fast fourier transform 
ir = [ir; zeros(lenSig -1, 1)];
sig = [sig; zeros(lenIr - 1,1)];

IR = fft(ir); 
SIG = fft(sig); 

CONVOLVED_SIG = IR .* SIG;

convolvedSig = ifft(CONVOLVED_SIG);
 
end

%Normalize
sigNorm = 0.999 * convolvedSig / max(abs(convolvedSig));


%Saves file as wav
audiowrite(OUTfile, sigNorm, sigFS)



end 