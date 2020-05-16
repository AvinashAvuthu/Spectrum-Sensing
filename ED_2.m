clc
close all
clear all
samples = 0:8191;
fs = 4000;
L = 8192;
ts = 1/fs;
fm = 16;
f0 = 512;
l = 32;
m = 256;
ys = 2.*cos(2*pi*fm/fs.*samples) .*cos(2*pi*f0/fs.*samples);
snr_dB = -22; %SNR in decibels
snr = 10.^(snr_dB./10); % Linear Value of SNR
M = 10000;
obs_H0 = zeros(1,M);
obs_H1 = zeros(1,M);
%% simulation
for i=1:M
    noise = sqrt(1/snr)*randn(1,L) +i*sqrt(1/snr)*randn(1,L) ; 
    Signal = sqrt(1/snr)*randn(1,L)+ i*sqrt(1/snr)*randn(1,L) + ys;
    obs_H0(i) = find_energy(noise,m,l,snr);
    obs_H1(i) = find_energy(Signal,m,l,snr);
end
gammamax = max(obs_H0);
gammamin = min(obs_H0);
gamma = linspace(gammamin,gammamax,1000);
pf = zeros(length(gamma),1);
pd = zeros(length(gamma),1);
%% probability of false alarm and probability of detection
for i=1:length(gamma)
    clear PF;
    clear PD;
    PF = find(obs_H0>=gamma(i));
    PD = find(obs_H1>=gamma(i));
    pf(i) = length(PF)/M;
    pd(i) = length(PD)/M;
end
plot(pf,pd)
hold on
%% Theroretical ecpression of Probability of Detection
pf_the = 0:0.01:1;
Ted = 2*gammaincinv(1-pf_the,l);
Pd_the = 1- ncx2cdf(Ted,2*l,m*l*snr/2);
plot(pf_the, Pd_the, 'r')
hold on