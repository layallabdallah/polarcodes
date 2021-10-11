%inputs
N = 8192;
K = 4096;
Rate = K/N;
n = log2(N);

for EbNodB = 0:0.5:1
   
    EbNo = 10^(EbNodB/10); %transformation du dB
    EcNo = Rate*EbNo;
    
    %Reliability Sequence
    z = zeros(1,N);
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
    %Done Q
    
    sigma = sqrt(1/(2*Rate*EbNo)); % calcul de la variance
    F = Q(1:N-K); % Frozen position
    
    %simulate
    Nbiterrs = 0; Nblkerrs = 0;
    if EbNodB<=2  Nblocks = 50*floor(exp(EbNo^2/2));
    else Nblocks =350000;
    end
    for blk = 1:Nblocks
        
        msg = randi([0 1],1,K); %generate random K-bit message
        u = zeros(1,N);
        u(Q(N-K+1:end)) = msg; %assign message bits non-frozen positions
        m = 1; %number of bits combined for the max depth 
        %d is depth
        for d = n-1:-1:0
            for i = 1:2*m:N
                a = u(i:i+m-1); %first part
                b = u(i+m:i+2*m-1); %second part
                u(i:i+2*m-1) = [mod(a+b,2) b]; %combining
            end 
            m = m * 2; % when we come from one depth to next the number of bits combined double
        end 
        cword = u;
    %end of the encoder
    %Using BPSK and adding white gaussian noise or impulse noise
    s = 1 - 2 * cword; %BPSK bit to symbol conversion
    r = s + sigma * randn(1,N); %AWGN channel I
   
    %SC decoder
    %set up the storage
    L = zeros(n+1,N); % beliefs
    ucap = zeros(n+1,N); %decisions
    ns = zeros(1,2*N-1); %node state vector
    f = @(a,b) (1-2*(a<0)).*(1-2*(b<0)).*min(abs(a),abs(b));%minsum
    g = @(a,b,c) b+(1-2*c).*a; %g function
    L(1,:) = r; %belief of root
    node = 0; depth = 0;%start at root
    
    done = 0; %decoder finished or not
    
    while (done==0) %traverse till all bits are decoded
     %leaf or not
      if depth == n
            if any(F==(node+1)) %is node frozen
                ucap(n+1,node+1) = 0;
            else
                if L(n+1,node+1) >= 0
                    ucap(n+1,node+1) = 0;
                else
                    ucap(n+1,node+1) = 1;
                end
            end
            if node == (N-1)
                done = 1;
            else
                node = floor(node/2); depth = depth - 1;% i'm not in last node
            end
         else
            %nonleaf
            npos = (2^depth-1) + node + 1; %position of node in node state vector
            if ns(npos) == 0 %step L and go to left child
                %disp('L')
                %disp([node depth]) % display to show thing goes correctly
                temp = 2^(n-depth);
                Ln = L(depth+1,temp*node+1:temp*(node+1)); %incoming beliefs
                a = Ln(1:temp/2); b = Ln(temp/2+1:end); %split beliefs into 2
                node = node *2; depth = depth + 1; %next node: left child
                temp = temp / 2; %incoming belief length for left child
                L(depth+1,temp*node+1:temp*(node+1)) = f(a,b); %minsum and storage
                ns(npos) = 1;
            else
              if ns(npos) == 1 % step 2 go to the right child left is already done
                   % disp('R')
                   % disp([node depth]) % display to show thing goes corr
                    temp = 2^(n-depth);
                    Ln = L(depth+1,temp*node+1:temp*(node+1)); %incoming beliefs
                    a = Ln(1:temp/2); b = Ln(temp/2+1:end); %split beliefs into 2
                    
                    lnode = 2*node; ldepth = depth + 1; %left child
                    ltemp = temp/2;
                    ucapn = ucap(ldepth+1,ltemp*lnode+1:ltemp*(lnode+1)); %incoming decisions from left child
                    
                    node = node *2 + 1; depth = depth + 1; %next node: right child
                    temp = temp / 2; %incoming belief length for right child
                    
                    L(depth+1,temp*node+1:temp*(node+1)) = g(a,b,ucapn); %g and storage
                    ns(npos) = 2;
            else %step U and go to parent
                %we need the ucapn from the last child
                    temp = 2^(n-depth);
                    lnode = 2*node; rnode = 2*node + 1; cdepth = depth + 1; %left and right child
                    ctemp = temp/2;
                    ucapl = ucap(cdepth+1,ctemp*lnode+1:ctemp*(lnode+1)); %incoming decisions from left child
                    ucapr = ucap(cdepth+1,ctemp*rnode+1:ctemp*(rnode+1)); %incoming decisions from right child
                    ucap(depth+1,temp*node+1:temp*(node+1)) = [mod(ucapl+ucapr,2) ucapr]; %combine
                    node = floor(node/2); depth = depth - 1;
                end
            end
        end
    end 
    msg_cap = ucap(n+1,Q(N-K+1:end));

    %Counting errors
    Nerrs = sum(msg ~= msg_cap);
      if Nerrs > 0
        Nbiterrs = Nbiterrs + Nerrs;
        Nblkerrs = Nblkerrs + 1;
      end
    end
    BER_sim = Nbiterrs/K/Nblocks;
    FER_sim = Nblkerrs/Nblocks;
    
    disp([EbNodB FER_sim BER_sim Nblkerrs Nbiterrs Nblocks])
end 