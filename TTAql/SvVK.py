'''
Created on July 6, 2022

@author: jstorm
'''

import sys
import numpy as np
import matplotlib.pyplot as plt
from astropy.table import Table

plt.rcParams['font.size'] = '8'
plt.rcParams['figure.figsize'] = [9, 6]

parameter,value = np.loadtxt(fname='results.svbplt', dtype='str', usecols=(0,1), unpack=True)
phmin1 = value[2].astype('float')
phmax1 = value[3].astype('float')
phmin2 = value[4].astype('float')
phmax2 = value[5].astype('float')

ldat = Table.read('SvVK.svbplt', format='ascii')
ph = ldat['col1'].astype('float')
VK = ldat['col4'].astype('float')
Sv = ldat['col5'].astype('float')
Fv = ldat['col6'].astype('float')
Fk = ldat['col7'].astype('float')

Fvc = Fv - (3.9530 - 0.1336*VK)

phx = np.where((ph > 0.8), ph, np.NaN)
Fvcx = np.where((ph > 0.8), Fvc, np.NaN)
Fvx = np.where((ph > 0.8), Fv, np.NaN)
Fkx = np.where((ph > 0.8), Fk, np.NaN)
VKx = np.where((ph > 0.8), VK, np.NaN)
#dr1 = np.where((ph > phmin1) & (ph < phmax1), dr, np.NaN)
#thphot1 = np.where((ph > phmin1) & (ph < phmax1), thphot, np.NaN)
#logg1 = np.where((ph > phmin1) & (ph < phmax1), logg, np.NaN)
#ph2 = np.where((ph > phmin2) & (ph < phmax2), ph, np.NaN)
#dr2 = np.where((ph > phmin2) & (ph < phmax2), dr, np.NaN)
#thphot2 = np.where((ph > phmin2) & (ph < phmax2), thphot, np.NaN)
#logg2 = np.where((ph > phmin2) & (ph < phmax2), logg, np.NaN)

#lfit = Table.read('lfit.svbplt', format='ascii')
#drfit = lfit['col2']
#thphotfit = lfit['col3']

plt.figure()
plt.subplot(325)
plt.autoscale(enable=True, axis='both', tight=None)
plt.scatter(ph, Fvc, color='black', s=10, marker='o', linewidth=1.0)
plt.scatter(phx, Fvcx, color='red', s=10, marker='o', linewidth=1.0)
plt.xlabel("Phase")
plt.ylabel(r"$\Delta$Fv")

plt.subplot(323)
plt.autoscale(enable=True, axis='both', tight=None)
plt.scatter(VK, Fvc, color='black', s=10, marker='o', linewidth=1.0)
plt.scatter(VKx, Fvcx, color='red', s=10, marker='o', linewidth=1.0)
plt.xlabel("(V-K)0")
plt.ylabel(r"$\Delta$Fv")

plt.subplot(322)
plt.autoscale(enable=True, axis='both', tight=None)
plt.scatter(VK, Fk, color='black', s=10, marker='o', linewidth=1.0)
plt.scatter(VKx, Fkx, color='red', s=10, marker='o', linewidth=1.0)
plt.xlabel("(V-K)0")
plt.ylabel("Fk")

plt.subplot(321)
plt.autoscale(enable=True, axis='both', tight=None)
plt.scatter(VK, Fv, color='black', s=10, marker='o', linewidth=1.0)
plt.scatter(VKx, Fvx, color='red', s=10, marker='o', linewidth=1.0)
plt.xlabel("(V-K)0")
plt.ylabel("Fv")

plt.subplot(326)
plt.xlim(0.0,1.0)
plt.ylim(0.0,1.0)
plt.axis('off')
plt.text(0.01,0.95, 'Star: '+value[0])
plt.text(0.01,0.88, 'Input:')
plt.text(0.01,0.81, 'log(g)='+value[14])
plt.text(0.01,0.74, 'Mass='+value[16])
plt.text(0.01,0.67, '<V>0='+value[20])
plt.text(0.01,0.60, '<V-K>0='+value[22])
plt.text(0.01,0.53, r'$\gamma$ (km/s)='+value[19])
plt.text(0.01,0.46, 'p-factor='+value[36])
plt.text(0.01,0.39, 'E(B-V)='+value[24])
plt.text(0.01,0.32, 'Period='+value[6])
plt.text(0.01,0.25, 'Acc.Term:'+value[30])
plt.text(0.01,0.18, 'Bisector:'+value[31])
plt.text(0.01,0.11, 'Syn.color:'+value[26])
plt.text(0.01,0.04, 'Sv method:'+value[27])

plt.text(0.51,0.88, 'Output:')
plt.text(0.51,0.81, r'$(m-M)_0$='+value[7])
plt.text(0.51,0.74, r'$\sigma (m-M)_0$='+value[8])
plt.text(0.51,0.67, '<Mbol>0='+value[12])
plt.text(0.51,0.60, '<Mv>0='+value[13])
plt.text(0.51,0.53, 'Radius='+value[10])
plt.text(0.51,0.46, r'$\sigma$R='+value[11])
plt.text(0.51,0.39, 'log(g)='+value[15])
plt.text(0.51,0.32, r'$T_{eq}$='+value[18])
plt.text(0.51,0.25, 'Mass='+value[39])
plt.text(0.51,0.18, 'Mass relation:'+value[38])
plt.text(0.51,0.11, 'log(gF)='+value[29])

plt.tight_layout()

plt.savefig('SvVK.png')
plt.savefig('SvVK.eps')

#plt.show()

