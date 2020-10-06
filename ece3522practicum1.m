% ./ece3522practicum1.m
% A Matlab project that considers an unfair die with 20% probability
% each of 1 - 4 and 10% probability of each 5, 6.
%      By: Leomar Duran <https://github.com/lduran2>
%    When: 2020-10-06t06:25
%     For: ECE 3522/Stochastic Processes
% Version: 1.0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHANGELOG
%     1.0 - Found the probabilities.

% Probabilities
pmf = [0.2, 0.2, 0.2, 0.2, 0.1, 0.1];   % probability mass function
cdf = calc_dcdf(pmf);                   % cumulative distribution function

[pmf ; cdf] % test pmf and cdf

%%
% Calculates a discrete cumulative distribution function from a give
% probability mass function.
% @params
%     pmf -- the probability mass function (copy)
% @returns the cumulative distribution function of the discrete r.v.
function result = calc_dcdf(pmf)
    % initialize total so far
    total = 0;
    % iterate pmf, keeping index
    for k = 1:length(pmf)
        total = total + pmf(k); % add to total
        pmf(k) = total;         % store total in copy
    end
    result = pmf;
end %dcdf(pmf)
