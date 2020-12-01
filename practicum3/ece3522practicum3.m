% ./practicum3/ece3522practicum3.m
% <https://github.com/lduran2/ece-3522-stochastic-processes-in-signals-and-systems/blob/master/practicum3/ece3522practicum3.m>
% A Matlab project that considers the transmission of a digital signal
%      By: Leomar Duran <https://github.com/lduran2>
%    When: 2020-12-07t13:55
%     For: ECE 3522/Stochastic Processes
% Version: 1.0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHANGELOG
%     1.0 - Implemented part 1, the theoretical probability of an
%           erronean detection.

clear
N = 1e5;                                % number of bits transmitted
SNR_dB = 5; %[dB]                       % signal-to-noise ratio

% Calculate v for SNR = 5 dB
v = 10^(SNR_dB/20);                     % transmit signal magnitude

%% Problem 1
% The probability to make an erroneous detection is equal to the
% probability that P(X < 0) in this case.
% Compute this probability for input SNR of 5 dB based on the
% cumulative distribution function (CDF).
P_err_5_dB = normcdf(-v);
fprintf('The probability to make an erroneous detection at (SNR = 5) dB,');
display(P_err_5_dB);
