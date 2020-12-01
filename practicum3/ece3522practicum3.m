% ./practicum3/ece3522practicum3.m
% <https://github.com/lduran2/ece-3522-stochastic-processes-in-signals-and-systems/blob/master/practicum3/ece3522practicum3.m>
% A Matlab project that considers the transmission of a digital signal
%      By: Leomar Duran <https://github.com/lduran2>
%    When: 2020-12-01t15:23
%     For: ECE 3522/Stochastic Processes
% Version: 1.2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHANGELOG
%     v1.3 - 2020-12-01t15:23
%           [objective1] Abstracted out calcTheoErr and calcSignalMag.
%     v1.2 - 2020-12-01t14:17
%           [objective2] Calculated the simulated bit error rate.
%     v1.0 - 2020-12-01t13:55
%           [objective1] Calculated the theoretical probability of an
%           erroneous detection at SNR = 5 dB.

clear
N = 1e5;                                % number of bits transmitted
SNR_dB = 5; %[dB]                       % signal-to-noise ratio

% Calculate v for SNR = 5 dB
v = calcSignalMag(SNR_dB);              % transmit signal magnitude


%% Objective 1
% The probability to make an erroneous detection is equal to the
% probability that P(X < 0) in this case.
% Compute this probability for input SNR of 5 dB based on the
% cumulative distribution function (CDF).
P_theo_err_5_dB = calcTheoErr(SNR_dB);
fprintf('Theoretical probability of an erroneous detection at (SNR = 5 dB),');
display(P_theo_err_5_dB);


%% Objective 2
% Modify the Matlab code to compute the simulated bit error rate (BER),
% which is the ratio between the number of erroneously detected bits
% and the total number of transmitted bits, for input SNR of 5 dB.

% SNR is alread 5 dB

% from the lab manual appendix
signal = randi([0 1], N, 1);            % bit stream with 0's & 1's
noise = randn(N,1);                     % additive Gaussian noise
received = (signal*2-1)*v + noise;      % received noisy signal
detect = (received > 0);                % detected result
num_error = sum(abs(detect-signal));    % # of erroneously detected bits

% calculate the simulated bit error rate (BER)
BER = (num_error/N);
fprintf('Simulated bit error rate at (SNR = 5 dB),');
display(BER);

fprintf('Done.\n')    % finish


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculates the theoretical probability to make an erroneous
% detection, which equals the probability P(X < 0) s.t. X ~ N[0,1].
% @params
%     SNR_dB -- the signal to noise ratio [dB]
% @returns the theoretical probability to make an erroneous detection.
function P_theo_err = calcTheoErr(SNR_dB)
    v = calcSignalMag(SNR_dB);          % transmit signal magnitude
    P_theo_err = normcdf(-v);
end %function calcTheoErr(SNR_dB)


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculates the transmit signal magitude given a signal to noise
% ratio.
% @params
%     SNR_dB -- the signal to noise ratio [dB]
% @returns the transmit signal magitude.
function v = calcSignalMag(SNR_dB)
    v = 10^(SNR_dB/20);                 % transmit signal magnitude
end %function calcSignalMag(SNR_dB)
