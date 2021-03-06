% ./practicum3/ece3522practicum3.m
% <https://github.com/lduran2/ece-3522-stochastic-processes-in-signals-and-systems/blob/master/practicum3/ece3522practicum3.m>
% A Matlab project that considers the transmission of a digital signal
%      By: Leomar Duran <https://github.com/lduran2>
%    When: 2020-12-01t22:19
%     For: ECE 3522/Stochastic Processes
% Version: 1.7
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHANGELOG
%     v1.7 - 2020-12-01t22:19
%           [objective3] Added grid.
%                        Assigned the outputs of functions to plot to
%                            variables.
%                        Renamed `calcSimBer` to `simBer`.
%     v1.6 - 2020-12-01t17:26
%           [objective3] Fixed `calcSignalMag` matrix support.
%                        Graphed BER.
%     v1.4 - 2020-12-01t15:34
%           [objective2] Abstracted out calcSimBer.
%     v1.3 - 2020-12-01t15:23
%           [objective1] Abstracted out `calcTheoErr` and
%                           `calcSignalMag`.
%     v1.2 - 2020-12-01t14:17
%           [objective2] Calculated the simulated bit error rate.
%     v1.0 - 2020-12-01t13:55
%           [objective1] Calculated the theoretical probability of an
%                            erroneous detection at SNR = 5 dB.

clear
% parameters
N = 1e5;                                % number of bits transmitted
SNR_dB = 5; %[dB]                       % signal-to-noise ratio


%% Objective 1
% The probability to make an erroneous detection is equal to the
% probability that P(X < 0) in this case.
% Compute this probability for input SNR of 5 dB based on the
% cumulative distribution function (CDF).
P_theo_err_5_dB = calcTheoErr(SNR_dB);
fprintf('Theoretical probability of an erroneous detection at (SNR = %.1f dB),', SNR_dB);
display(P_theo_err_5_dB);


%% Objective 2
% Modify the Matlab code to compute the simulated bit error rate (BER),
% which is the ratio between the number of erroneously detected bits
% and the total number of transmitted bits, for input SNR of 5 dB.
BER = simBer(N, SNR_dB);
fprintf('Simulated bit error rate at (N = %d, SNR = %.1f dB),', N, SNR_dB);
display(BER);


%% Objective 3
% Plot the experimental and theoretical BER results (obtained in Part 1
% and Part 2) in the same plot for input SNR between -10 dB and 10 dB.
% The BER axis should be plotted using a log scale (using command
% semiology) and the input SNR should be plotted in dB. Include grid in
% the plot (using command “grid on”). See the attached figure in the
% top right as an example.

% SNR for input, [dB]
ES = 0;         % mean of SNR range
RS = 10;        % radius of SNR range
S = linspace((ES - RS), (ES + RS), ((2*RS) + 1));   % create linear space for SNR

% output vectors
Ysim = simBer(N, S);        %              simulated BER, to be in cyan line
Ythe = calcTheoErr(S);      % theoretical erroneous rate, to be in red asterisks

% perform the graphing
figure(1);
semilogy(S, Ysim, 'c-o', S, Ythe, 'r*');
grid on;
% scope the graph
xlim([-10 10]);
ylim([1e-4, 1e-0]);
% label the graph
title('BER, Experimental/Theoretic vs Input SNR');
legend('experimental', 'theoretical');
xlabel('Input SNR [dB]');
ylabel('BER');


%% finish
disp('Done.')


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
% Calculates the simulated bit error rate (BER).
% @params
%     N      -- the number of trials, or transmitted bits
%     SNR_dB -- the signal to noise ratio [dB]
% @returns the simulated bit error rate (BER).
function ber = simBer(N, SNR_dB)
    v = calcSignalMag(SNR_dB);              % transmit signal magnitude
    % from the lab manual appendix
    signal = randi([0 1], N, 1);            % bit stream with 0's & 1's
    noise = randn(N,1);                     % additive Gaussian noise
    received = (signal*2-1)*v + noise;      % received noisy signal
    detect = (received > 0);                % detected result
    num_error = sum(abs(detect-signal));    % # of erroneously detected bits
    % perform the calculation
    ber = (num_error/N);                    % the simulated bit error rate (BER)
end %function simBer(N, SNR_dB)


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculates the transmit signal magitude given a signal to noise
% ratio.
% @params
%     SNR_dB -- the signal to noise ratio [dB]
% @returns the transmit signal magitude.
function v = calcSignalMag(SNR_dB)
    v = 10.^(SNR_dB/20);                    % transmit signal magnitude
end %function calcSignalMag(SNR_dB)
