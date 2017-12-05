
clear;

%% Load stuff

% Load weights
load('../../mat/weights3.mat');

% Load event data
load('../../mat/dataPat.mat');

% Import tube position data
tubeData = csvread('../../mat/tubeData.csv');

%% Plot stuff

% Choose subset (train or test data)
idx = idx_test;

% Threshold for classifying hits
threshold = 0.9;

% Dropout parameter
pkeep = 1;

% Number of neurons
n = NtubesSTT;   % Number of input neurons
s1 = 200;        % 1:st hidden layer
s2 = 200;        % 2:nd hidden layer
s3 = 200;        % 3:rd hidden layer
s4 = 200;        % 4:th hidden layer
m = NtubesSTT;   % Number of output neurons

% Activation functions
sigma1  = @relu;
sigma1g = @relu_grad;
sigma2  = @relu;
sigma2g = @relu_grad;
sigma3  = @relu;
sigma3g = @relu_grad;
sigma4  = @relu;
sigma4g = @relu_grad;
sigmay  = @sigmoid;
sigmayg = @sigmoid_grad2;

% Transform data (not currently relevant)
T = Tstt;

% Event index
k = randsample(idx, 1);
%k = 48975;
%k = 69018;
%k = 106120;

% Feed forward
X = T(k, :)';
Z1tilde = (W1*X + B1)*pkeep;
Z1 = sigma1(Z1tilde)*pkeep;
Z2tilde = (W2*Z1 + B2)*pkeep;
Z2 = sigma2(Z2tilde)*pkeep;
Z3tilde = (W3*Z2 + B3)*pkeep;
Z3 = sigma3(Z3tilde)*pkeep;
Z4tilde = (W4*Z3 + B4)*pkeep;
Z4 = sigma4(Z4tilde)*pkeep;
Yp = Wy*Z4 + By;
Yh = sigmay(Yp);
Y = A(k, :)';

% Thresholded values
Yh_th = zeros(size(Yh));
Yh_th(Yh > threshold) = 1;

% Plot the input data
subplot(1, 2, 1);
hold on;
for i = 1:NtubesSTT
    
    % Outline
    x = tubeData(i, 2);
    y = tubeData(i, 3);
    r = 0.5;
    c1 = 0.5;
    c2 = 0.5;
    c3 = 0.5;
    %plot(x, y, 'LineWidth', 1, 'Marker', 'o', 'Color', [c1, c2, c3]);
    
    % Input data
    if X(i) == 1
        x = tubeData(i, 2);
        y = tubeData(i, 3);
        r = 0.5;
        c1 = 0;
        c2 = 0;
        c3 = 0;
        plot(x, y, 'LineWidth', 1, 'Marker', 'o', 'Color', [c1, c2, c3]);
    end
    
    % Correct proton track
    if Y(i) == 1
        x = tubeData(i, 2);
        y = tubeData(i, 3);
        r = 0.5;
        c1 = 1;
        c2 = 0;
        c3 = 0;
        plot(x, y, 'LineWidth', 1, 'Marker', 'o', 'Color', [c1, c2, c3]);
    end
end
xlim([-43, 43]);
ylim([-43, 43]);

% Plot the output from the NN
subplot(1, 2, 2);
hold on;
for i = 1:NtubesSTT
    if X(i) == 1
        x = tubeData(i, 2);
        y = tubeData(i, 3);
        r = 0.5;
        c1 = 1 - Yh(i);
        c2 = 1 - Yh(i);
        c3 = 1 - Yh(i);
        plot(x, y, 'LineWidth', 1, 'Marker', 'o', 'Color', [c1, c2, c3]);
    end
end
xlim([-43, 43]);
ylim([-43, 43]);


