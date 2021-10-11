resI = [0	1	4.9929e-01	700	1.4316e+06        	700
0.5	1      	4.9727e-01         	700	1.4258e+06        	700
1	1      	4.7225e-01        	1400	2.7081e+06       	1400
1.5	9.5929e-01     	2.9422e-01         	1343	1.6872e+06        	1400
2	3.3905e-01     	4.9922e-02         	712	4.2941e+05        	2100
2.5	1.0875e-02    	1.0878e-03          	87	3.5644e+04        	8000
3	1.1224e-04	1.1509e-05           	55	2.3099e+04	4.9e+05

    ];

resS = [0	1	4.9798e-01	20000	4.0795e+07         	2e+04;
0.5	9.9995e-01      	4.7063e-01         	19999	3.8554e+07        	2e+04;
1	9.3493e-01      	2.2127e-01        	37397	3.6253e+07        	4e+04;
1.5	3.7433e-01     	3.617e-02         	14973	5.9261e+06        	4e+04;
2	4.0133e-02     	2.1901e-03         	2408	5.3825e+05        	6e+04;
2.5	9.2286e-04    	4.1587e-05          	323	5.9619e+04        	3.5e+05;
    ];

semilogy(resI(:,1),resI(:,3),'b*-','LineWidth',0.7,'MarkerSize',5)
hold on
semilogy(resS(:,1),resS(:,3),'r*-','LineWidth',0.7,'MarkerSize',5)

grid on
set(gca,'FontName','Times','FontSize',10);
%axis([0 3.2 9e-7 1e-0])
xlabel('E_b/N_0 (en dB)','FontName','Times','FontSize',12)
xticks
yticks
ylabel('Bit error rate(BER)','FontName','Times','FontSize',13)
title('Polar Codes over the AWGN channel and the BI-BG channel','FontName','Times','FontSize',13)
legend('Imp, p=0.1, N=8192, R=0.5','AWGN N=8192')