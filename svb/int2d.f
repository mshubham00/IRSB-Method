      subroutine int2d(n,m,arr1,arr2,arr3,x,y,z,iflag)

c-- Bilinear interpolation using formulas from Numerical recipes
c   Sec 3.6. 
c   The flag iflag is -1 when the values are outside of the array
c   and the extreme value is returned instead of the interpolation

      integer n,m,flag
      real arr1(n),arr2(n),arr3(n,m),x,y,z

      flag=0
      j=-1
      k=-1

c-- Find the right quadrant
c
      do 100 i=1,n
C         write(*,*) i,x,arr1(i),arr1(i+1)
	 if(x .ge. arr1(i) .and. x .lt. arr1(i+1) .or.
     +      x .lt. arr1(i) .and. x .ge. arr1(i+1)) then
	    j=i
	    goto 101
         endif
  100 continue

c-- In case it was not there
c
      iflag=-1
      if(x .le. arr1(1) .and. x .le. arr1(n)) then
	 if(arr1(1) .lt. arr1(n)) then
	    j=1
         else
	    j=n-1
	 endif
      elseif(x .ge. arr1(1) .and. x .ge. arr1(n)) then
	 if(arr1(1) .gt. arr1(n)) then
	    j=1
         else
	    j=n-1
	 endif
      endif

  101 continue

      do 200 i=1,n
C         write(*,*) i,y,arr2(i),arr2(i+1),k
	 if(y .ge. arr2(i) .and. y .lt. arr2(i+1) .or.
     +      y .lt. arr2(i) .and. y .ge. arr2(i+1)) then
	    k=i
	    goto 201
         endif
  200 continue
c-- In case it was not there
c
      iflag=-1
      if(y .le. arr2(1) .and. y .le. arr2(n)) then
C         write(*,*) i,y,arr2(i),arr2(i+1)
	 if(arr2(1) .lt. arr2(n)) then
	    k=1
         else
	    k=n-1
	 endif
      elseif(y .ge. arr2(1) .and. y .ge. arr2(n)) then
	 if(arr2(1) .gt. arr2(n)) then
	    k=1
         else
	    k=n-1
	 endif
      endif

  201 continue

c      if(j .ge. 0 .and. k .ge. 0) then
c          flag=1
c      else
c	  goto 900
c      endif
      t=(x-arr1(j))/(arr1(j+1)-arr1(j))
      u=(y-arr2(k))/(arr2(k+1)-arr2(k))

      z=(1-t)*(1-u)*arr3(j,k)+t*(1-u)*arr3(j+1,k)
      z=z+t*u*arr3(j+1,k+1)+(1-t)*u*arr3(j,k+1)

  900 continue
      end
