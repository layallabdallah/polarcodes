%inputs
N = 1024;
A = 512; crcL = 11;
crcg = fliplr([1 1 1 0 0 0 1 0 0 0 0 1]); %CRC polynomial
K = A + crcL; %CRC length = crcL

Rate = A/N;
n = log2(N);

rmax = 4; %max received value
maxqr = 31; %max integer received value
nL = 2; %list size

for EbNodB = 2.25
   
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
    Q1 = Q(Q<=N); %reliability sequence for N

    F = Q1(1:N-K); %Frozen positions: Q1(1:N-K)
    %Message positions: Q1(N-K+1:end)

    satx = @(x,th) min(max(x,-th),th); %saturate FP value
    f = @(a,b) (1-2*(a<0)).*(1-2*(b<0)).*min(abs(a),abs(b)); %minsum
    g = @(a,b,c) satx(b+(1-2*c).*a,maxqr); %g function

%Simulate
Nbiterrs = 0; Nblkerrs = 0; Nblocks = 1500*floor(exp(EbNo^2/2));

    %Nblocks =350000;;
   for blk = 1:Nblocks
     msg = randi([0 1],1,A); %generate random K-bit message
     [quot,rem] = gfdeconv([zeros(1,crcL) fliplr(msg)],crcg);
     msgcrc = [msg fliplr([rem zeros(1,crcL-length(rem))])];
    
     u = zeros(1,N);
    
     u(Q1(N-K+1:end)) = msgcrc; %assign message bits
    
     m = 1; %number of bits combined
     for d = n-1:-1:0
        for i = 1:2*m:N
            a = u(i:i+m-1); %first part
            b = u(i+m:i+2*m-1); %second part
            u(i:i+2*m-1) = [mod(a+b,2) b]; %combining
        end
        m = m * 2;
    end
    cword = u;
    
    s = 1 - 2 * cword; %BPSK bit to symbol conversion
    r = s + sigma * randn(1,N); %AWGN channel I
    %quantization
    r = satx(r,rmax);
    rq = round(r/rmax*maxqr);
    
    %nL SC decoders
    LLR = zeros(nL,n+1,N); %beliefs in nL decoders
    ucap = zeros(nL,n+1,N); %decisions in nL decoders
    PML = Inf*ones(nL,1); %Path metrics
    PML(1) = 0;
    ns = zeros(1,2*N-1); %node state vector
        
    LLR(:,1,:) = repmat(rq,nL,1,1); %belief of root
    %DML = zeros(nL,N);
    %PMLL = zeros(nL,N);
    node = 0; depth = 0; %start at root
    done = 0; %decoder has finished or not
    while (done == 0) %traverse till all bits are decoded
        %leaf or not
        if depth == n
           DM = squeeze(LLR(:,n+1,node+1)); %decision metrics
           % DML(:,node+1) = DM;
           % PMLL(:,node+1) = PML;
            if any(F==(node+1)) %is node frozen
                ucap(:,n+1,node+1) = 0; %set all decisions to 0
                PML = PML + abs(DM).*(DM < 0); %if DM is negative, add |DM|
            else
                dec = DM < 0; %decisions as per DM
                PM2 = [PML; PML+abs(DM)];
                [PML, pos] = mink(PM2,nL); %In PM2(:), first nL are as per DM 
                                             %next nL are opposite of DM
                pos1 = pos > nL; %surviving with opposite of DM: 1, if pos is above nL
                pos(pos1) = pos(pos1) - nL; %adjust index
                dec = dec(pos); %decision of survivors
                dec(pos1) = 1 - dec(pos1); %flip for opposite of DM
                LLR = LLR(pos,:,:); %rearrange the decoder states
                ucap = ucap(pos,:,:);
                ucap(:,n+1,node+1) = dec;
            end
            if node == (N-1)
                done = 1;
            else
                node = floor(node/2);
                depth = depth - 1;
            end
        else
            %nonleaf
            npos = (2^depth-1) + node + 1; %position of node in node state vector
            if ns(npos) == 0 %step L and go to left child
                %disp('L')
                %disp([node depth])
                temp = 2^(n-depth);
                Ln = squeeze(LLR(:,depth+1,temp*node+1:temp*(node+1))); %incoming beliefs
                a = Ln(:,1:temp/2);
                b = Ln(:,temp/2+1:end); %split beliefs into 2
                node = node *2; depth = depth + 1; %next node: left child
                temp = temp / 2; %incoming belief length for left child
                LLR(:,depth+1,temp*node+1:temp*(node+1)) = f(a,b); %minsum and storage
                ns(npos) = 1;
            else
                if ns(npos) == 1 %step R and go to right child
                    %disp('R')
                    %disp([node depth])
                    temp = 2^(n-depth);
                    Ln = squeeze(LLR(:,depth+1,temp*node+1:temp*(node+1))); %incoming beliefs
                    a = Ln(:,1:temp/2); b = Ln(:,temp/2+1:end); %split beliefs into 2
                    lnode = 2*node; ldepth = depth + 1; %left child
                    ltemp = temp/2;
                    ucapn = squeeze(ucap(:,ldepth+1,ltemp*lnode+1:ltemp*(lnode+1))); %incoming decisions from left child
                    node = node *2 + 1; depth = depth + 1; %next node: right child
                    temp = temp / 2; %incoming belief length for right child
                    LLR(:,depth+1,temp*node+1:temp*(node+1)) = g(a,b,ucapn); %g and storage
                    ns(npos) = 2;
                else %step U and go to parent
                    temp = 2^(n-depth);
                    lnode = 2*node; rnode = 2*node + 1; cdepth = depth + 1; %left and right child
                    ctemp = temp/2;
                    ucapl = squeeze(ucap(:,cdepth+1,ctemp*lnode+1:ctemp*(lnode+1))); %incoming decisions from left child
                    ucapr = squeeze(ucap(:,cdepth+1,ctemp*rnode+1:ctemp*(rnode+1))); %incoming decisions from right child
                    ucap(:,depth+1,temp*node+1:temp*(node+1)) = [mod(ucapl+ucapr,2) ucapr]; %combine
                    node = floor(node/2); depth = depth - 1;
                end
            end
        end
    end
    %check CRC
    msg_capl = squeeze(ucap(:,n+1,Q1(N-K+1:end))); %get candidate messages
    cout = 1; %candidate codeword to be outputted, initially set to best PM
    for c1 = 1:nL
        [q1,r1] = gfdeconv(fliplr(msg_capl(c1,:)),crcg);
        if isequal(r1,0) %check if CRC passes
            cout = c1;
            break
        end
    end
    
    msg_cap = msg_capl(cout,1:A);
    
    %Counting errors
    Nerrs = sum(msg ~= msg_cap);
    if Nerrs > 0
        Nbiterrs = Nbiterrs + Nerrs;
        Nblkerrs = Nblkerrs + 1;
    end
end

BER_sim = Nbiterrs/A/Nblocks;
FER_sim = Nblkerrs/Nblocks;

disp([EbNodB FER_sim BER_sim Nblkerrs Nbiterrs Nblocks])

end 