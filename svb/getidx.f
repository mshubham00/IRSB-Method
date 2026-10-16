      subroutine getidx(n,arr,val,idxl,idxh,iflag)

c-- Returns the bracketing index values for an array with respect to an
c   input value (val).
c

      real arr(n),val
      integer idxl,idxh,n,iflag

      iflag=0

      do 100 i=1,n-1
	 if(val .ge. arr(i) .and. val .le. arr(i+1)) then
	    idxl=i
	    idxh=i+1
	    return
	 endif
	 if(val .le. arr(i) .and. val .gt. arr(i+1)) then
	    idxl=i+1
	    idxh=1
	    return
         endif
  100 continue

      iflag=-1
      return
      end
