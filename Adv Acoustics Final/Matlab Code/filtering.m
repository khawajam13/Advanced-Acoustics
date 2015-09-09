%Name: Mahin Salman
%ID: N17316068
%Net id: ms6617

[x, fs] = audioread('bubble_001_conv.wav');

% Cheby2 produced the best results, the alternatives have been left below
% for trial
%[B, A] = butter(10, .5, 'high');
%[B, A] = cheby1(10, .6, .4, 'low');
%[B, A] = cheby2(10, 40, .4, 'low');


filteredX = filter(B, A, x);

specgram(filteredX)

soundsc(filteredX, fs)

fvtool(B, A)