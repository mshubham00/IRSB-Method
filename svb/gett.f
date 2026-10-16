      subroutine gett(n,m,arr1,arr2,arr3,logg,colr,t,iflag)

      include 'svb.h'

      integer n,m,iflag
      real logg,colr,t
      real arr1(n),arr2(m),arr3(n,m),c(NROWX)

      iflag=0

      do 100 i=1,n
	 if(logg .ge. arr1(i) .and. logg .le. arr1(i+1)) then
	    j=i
	    goto 101
         endif
  100 continue
  101 continue

      f = (logg - arr1(j))/(arr1(j+1)-arr1(j))

      do 200 i=1,m
         c(i)=f*(arr3(j+1,i)-arr3(j,i))+arr3(j,i)
  200 continue

      call int1d(m,c,arr2,colr,t,iflag)
      t=5040./t

      return
      end
