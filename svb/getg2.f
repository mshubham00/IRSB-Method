      subroutine getg(phase,phref,Rref,logg,iflag)

      include 'svb.h'

      real logg,Rref,phase,phref,sum
      real t1,t2,v1,v2,acc,r,g,ming

      iflag=0
      ming=10**(loggs(1))/100.

      if(accterm .eq. 1) then
	 call getidx(nrvc,phrvc,phase,j,j1,iflag)
	 persec=period*24.*3600.
	 v1=pv(j)
	 v2=pv(j1)
	 t1= phrvc(j)*persec
	 t2= phrvc(j1)*persec
	 acc = (v2 - v1)/(t2 - t1)
	 call drspec(phase,phref,sum,iflag)
	 r = Rref+sum
c	 g = gc*inmass*Msol/(r**2) + acc
	 g = gc*inmass*Msol/(r**2) - acc
      elseif(accterm .eq. 0) then
	 call drspec(phase,phref,sum,iflag)
	 r = Rref+sum
	 g = gc*inmass*Msol/(r**2)
      endif

      if(g .le. ming) then
	 logg = loggs(1)
	 write(nstdout,'(''Warning: g too low at phase ''f5.2)') phase
	 nwarn=nwarn+1
	 iflag=-1
      else
         logg = log10(100*(g))
      endif

      return
      end
