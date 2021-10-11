
resSC=[0	1	4.785e-01	12000	5.8798e+06        	1.2e+04;
0.5	9.875e-01      	3.9743e-01         	11850	4.8836e+06        	1.2e+04;
1	8.0029e-01      	2.0327e-01        	19207	4.9955e+06        	2.4e+04;
1.5	3.7496e-01     	5.6227e-02         	8999	1.3818e+06        	2.4e+04;
2	8.9472e-02     	1.8359e-02         	3221	3.2573e+05        	3.6e+04;
2.25	3.25e-02    	2.67e-03       	1560	 1.3e+05        	4.8e+04;];


%1.5	1.9571e-01     	1.6211e-02         	274	9.2963e+04	1400
%2	1.0952e-02	3.5685e-04	23	5.308e+03	2100
%2.25        0.001428      0.0005304           52         7956          30000  0.0021944 
  
%listdecoder.m, nL=2
resL2 = [1         7.1e-01      1.6248e-01       994   2.3294e+05         1400;
   1.5      0.23071      0.03332          323        47767         1400
    2     0.029    0.0030738           61         6610         2100
   2.25     0.00219    0.000652         40       24035         18000
    ];
%listdecoder.m, nL=4
resL4 = [0            1      0.49807          800   1.6321e+06          800
    1        0.48      0.16224           48         8112          100;
    %1       0.4825      0.11292          965   1.1563e+05         2000
    1.5        0.072      0.023524           72         11762          1000;
    %1.5        0.146     0.025328          292        25936         2000;
    2        0.0084      0.0027064           47         6766          5000;
    %2         0.02    0.0026953           60         4140         3000
    2.25  1.1324e-03      2.312e-05   30   2.531e+03  2.7e+04
    ];
%listdecoder.m, nL=8
resL8 = [ 1      0.45333     0.091683          816   1.6899e+05         1800
          %1.5     0.073889     0.009522          133        17551         1800
          1.5        0.05      0.019308           119         19308          2000;
             2    0.0044444   0.00046691           40         4303         9000;
    2.25        0.001      0.0005808           50         7617          35000
    %2.25       0.0006   4.1357e-05           12          847        20000
    ];
            
%listdecoder.m,, nL=32
resL32 = [1        0.26      0.096504           131         24126          500;
  % 1.5        0.036      0.011894           72         11894          2000;
   1.5     0.035929    0.0061438          503        88078        14000;
   2        0.004     0.0005348           32         5348          20000;
   2.25        0.0009      0.00014           28         4130          25000];

semilogy(resSC(:,1),resSC(:,2),'ro-','LineWidth',1,'MarkerSize',5)
hold on
semilogy(resL2(:,1),resL2(:,2),'b^-','LineWidth',1,'MarkerSize',5)
semilogy(resL4(:,1),resL4(:,2),'gs-','LineWidth',1,'MarkerSize',5)
semilogy(resL8(:,1),resL8(:,2),'m*-','LineWidth',1,'MarkerSize',5)
semilogy(resL32(:,1),resL32(:,2),'kx-','LineWidth',1,'MarkerSize',5)

grid on
set(gca,'FontName','Times','FontSize',10);
axis([1 2.25 1e-4 1])
xlabel('E_b/N_0 (dB)','FontName','Times','FontSize',12)
ylabel('Word error rate','FontName','Times','FontSize',13)
%title('List decoding performance, Rate=0.5, N=2048','FontName','Times','FontSize',13)
legend('SC','L=2','L=4','L=8','L=32')