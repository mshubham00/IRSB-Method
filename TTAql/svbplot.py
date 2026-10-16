'''
Created on July 6, 2022
Edited on Mar.19, 2025 to fix LaTeX Invalid escape error
adding 'raw' text statement

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

ldat = Table.read('ldat.svbplt', format='ascii')
phstr = ldat['col1']
drstr = ldat['col2']
thphotstr = ldat['col3']
loggstr = ldat['col6']

ph = phstr.astype('float')
dr = drstr.astype('float')
thphot = thphotstr.astype('float')
logg = loggstr.astype('float')

ph1 = np.where((ph > phmin1) & (ph < phmax1), ph, np.NaN)
dr1 = np.where((ph > phmin1) & (ph < phmax1), dr, np.NaN)
thphot1 = np.where((ph > phmin1) & (ph < phmax1), thphot, np.NaN)
logg1 = np.where((ph > phmin1) & (ph < phmax1), logg, np.NaN)
ph2 = np.where((ph > phmin2) & (ph < phmax2), ph, np.NaN)
dr2 = np.where((ph > phmin2) & (ph < phmax2), dr, np.NaN)
thphot2 = np.where((ph > phmin2) & (ph < phmax2), thphot, np.NaN)
logg2 = np.where((ph > phmin2) & (ph < phmax2), logg, np.NaN)

lfit = Table.read('lfit.svbplt', format='ascii')
drfit = lfit['col2']
thphotfit = lfit['col3']

plt.figure()
plt.subplot(223)
plt.autoscale(enable=True, axis='both', tight=None)
plt.scatter(dr, thphot, color='grey', s=10, marker='x', linewidth=1.0)
plt.scatter(dr1, thphot1, color='red', s=10, linewidth=1.0)
plt.scatter(dr2, thphot2, color='blue', s=10, linewidth=1.0)
plt.plot(drfit, thphotfit, color='grey', linewidth=1.0)
plt.xlabel(r"$\Delta$ R (m)")
plt.ylabel(r"$\Theta_{phot}$ (arcsec)")

# Thetaphot plot
thphotdat = Table.read('thphot.svbplt', format='ascii')
phstr = thphotdat['col1']
thpstr = thphotdat['col2']
sthpstr = thphotdat['col3']
teffstr = thphotdat['col4']

pht = phstr.astype('float')
thp = thpstr.astype('float')
sthp = sthpstr.astype('float')
teff = teffstr.astype('float')

pht1 = np.where((pht > phmin1) & (pht < phmax1), pht, np.NaN)
thp1 = np.where((pht > phmin1) & (pht < phmax1), thp, np.NaN)
teff1 = np.where((pht > phmin1) & (pht < phmax1), teff, np.NaN)
pht2 = np.where((pht > phmin2) & (pht < phmax2), pht, np.NaN)
thp2 = np.where((pht > phmin2) & (pht < phmax2), thp, np.NaN)
teff2 = np.where((pht > phmin2) & (pht < phmax2), teff, np.NaN)

tspec = Table.read('thspec.svbplt', format='ascii')
phspec = tspec['col1']
thspec = tspec['col2']

plt.subplot(221)
plt.autoscale(enable=True, axis='both', tight=None)
plt.scatter(pht, thp, color='grey', s=10, marker='x', linewidth=1.0, label="Refraction")
plt.scatter(pht1, thp1, color='red', s=10, linewidth=1.0, label="Refraction")
plt.scatter(pht2, thp2, color='blue', s=10, linewidth=1.0, label="Refraction")
plt.plot(phspec, thspec, linewidth=1.0, color='grey')
plt.xlabel("Phase")
plt.ylabel(r"$\Theta_{phot}$ (arcsec)")

# Teff and logg

plt.subplot(222)
plt.autoscale(enable=True, axis='both', tight=None)
#plt.scatter(pht, teff, color='grey', s=10, marker='x', linewidth=1.0)
#plt.scatter(pht1, teff1, color='red', linewidth=1.0)
#plt.scatter(pht2, teff2, color='blue', linewidth=1.0)
plt.scatter(ph, logg, color='grey', s=10, marker='x', linewidth=1.0)
plt.scatter(ph1, logg1, color='red', s=10, linewidth=1.0)
plt.scatter(ph2, logg2, color='blue', s=10, linewidth=1.0)
#plt.plot(phspec, thspec, linewidth=1.0, color='grey')
plt.xlabel("Phase")
plt.ylabel("log(g)")
# plt.grid(color='grey', linewidth=1, linestyle='-', alpha=0.2)
# 

plt.subplot(224)
plt.xlim(0.0,1.0)
plt.ylim(0.0,1.0)
plt.axis('off')
plt.text(0.01,0.95, 'Star: '+value[0])
plt.text(0.01,0.90, 'Input:')
plt.text(0.01,0.85, 'log(g)='+value[14])
plt.text(0.01,0.80, 'Mass='+value[16])
plt.text(0.01,0.75, '<V>0='+value[20])
plt.text(0.01,0.70, '<V-K>0='+value[22])
plt.text(0.01,0.65, r'$\gamma$ (km/s)='+value[19])
plt.text(0.01,0.60, 'p-factor='+value[36])
plt.text(0.01,0.55, 'E(B-V)='+value[24])
plt.text(0.01,0.50, 'Period='+value[6])
plt.text(0.01,0.45, 'Acc.Term:'+value[30])
plt.text(0.01,0.40, 'Bisector:'+value[31])
plt.text(0.01,0.35, 'Syn.color:'+value[26])
plt.text(0.01,0.30, 'Sv method:'+value[27])

plt.text(0.51,0.90, 'Output:')
plt.text(0.51,0.85, '$(m-M)_0$='+value[7])
plt.text(0.51,0.80, r'$\sigma (m-M)_0$='+value[8])
plt.text(0.51,0.75, '<Mbol>0='+value[12])
plt.text(0.51,0.70, '<Mv>0='+value[13])
plt.text(0.51,0.65, 'Radius='+value[10])
plt.text(0.51,0.60, r'$\sigma$R='+value[11])
plt.text(0.51,0.55, 'log(g)='+value[15])
plt.text(0.51,0.50, '$T_{eq}$='+value[18])
plt.text(0.51,0.45, 'Mass='+value[39])
plt.text(0.51,0.40, 'Mass relation:'+value[38])
plt.text(0.51,0.35, 'log(gF)='+value[29])

plt.tight_layout()

plt.savefig('svbplot.png')
plt.savefig('svbplot.eps')

#plt.show()

