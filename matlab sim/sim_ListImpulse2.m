resI = [0	1	4.9809e-01	1000	2.0402e+06         	1000
0.5	1	4.9243e-01	1000	2.017e+06	1000
1	9.935e-01	3.6445e-01	1987	2.9855e+06         	2000
1.5	6.055e-01	9.0354e-02	1211	7.4018e+05         	2000
2	5.4667e-02	4.328e-03	164	5.3183e+04	3000
2.5	1.5357e-03   	9.0742e-05   	43	1.0407e+04	28000
2.7	1.02e-04  1.23e-05  50	2.4686e+04	4.9e+05
    ];

resS = [0	1	4.9774e-01	700	1.4271e+06	700
0.5	1      	4.5697e-01         	700	1.3102e+06	700
1	8.45e-01      	1.7378e-01        	1183	9.9652e+05	1400
1.5	1.9571e-01     	1.6211e-02         	274	9.2963e+04	1400
2	1.0952e-02	3.5685e-04	23	5.308e+03	2100
2.25	1.1224e-03      	2.312e-05	30	2.531e+03  	2.7e+04

    ];

semilogy(resI(:,1),resI(:,3),'b*-','LineWidth',1,'MarkerSize',5)
hold on
semilogy(resS(:,1),resS(:,3),'r*-','LineWidth',1,'MarkerSize',5)

grid on
set(gca,'FontName','Times','FontSize',10);
axis([0 3 9e-6 1e-0])
xlabel('E_b/N_0 (en dB)','FontName','Times','FontSize',12)
ylabel('Bit error rate(BER)','FontName','Times','FontSize',13)
title('Polar Codes over the AWGN channel and the BI-BG channel','FontName','Times','FontSize',13)
legend('Impulse, p=0.05, N=8192, R=0.5','AWGN N=8192, List L=2')