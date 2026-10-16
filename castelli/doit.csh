#!/bin/csh
awk -f formatlowg.awk feh=0.2 BCP_p02k2odfnew.dat > BCP_p02k2lowg.dat
awk -f formatlowg.awk feh=0.0 BCP_p00k2odfnew.dat > BCP_p00k2lowg.dat
awk -f formatlowg.awk feh=-0.5 BCP_m05k2odfnew.dat > BCP_m05k2lowg.dat
awk -f formatlowg.awk feh=-1.0 BCP_m10k2odfnew.dat > BCP_m10k2lowg.dat
awk -f formathig.awk feh=0.2 BCP_p02k2odfnew.dat > BCP_p02k2hig.dat
awk -f formathig.awk feh=0.0 BCP_p00k2odfnew.dat > BCP_p00k2hig.dat
awk -f formathig.awk feh=-0.5 BCP_m05k2odfnew.dat > BCP_m05k2hig.dat
awk -f formathig.awk feh=-1.0 BCP_m10k2odfnew.dat > BCP_m10k2hig.dat

csh dointerFeH.csh
