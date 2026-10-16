'''
Created on Dec 8, 2022

@author: jstorm
'''

import sys
import numpy as np
import matplotlib.pyplot as plt
from astropy.table import Table

plt.rcParams['font.size'] = '8'
plt.rcParams['figure.figsize'] = [9, 6]

parameter,value = np.loadtxt(fname='results.svbplt', dtype='str', usecols=(0,1), unpack=True)
id = value[0]
phmin1 = value[2].astype('float')
phmax1 = value[3].astype('float')
phmin2 = value[4].astype('float')
phmax2 = value[5].astype('float')
meanMbol = value[12].astype('float')
mass = value[39].astype('str')
meanloggf = value[29].astype('float')

ldat = Table.read('thphot.svbplt', format='ascii')
ph = ldat['col1'].astype('float')
y = ldat['col2'].astype('float')
sy = ldat['col3'].astype('float')
teff = ldat['col4'].astype('float')
VK = ldat['col5'].astype('float')
logg = ldat['col6'].astype('float')
loggf = ldat['col7'].astype('float')
Lum = ldat['col8'].astype('float')
Mbol = ldat['col9'].astype('float')

# Groenewegen2020 Eq.3 relation
loggffit = [1.5, 3.5]
Mbolfit = [-8.0, -1.27]

plt.figure()
plt.subplot(321)
plt.autoscale(enable=True, axis='both', tight=None)
plt.scatter(ph, Mbol, color='blue', s=10, linewidth=1.0)
plt.xlabel("Phase")
plt.ylabel("$M_{bol}$ (mag)")
#plt.text(0.08,0.10, 'Mass='+ mass)

plt.subplot(323)
plt.autoscale(enable=True, axis='both', tight=None)
plt.scatter(ph, logg, color='grey', s=10, marker='x', linewidth=1.0, label="Refraction")
plt.xlabel("Phase")
plt.ylabel("log(g)")

plt.subplot(325)
plt.autoscale(enable=True, axis='both', tight=None)
plt.scatter(ph, loggf, color='grey', s=10, marker='x', linewidth=1.0, label="Refraction")
plt.xlabel("Phase")
plt.ylabel("log(gf)")

plt.subplot(322)
plt.autoscale(enable=True, axis='both', tight=None)
plt.scatter(loggf, Mbol, color='grey', s=10, marker='x', linewidth=1.0, label="Refraction")
plt.xlabel("log(gf)")
plt.ylabel("Mbol (mag)")

plt.subplot(324)
plt.xlim(3.7,1.2)
plt.ylim(0.0,-8.5)
plt.scatter(loggf, Mbol, color='grey', s=10, marker='x', linewidth=1.0)
plt.plot(loggffit, Mbolfit, color='blue', linewidth=1.0)
plt.xlabel("log(gf)")
plt.ylabel("Mbol (mag)")

plt.subplot(326)
plt.xlim(0.0,1.0)
plt.ylim(0.0,1.0)
plt.axis('off')
plt.text(0.01,0.93, 'Star: '+ id)
plt.text(0.01,0.83, 'Mass: '+ mass)
plt.tight_layout()

plt.savefig('loggf.png')
plt.savefig('loggf.eps')

#plt.show()

