      subroutine drspec(phase,phref,sum,iflag)

c-- Returns the integrated radius change (sum) from the reference phase to
c   the phase.

      include 'svb.h'

      real dph,sum,persec,add,pvx,ph1,ph2,phup,phlow,f,dk
      integer sign

      persec = period * 24. * 3600.
      sum = 0.0

      if(phase .ge. phref) then
	 ph1 = phref
	 ph2 = phase
	 sign = -1.
      else
	 ph2 = phref
	 ph1 = phase
	 sign = 1.
      endif

c-- Find the bracketing indices
c
      call getidx(nrvc,phrvc,ph1,j,j1,iflag)
      call getidx(nrvc,phrvc,ph2,k,k1,iflag)

c-- To fix a problem around phase 1.
c      dk=k1-k
c      if(dk .gt. 2) then
c         k=k1-1
c      endif

c-- Compute the fractional contributions at the ends when phN lies
c   in between end points.
c   The min/max stuff ensures that this also works when phN both
c   lie in the same interval (also the case of ph1=ph2)
c

      call int1d(nrvc,phrvc,pv,ph1,pvx,iflag)
      phup = min(phrvc(j1),ph2)
      f = phup-ph1
      sum = f*(pvx+pv(j1))/2.

      call int1d(nrvc,phrvc,pv,ph2,pvx,iflag)
      phlow = max(phrvc(k),ph1)
      f = ph2-phlow
      sum = sum+f*(pvx+pv(k))/2.

c-- Add up the contributions in the other intervals between ph1 and ph2
c
      do 200 i=j+1,k-1
	 dph = phrvc(i+1)-phrvc(i)
	 add = dph*(pv(i+1)+pv(i))/2.
	 sum = sum+add
  200 continue

c-- Apply the right sign (the sum is positive when the star is larger
c   than reference radius)
c
      sum = sign*persec*sum

      return
      end
