resI = [0	1	4.9809e-01	1000	2.0402e+06         	1000
0.5  	1	 4.9243e-01	  1000	  2.017e+06	   1000
1	9.935e-01	3.6445e-01	1987	2.9855e+06         	2000
1.5	6.055e-01	9.0354e-02	1211	7.4018e+05         	2000
2	5.4667e-02	4.328e-03	164  	5.3183e+04	   3000
2.5	1.5357e-03   	9.0742e-05      	43	1.0407e+04	28000
    ];

resS = [0	1	4.9798e-01	20000	4.0795e+07         	2e+04;
0.5	9.9995e-01      	4.7063e-01         	19999	3.8554e+07        	2e+04;
1	9.3493e-01      	2.2127e-01        	37397	3.6253e+07        	4e+04;
1.5	3.7433e-01     	3.617e-02         	14973	5.9261e+06        	4e+04;
2	4.0133e-02     	2.1901e-03         	2408	5.3825e+05        	6e+04;
2.5	9.2286e-04    	4.1587e-05          	323	5.9619e+04        	3.5e+05
    ];

semilogy(resI(:,1),resI(:,3),'b*-','LineWidth',0.7,'MarkerSize',5)
hold on
semilogy(resS(:,1),resS(:,3),'r*-','LineWidth',0.7,'MarkerSize',5)

grid on
set(gca,'FontName','Times','FontSize',10);
axis([0 3 9.99e-6 1e0]);
xlabel('E_b/N_0 (en dB)','FontName','Times','FontSize',12)
ylabel('Bit error rate(BER)','FontName','Times','FontSize',13)
title('Polar Codes over the AWGN channel and the BI-BG channel','FontName','Times','FontSize',13)
legend('Impulse, p=0.05, N=8192,R=0.5','AWGN N=8192')