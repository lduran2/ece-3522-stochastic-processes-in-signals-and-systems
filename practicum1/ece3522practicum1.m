% ./practicum1/ece3522practicum1.m
% <https://github.com/lduran2/ece-3522-stochastic-processes-in-signals-and-systems/blob/master/practicum1/ece3522practicum1.m>
% A Matlab project that considers an unfair die with 20% probability
% each of 1 - 4 and 10% probability of each 5, 6.
%      By: Leomar Duran <https://github.com/lduran2>
%    When: 2020-10-07t05:56
%     For: ECE 3522/Stochastic Processes
% Version: 1.7
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHANGELOG
%     1.7 - Moved computation of properties into its own function.
%     1.6 - Calculated expectation, standard deviation,
%           P(X = 6|X >= 4).
%     1.4 - Calculated, displayed and stem plotted relative
%           frequencies.
%     1.2 - Calculated 1000 dice faces.
%     1.0 - Calculated the cdf.

% Constants
N_ROLLS = 1000;                         % number of rolls requested
PMF = [0.2, 0.2, 0.2, 0.2, 0.1, 0.1];   % probability mass function

% iterable for X
nImgX = length(PMF);    % cardinality of Image of X
imgX = (1:nImgX);       % the image of X

% Probabilities
cdf = calc_dcdf(PMF);   % cumulative distribution function

%% Part 1
% Generate a data sequence of 1,000 random integers between 1 and 6,
% representing the outcomes of tossing the unfair die 1,000 times.
probs = rand(N_ROLLS,1);        % generate probabilities of each roll
faces = diceFaces(probs, cdf);  % find the faces rolled

% Report the value ... the relative frequency of each face ... which
% should be close to the probability mass function.
cards = absFreq(faces, nImgX);          % find the absolute frequencies
freqs = (cards/N_ROLLS);                % calc the relative frequencies
errFreqs = ((freqs - PMF)./PMF);        % calc the relative errors
% loop through X values
for k = imgX
    fprintf('The frequency of %d is %0.4f,', k, freqs(k));
    fprintf(' with relative error %+0.4f.\n', errFreqs(k));
end % for k

% and plot the relative frequency of each face
figure(1);                                      %  open figure
stem(imgX, freqs)   % draw stem plot of rel frequencies vs dice faces
title('Relative frequencies vs dice faces');    % title figure
xlabel('Dice faces (k)');                       % label x-axis (k)
ylabel('Relative frequencies (P_X(k))');        % label y-axis (PX(k))
xlim([1,(nImgX + 0.5)])                         % k in Img(X)
ylim([0,(max(PMF) + 0.05)])                     % PX(k) in [0,1]

%% Part 2
% Compute the expectation, standard deviation, P(X = 6|X >= 4)
[EX, sX, P_X6_Xge4] = computeProperties(imgX, nImgX, cards, freqs, N_ROLLS);

% display the results
fprintf('\n                            The average value of X is\t%0.4f.\n', EX);
fprintf(  '                       The standard deviation of X is\t%0.4f.\n', sX);
fprintf(  'The probability rolling a 6 given the roll is >= 4 is\t%0.4f.\n', P_X6_Xge4);

% finish
fprintf('\nDone.\n')

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Computes the properties for Part 2,
% @params
%     img -- the image of the discrete random variable
%     nImg -- the number of elements in img
%     cards -- the cardinalities of events in the random variable
%     freqs -- the frequencies of events in the random variable
%     nTrials -- the number of trials, s.t. freqs ~ cards/nTrials
% @returns
%     EX -- the expected value
%     sX -- the standard deviation
%     P_X6_Xge4 -- the probability of rolling a 6 given the 
function [EX, sX, P_X6_Xge4] = computeProperties(img, nImg, cards, freqs, nTrials)
    % Using the above simulated results, compute and report the following
    % values: average value,
    EX = (img*(freqs'));   % calculate the expected value of X

    % standard deviation,
    EX2 = ((img.^2)*(freqs')); % calculate the expected value of X^2
    varX = (EX2 - ((EX)^2));    % calculate variance Var(X) := EX^2 - (EX)^2
    sX = sqrt(varX);            % calculate standard deviation : sX^2 = Var(X)

    % and conditional probability P(X = 6|X >= 4)
    % initialize |X >= 4|
    nXge4 = 0;
    % loop through X values : X >= 4
    for k = 4:nImg
        % accumulate the cardinalities
        nXge4 = (nXge4 + cards(k));
    end % for k
    P_Xge4 = nXge4/nTrials;
    % Well,
    %     P(X = 6|X >= 4) = P(X = 6, X >= 4)/P{X >= 4}
    %                     = P{X = 6}/P{X >= 4}.
    % So calculate
    P_X6_Xge4 = freqs(6)/P_Xge4;
end % computeProperties(img, freqs)


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Finds a discrete cumulative distribution function from a give
% probability mass function.
% @params
%     pmf -- the probability mass function (copy)
% @returns the cumulative distribution function of the discrete r.v.
function result = calc_dcdf(pmf)
    % initialize total so far
    total = 0;
    % iterate pmf, keeping index
    for k = 1:length(pmf)
        total = (total + pmf(k));   % add to total
        pmf(k) = total;             % store total in copy
    end % for k
    result = pmf;
end %dcdf(pmf)


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Finds the dice faces given a matrix of probabilities and a XDF of a
% discrete r.v.
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
        faces = (faces + (P >= F));
    end % for F
    result = faces;
end % diceFaces(P, cdf)


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Finds the absolute frequency of each X value from [1..size].
% @params
%     X    -- the discrete random variable
%     cols -- the number of columns in the frequency row vector
% @returns the abssolute frequencies of each value of X
function result = absFreq(X, cols)
    % initialize the frequencies
    freqs = zeros(1,cols);
    Xsize = size(X);
    % loop through X values
    for k = 1:Xsize(1)
        for l = 1:Xsize(2)
            % increase the frequency of each X value
            freqs(X(k,l)) = (freqs(X(k,l)) + 1);
        end % for l
    end % for k
    result = freqs;
end % absFreq(X, size)
