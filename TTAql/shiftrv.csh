#!/bin/csh
# Corrected version Oct.29.2010 properly wrapping the shifted data
set id=$1
awk '{ph=$1+off;if(ph<0.){ph=ph+1.};if(ph>1){ph=ph-1.};print ph,$2,$3}' off=$2 ${id}.phrv | sort > ${id}.phrv2
tail -1 ${id}.phrv2 | awk '{print $1-1.,$2,$3}' > TEMPRV$$
cat ${id}.phrv2 >> TEMPRV$$
head -1 ${id}.phrv2 | awk '{print $1+1.,$2,$3}' >> TEMPRV$$

awk -f ~/awklib/interph.awk TEMPRV$$ > ${id}.rvc2
#awk -f inph.awk TEMPRV$$ > ${id}.rvc2
\rm -f TEMPRV$$
echo $2 > rvphoff.dat
