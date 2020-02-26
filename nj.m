clearvars; 

close all;
s = 1;
%SNRdB = 0:10;
%SNRlin = 10.^(SNRdB/10);
%sigma2 = 1; sigma = sqrt(sigma2);
pSet=0:0.1:0.5;

%sigma2 = (s^2)./SNRlin;
%sigmaset=sqrt(sigma2/2);
N=5;
r_decision_boundary =2.5;
Nsim = 100000;
Ncorr = zeros(size(pSet)); 
Nerr = Ncorr;
% Monte-Carlo Experimental Trials
i=0;
for p=pSet
 i = i+1;
for ksim = 1:Nsim
Xtx = randi(2,1) - 1;% random generation of X = 0 and X = 1

if Xtx == 1 % if X = 1, transmit s, else transmit -s volts
s_tx = ones(1,N);
else
s_tx = zeros(1,N);
end
% Matlab’s function randn generates Gaussian distributed random
% variable with variance of 1. Multiply by sigma to make the variance
% sigma^2
n = rand(1,N)>(1-p);
% received signal
r = xor(s_tx,n);
% Bayesian receiver
if sum(r) > r_decision_boundary
Xrx = 1;
else
Xrx = 0;
end
% Update the counters
if Xtx == Xrx % if the receiver has decided correctly
Ncorr(i) = Ncorr(i) + 1; %increment the count of correct bit decision at the receiver
else % else
Nerr(i) = Nerr(i) + 1; %increment the count of incorrect bit decisions
end
end
a=0;
for k=ceil(2.5):5
    a= a + (nchoosek(5,k))*(p^k)*((1-p)^(5-k));
    
end
pthrc(i) = a;
end

plot(pSet,Nerr/Nsim,'-');
hold on;
xlabel('flipping probabilty');
ylabel('Nerr/Nsim');

plot(pSet,pthrc);
hold on;

p_th_bsc = pSet;
plot(pSet,p_th_bsc);
legend('with coding simulated','with coding theory','without coding');
%pth=qfunc(sqrt(2*SNRlin));
%hold on;
%semilogy(SNRdB,pth);

grid on;