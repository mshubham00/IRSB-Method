#!/bin/csh
set id="TTAql"
\rm -f getshift.log

set offsets=(-0.1 -0.095 -0.09 -0.085 -0.08 -0.075 -0.07 -0.065 -0.06 -0.055 -0.05 -0.045 -0.04 -0.035 -0.03 -0.025 -0.02 -0.015 -0.01 -0.005 0.0 0.005 0.01 0.015 0.02 0.025 0.03 0.035 0.04 0.045 0.05 0.055 0.06 0.065 0.07 0.075 0.08)

foreach off ($offsets)
   csh shiftrv.csh ${id} ${off}
   doitvk
   set sig=`grep "sigma(m-M)0" ${id}_vk.out`
   echo $off $sig >> getshift.log
end
set off=`awk 'BEGIN{min=100}{if($3<min){off=$1;min=$3}}END{print off}' getshift.log`
csh shiftrv.csh ${id} ${off}
doitvk
echo "Using an RV offset of:" ${off} "for" ${id}
#cat getshift.log
