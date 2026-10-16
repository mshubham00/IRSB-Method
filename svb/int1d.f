      subroutine int1d(n,arr1,arr2,x,y,iflag)

      integer n,iflag,nstdout
      real arr1(n),arr2(n),x,y

      nstdout=6

      iflag=0

c-- Find the appropriate grid points for both the increasing and
c   decreasing arrays and perform the linear interpolation.
c
      do 100 i=1,n-1
	 if(x .ge. arr1(i) .and. x .le. arr1(i+1) .or.
     +	    x .le. arr1(i) .and. x .ge. arr1(i+1)) then
	    f = (x-arr1(i))/(arr1(i+1)-arr1(i))
	    y = arr2(i) + f*(arr2(i+1)-arr2(i))
            return
         endif
  100 continue

c-- In case the interpolation fails, return the relevant minimum or
c   maximum value together with a flag signaling the failure
c
      if(x .lt. arr1(1) .and. x .lt. arr1(n)) then
	 y=min(arr2(1),arr2(n))
      elseif(x .gt. arr1(1) .and. x .gt. arr1(n)) then
	 y=max(arr2(1),arr2(n))
      endif

      iflag=-1

      return
      end
