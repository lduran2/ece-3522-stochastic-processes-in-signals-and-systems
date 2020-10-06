% ./ece3522practicum1.m
% A Matlab project that considers an unfair die with 20% probability
% each of 1 - 4 and 10% probability of each 5, 6.
%      By: Leomar Duran <https://github.com/lduran2>
%    When: 2020-10-06t17:52
%     For: ECE 3522/Stochastic Processes
% Version: 1.2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHANGELOG
%     1.2 - Calculated 1000 dice faces.
%     1.0 - Calculated the cdf.

% Constants
N_ROLLS = 1000;                         % number of rolls requested
PMF = [0.2, 0.2, 0.2, 0.2, 0.1, 0.1];   % probability mass function

% Probabilities
cdf = calc_dcdf(PMF);   % cumulative distribution function

%% Part 1
% Generate a data sequence of 1,000 random integers between 1 and 6,
% representing the outcomes of tossing the unfair die 1,000 times.
probs = rand(N_ROLLS,1);        % generate probabilities of each roll
faces = diceFaces(probs, cdf);  % find the faces rolled

EX = [sum(faces)/N_ROLLS, PMF*((1:6)')] % test by finding expectations
                                        % both experimentally and through calculation
(EX(1) - EX(2))/EX(2)                   % calculate error

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
    end % for k
    result = pmf;
end %dcdf(pmf)

%%
% Calculates the dice faces given a matrix of probabilities and a XDF
% of a discrete r.v.
% @params
%     P   -- matrix of probabilities
%     cdf -- cumulative density function for discrete r.v.
% @returns the matrix of dice faces corresponding to the given
% probabilities.
function result = diceFaces(P, cdf)
    % start counting faces with 1
    faces = 1;
    % loop through CDFs
    for F = cdf
        % each greater face has CDF greater than or equal to all CDFs
        % before it
        faces = faces + (P >= F);
    end % for F
    result = faces;
end % diceFaces(P, cdf)
