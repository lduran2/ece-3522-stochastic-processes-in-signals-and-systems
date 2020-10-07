% ./practicum1/ece3522practicum1.m
% <https://github.com/lduran2/ece-3522-stochastic-processes-in-signals-and-systems/blob/master/practicum1/ece3522practicum1.m>
% A Matlab project that considers an unfair die with 20% probability
% each of 1 - 4 and 10% probability of each 5, 6.
%      By: Leomar Duran <https://github.com/lduran2>
%    When: 2020-10-06t17:52
%     For: ECE 3522/Stochastic Processes
% Version: 1.4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHANGELOG
%     1.4 - Calculated, displayed and stem plotted relative
%           frequencies.
%     1.2 - Calculated 1000 dice faces.
%     1.0 - Calculated the cdf.

% Constants
N_ROLLS = 1000;                         % number of rolls requested
PMF = [0.2, 0.2, 0.2, 0.2, 0.1, 0.1];   % probability mass function

% iterable for X
nImgX = length(PMF);    % cardinality of Image of X
imgX = 1:nImgX;         % the image of X

% Probabilities
cdf = calc_dcdf(PMF);   % cumulative distribution function

%% Part 1
% Generate a data sequence of 1,000 random integers between 1 and 6,
% representing the outcomes of tossing the unfair die 1,000 times.
probs = rand(N_ROLLS,1);        % generate probabilities of each roll
faces = diceFaces(probs, cdf);  % find the faces rolled

% Report the value
% the relative frequency of each face
% which should be close to the probability mass function.
freqs = relFreq(faces, N_ROLLS, nImgX); % find the relative frequencies
errFreqs = (freqs - PMF)./PMF;          % calc the relative errors
% loop through X values
for k = imgX
    fprintf('The frequency of %d is %0.4f,', k, freqs(k));
    fprintf(' with relative error %+0.4f.\n', errFreqs(k));
end % for f

% and plot the relative frequency of each face
figure(1);                                  %  open figure
title('Relative requencies vs dice faces'); % title figure
stem(imgX, freqs)   % draw stem plot of rel frequencies vs dice faces
xlabel('Dice faces (k)');                   % label x-axis (k)
ylabel('Relative frequencies (P_X(k))');    % label y-axis (PX(k))
xlim([1,nImgX])                             % k in Img(X)
ylim([0, (max(PMF) + 0.1)])                 % PX(k) in [0,1]

% finish
fprintf('\nDone.\n')


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
        total = total + pmf(k); % add to total
        pmf(k) = total;         % store total in copy
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
        faces = faces + (P >= F);
    end % for F
    result = faces;
end % diceFaces(P, cdf)


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Finds the absolute frequency of each X value from [1..size].
% @params
%     X    -- the discrete random variable
%     size -- the size of the random vector
%     cols -- the number of columns in the frequency row vector
% @returns the abssolute frequencies of each value of X
function result = relFreq(X, size, cols)
    result = absFreq(X,cols)/size;
end


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
            freqs(X(k,l)) = freqs(X(k,l)) + 1;
        end % for l
    end % for k
    result = freqs;
end % absFreq(X, size)
