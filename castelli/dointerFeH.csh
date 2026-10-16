#!/bin/csh
cat BCP_m05k2lowg.dat BCP_p00k2lowg.dat > test.in
awk -f interFeH.awk feh=-0.1 fehhi=0.0 fehlow=-0.5 test.in > BCPi_m01k2lowg.dat
awk -f interFeH.awk feh=-0.2 fehhi=0.0 fehlow=-0.5 test.in > BCPi_m02k2lowg.dat
awk -f interFeH.awk feh=-0.3 fehhi=0.0 fehlow=-0.5 test.in > BCPi_m03k2lowg.dat
awk -f interFeH.awk feh=-0.4 fehhi=0.0 fehlow=-0.5 test.in > BCPi_m04k2lowg.dat
cat BCP_m05k2hig.dat BCP_p00k2hig.dat > test.in
awk -f interFeH.awk feh=-0.1 fehhi=0.0 fehlow=-0.5 test.in > BCPi_m01k2hig.dat
awk -f interFeH.awk feh=-0.2 fehhi=0.0 fehlow=-0.5 test.in > BCPi_m02k2hig.dat
awk -f interFeH.awk feh=-0.3 fehhi=0.0 fehlow=-0.5 test.in > BCPi_m03k2hig.dat
awk -f interFeH.awk feh=-0.4 fehhi=0.0 fehlow=-0.5 test.in > BCPi_m04k2hig.dat
cat BCP_m10k2lowg.dat BCP_m05k2lowg.dat > test.in
awk -f interFeH.awk feh=-0.6 fehhi=-1.0 fehlow=-0.5 test.in > BCPi_m06k2lowg.dat
awk -f interFeH.awk feh=-0.7 fehhi=-1.0 fehlow=-0.5 test.in > BCPi_m07k2lowg.dat
awk -f interFeH.awk feh=-0.8 fehhi=-1.0 fehlow=-0.5 test.in > BCPi_m08k2lowg.dat
awk -f interFeH.awk feh=-0.9 fehhi=-1.0 fehlow=-0.5 test.in > BCPi_m09k2lowg.dat
cat BCP_m10k2hig.dat BCP_m05k2hig.dat > test.in
awk -f interFeH.awk feh=-0.6 fehhi=-1.0 fehlow=-0.5 test.in > BCPi_m06k2hig.dat
awk -f interFeH.awk feh=-0.7 fehhi=-1.0 fehlow=-0.5 test.in > BCPi_m07k2hig.dat
awk -f interFeH.awk feh=-0.8 fehhi=-1.0 fehlow=-0.5 test.in > BCPi_m08k2hig.dat
awk -f interFeH.awk feh=-0.9 fehhi=-1.0 fehlow=-0.5 test.in > BCPi_m09k2hig.dat
cat BCP_p00k2hig.dat BCP_p02k2hig.dat > test.in
awk -f interFeH.awk feh=0.1 fehhi=0.0 fehlow=0.2 test.in > BCPi_p01k2hig.dat
cat BCP_p00k2lowg.dat BCP_p02k2lowg.dat > test.in
awk -f interFeH.awk feh=0.1 fehhi=0.0 fehlow=0.2 test.in > BCPi_p01k2lowg.dat
