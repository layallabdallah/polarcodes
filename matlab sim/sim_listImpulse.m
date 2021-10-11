resI = [0	1	4.9929e-01	700	1.4316e+06        	700
0.5	1      	4.9727e-01         	700	1.4258e+06        	700
1	1      	4.7225e-01        	1400	2.7081e+06       	1400
1.5	9.5929e-01     	2.9422e-01         	1343	1.6872e+06        	1400
2	3.3905e-01     	4.9922e-02         	712	4.2941e+05        	2100
2.5	1.0875e-02    	1.0878e-03          	87	3.5644e+04        	8000
3	1.1224e-04	1.1509e-05           	55	2.3099e+04	4.9e+05
    ];

resS = [0	1	4.9774e-01	700	1.4271e+06	700
0.5	1      	4.5697e-01         	700	1.3102e+06	700
1	8.45e-01      	1.7378e-01        	1183	9.9652e+05	1400
1.5	1.9571e-01     	1.6211e-02         	274	9.2963e+04	1400
2	1.0952e-02	3.5685e-04	23	5.308e+03	2100
2.25  1.1224e-03      2.312e-05   30   2.531e+03  2.7e+04   
    ];

semilogy(resI(:,1),resI(:,3),'b*-','LineWidth',1,'MarkerSize',5)
hold on
semilogy(resS(:,1),resS(:,3),'r*-','LineWidth',1,'MarkerSize',5)

grid on
set(gca,'FontName','Times','FontSize',10);
axis([0 3.5 9e-6 1e-0])
xlabel('E_b/N_0 (en dB)','FontName','Times','FontSize',12)
ylabel('Bit error rate(BER)','FontName','Times','FontSize',13)
title('Polar Codes over the AWGN channel and the BI-BG channel','FontName','Times','FontSize',13)
legend('Impulse, p=0.1, N=8192, R=0.5','AWGN N=8192, List L=2')