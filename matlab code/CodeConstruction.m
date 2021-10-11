%Construction of the code
N = 1024; %choose N: length of transmitted message
K = 512; %choose K: length of the message 
EbNodB = 3; %SNR en dB
EbNo = 10^(EbNodB/10); %transformation du dB
Rate = K/N; %Rate of message vs
EcNo = Rate*EbNo; 
z = zeros(1,N); %initialize Bhattachrayya vector
w = zeros(1,N); % to store
z(1) = exp(-EcNo); % initialisation

for lev=1:log2(N)
    B=2^lev;
    for j=1:B/2
        T = z(j);
        % calculation of Bhattacharyya parameter
        % 2z - z^2
        w(2*j-1) = 2*T - T^2; 
        % z^2
        w(2*j) = T^2;
    end 
    z = w;
end 

[zn,Q] = sort(z,'descend');

