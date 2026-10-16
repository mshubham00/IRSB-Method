      program svb_dfit
c
c Baade-Wesselink analysis program based on the surface brightness
c variant.
c Enhanced version which also applies the Fouque and Gieren relation
c Fits separately the distance and the radius, May 2011
c Nov.23, 1997: Uses the Isobe et al. FORTRAN code for the linear
c               regression and in particular the error estimates
c               for the OLS fits.
c Dec.2, 1997: Computes the Teff values at a given phase for the
c              analytic version of the Sv-brightness calibration
c              (Fouque and Gieren 1997 calibration)
c Dec.9, 1997: Changed computation of Mbol to use phased bolometric
c              corrections
c======================================================================
c Author: Jesper Storm               | email: jstorm@aip.de
c At: European Southern Observatory  |
c Date: March 1995                   | Version 0.1
c At: Astrophysikalisches Institut   |
c     Potsdam                        |
c Date: November 1997                | Version 1.0
c Date: December 1997                | Version 1.1
c Date: May 2011                     | Version 1.2
c======================================================================

      include 'svb.h'
      real*8 af(6),sigaf(6),bf(6),sigbf(6)
      real*8 x(NPTSX),y(NPTSX),sy(NPTSX)
      real*8 xf(NPTSX),yf(NPTSX)
      real*8 xmin,xmax,ymin,ymax
      real*8 sumd,sumdd,dth
      real*8 sumd1,sumdd1
      real*8 summ,sumx,sumxx,sumy,sumyy,sumxy,delta,slp,d,dn
      real magbol(NPTSX),sumbol
      real tarr(NPTSX)
      real Mbol,mM,Lum,logg,Mv0
      real phase,phref,loggprev,tprev
      real dr(NPTSX),loggx(NPTSX)
      real diff,diffmin,Ttol,Teq,dist,g
      real a,siga,b,sigb,reg,sigdist
      real xm,ym
      real sigm2,sigthp,dph,add
      real dist1,dist2,r1,r2,d1,d2
      integer niter,sixmode
      logical fita,fitb

      Msol=1.989e30
      Rsol=6.96e8
      Lsol=3.83e26
      gc=6.67e-11
      sbc=5.67e-8
      pi=3.14159
c      Sv0=42.16
      Sv0=42.207
      mpc=3.08e16
      fita=.TRUE.
      fitb=.TRUE.
      niter=0

c-- The acceptable temperature difference for convergence on BC
c   iteration

c      Ttol=5
      Ttol=10

      write(nstdout,'(''Enter input file name: '',$)')
      read(nstdin,'(a)') infile

c-- Read the input file and load the arrays with the data from
c   the various tables
c
      call readin(infile)

   10 continue     

c-- Open the output file

      fdout=10
      open(fdout,status='UNKNOWN',FILE=outfile)

c-- Compute the pulsational velocity (in m/s) (For common block)
c
      do 40 i=1,nrvc
	 pv(i) = pfac * (rvc(i) - gamma) * 1000.
   40 continue

c-- Determine the radius change array (dr)
c

      phr=0.0
      dphx=1./(nrvc-1)
      do 50 i=1,nrvc
	 ph=(i-1)*dphx
	 call drspec(ph,phr,sum,iflag)
	 dr(i)=sum
   50 continue

c-- Find phase of average radius 
c   i.e the points where the integral of dR cancels.
c
c-- First we compute the total integral

      sum=0
      do 70 i=1,nrvc
	 sum=sum+dr(i)
   70 continue

c-- Then we subtract the average dR from each dr value and finds the
c   value closest to the average value which will be considered the
c   reference phase.

      sum=sum/nrvc
      diffmin=1e15

      do 80 i=1,nrvc
	 diff =abs(dr(i)-sum)
	 if(diff .lt. diffmin) then
	     diffmin=diff
	     j=i
         endif
   80 continue
	 
      phref=phrvc(j)

c-- Compute first guess on the effective temperature

      call int1d(nmag,phmag,color,phref,colref,iflag)
      call gett(ncol,nrow,loggs,ths,colg,inlogg,colref,teff,iflag)


c-- Compute first guess on average radius (in m) at the above phase
c
      Rref = sqrt(gc*inmass*Msol*100./(10**(inlogg)))

c***********************************************************************
c-- Here starts the loop over logg
c

  100 continue

      nwarn=0
c-- Now prepare the two arrays for linear regression looping over 
c   the photometric data and selecting only the values in the
c   interval specified by phmin and phmax
c
      
      j=0
      xm=0.
      ym=0.
      xmax=-1e10
      xmin=1e10
      ymax=-1e10
      ymin=1e10
      sigthp=0.001
c-- Compute the mean angular diameter for the full phase range
c
      phasep=0.0
      sumtheta=0.0
      sumtt=0.0
      phs=0.0
      do 195 i=1,nmag
         phase=phmag(i)
         call getg(phase,phref,Rref,logg,iflag)
         call thphot(i,logg,thetap,sigthp)
         if(i .gt. 1) then
            dthetap=(thetap+thetapp)/2.
            dph=phase-phasep
            sumtheta=sumtheta+dph*dthetap
            sumtt=sumtt + (dph*thetap)**2
            if(thetap .gt. ymax) then
               ymax=thetap
            endif
            if(thetap .lt. ymin) then
               ymin=thetap
            endif
         else
            thetap0=thetap
            phase0=phase
         endif
c         write(*,*) phase,dph,phs,dthetap,thetap,sumtheta
         thetapp=thetap
         phasep=phase
         phs=phs+dph
  195 continue
      delt = ymax - ymin
      dthetap=(thetap0+thetap)/2.
      dph=1.0+phase0-phase
      sumtheta=sumtheta+dph*dthetap
      sumtt=sumtt + (dph*thetap)**2
      sumtheta=sumtheta*1.00
c      write(*,*) phase,dph,phs,dthetap,thetap,sumtheta
c      write(*,*) sumtheta
      if(nmag>2)then
         argu=(sumtt - (sumtheta*sumtheta)/nmag)
         stddev=sqrt(argu/(float(nmag)-1))
         sigtheta=stddev/sqrt(float(nmag))
      else
         stddev=9.999
      endif

      sumd=0
      sumdd=0
      sumd1=0
      sumdd1=0
      j=0
      npts=0
c-- We override the phase range
c      phmin1=0.0
c      phmax1=0.5
c      phmin2=0.5
c      phmax2=1.0
      do 200 i=1,nmag
	 phase=phmag(i)
	 if((phase .ge. phmin1 .and. phase .le. phmax1) .or.
     +	    (phase .ge. phmin2 .and. phase .le. phmax2)) then
	    j=j+1
	    call getg(phase,phref,Rref,logg,iflag)
	    call thphot(i,logg,thetap,sigthp)
	    call drspec(phase,phref,sum,iflag)
	    x(j)=1d0*sum
	    y(j)=1d0*thetap/1000.
c	    y(j)=1d0*(thetap - sumtheta)/1000.
            sy(j)=1d0*sigthp/1000.
            write(*,*) j,x(j),y(j)
c-- Compute the distance
            dph=phase-phasep
            dth=y(j)-sumtheta/1000.
c            thlim=0.01*delt/1000.
            thlim=0.0
            if(abs(dth) .gt. thlim) then
               d=x(j)/dth
               d1=dth/x(j)
               sumd = sumd + d
               sumdd = sumdd + d*d
               sumd1 = sumd1 + d1
               sumdd1 = sumdd1 + d1*d1
               npts=npts+1
               write(*,*) 'XXX',phase,x(j),y(j),d
               write(*,*) 'YYY',x(j),dth
            endif
            

	    loggx(j)=logg

c-- Compute statistics for scaling procedure
c
c	    xm=xm+x(j)
c	    ym=ym+y(j)
c            if(x(j) .gt. xmax) xmax=x(j)
c            if(x(j) .lt. xmin) xmin=x(j)
c            if(y(j) .gt. ymax) ymax=y(j)
c            if(y(j) .lt. ymin) ymin=y(j)
         endif
  200 continue
c-- Compute the fitting statistics following Bevington 1969 to 
c   avoid problems where theta is close to theta0
c
      summ=0.
      sumx=0.
      sumy=0.
      sumxx=0.
      sumyy=0.
      sumxy=0.
      do 220 i=1,npts
         w=1.0
         summ = summ + w
         sumx = sumx + w * x(i)
         sumxx = sumxx + w * x(i) * x(i)
         sumy = sumy + w * y(i)
         sumyy = sumyy + w * y(i) * y(i)
         sumxy = sumxy + w * x(i) * y(i)
  220 continue
      delta=summ*sumxx-sumx*sumx
      slp = (summ * sumxy - sumx*sumy) / delta
      dn = 2*206264.8/slp

      thetasum = (sumxx*sumy - sumx*sumxy)/ delta



c       write(*,*) sumd,sumph
       write(*,*) sumd,npts,sumdd
       d = sumd*206264.8*2. / npts
       d1 = (npts * 206264.8 * 2.) / sumd1
c       slp1 = sumd1 / npts
c       d1 = 2*206264.8/slp1
       write(*,*) 'VARIOUS',thlim,npts,d/mpc,d1/mpc,dn/mpc
       if(npts .gt. 2) then
          argu = sumdd - (sumd * sumd)/npts
          stddev=sqrt(argu/(float(npts)-1))
          sigd=stddev/sqrt(float(npts))
          sigd=sigd*206264.8*2.
       endif
       write(*,*) 'DIST:',d,sigd,d/mpc,sigd/mpc
       write(*,*) 'SLP:',slp,slp*206264.8*2.,dn
c--   We adopt the revised estimate as the distance
      d=dn
c      d=d1
c       write(*,*) d,d*206264.8*2, d*206264.8*2/mpc
c      nfit=j
c      xm=xm/nfit
c      ym=ym/nfit

c-- We rescale everything to avoid overflow in the fits (critical)
c   sixlin does no rescaling but only subtracts the mean, this
c   is not sufficient for these data.
c
c      dx=xmax-xmin
c      dy=ymax-ymin
c      do 230 i=1,nfit
c         xf(i)=(x(i)-xm)/dx
c         yf(i)=(y(i)-ym)/dy
c  230 continue
         
c-- If the bisector fit is requested compute the relevant slopes
c   and intercepts.
c
c   See Isobe et al. ApJ, 1990, vol.364, p.104 for further details
c
c      call sixlin(NPTSX,nfit,xf,yf,af,sigaf,bf,sigbf)
       
c-- Check for the bisector flag and convert back to non-scaled
c   quantities
c
c      if(bisector .eq. 1) then
c         sixmode=3
c      else
c         sixmode=1
c      endif

c      b=bf(sixmode)*dy/dx
c      sigb=sigbf(sixmode)*dy/dx
c      a=af(sixmode)*dy+ym-bf(sixmode)*xm*dy/dx
c      siga=sqrt((sigaf(sixmode)*dy)**2+(sigbf(sixmode)*xm*dy/dx)**2)

c-- Fill the arrays for the output including all the available
c   data points
c
      do 260 i=1,nmag
	 phase=phmag(i)
	 call getg(phase,phref,Rref,logg,iflag)
	 call thphot(i,logg,thetap,sigthp)
	 call drspec(phase,phref,sum,iflag)
	 x(i)=1d0*sum
	 y(i)=1d0*thetap/1000.
         sy(i)=1d0*sigthp/1000.
	 loggx(i)=logg
  260 continue

c-- Convert thetaphot to radians from arcsec by dividing by 206264.8
c
c      d=206264.8*2./b
c      r=a/b
      r=sumtheta/(2*1000*206264.8) * d
      b = 2 * 206264.8 / d
      a = r * b
c      write(*,*) 'AAA',sumtheta,d,r,r/6.96e8
      
      sigr=sqrt(((a/b**2)*sigb)**2 + (siga/b)**2)
      dist=d/mpc
      sigdist=dist*sigb/b
      if(dist .gt. 0.) then
         mM=5.* log10(dist)-5.
         sigmM = (sigdist * 5. / log(10.))/dist
      else
	 write(nstdout,'(''ERROR: Distance negative'')')
      endif
c-- Compute the bolometric magnitude for each phase and sum up
c   (intensity average)

      if(ctrel .eq. 'tabular') then
       do 320 i=1,nmag
         phase=phmag(i)
         call getg(phase,phref,r,logg,iflag)
c-- Iterate to get bc right
         do 310 j=1,10
           call int1d(nmag,phmag,color,phase,colref,iflag)
           call gett(ncol,nrow,loggs,ths,colg,logg,colref,teff,iflag)
           tprev=teff
           loggprev=logg
           theff=5040./teff
           call int2d(ncol,nrow,loggs,ths,bcg,logg,theff,bc,flag)
           magbol(i) = mag(i) + bc - mM
           Lum = 10**(28.48 - 0.4*magbol(i))
           rad = r + x(i)
           teffx= sqrt(sqrt(Lum/(4*pi*sbc*rad**2)))
           tarr(i)=teffx
	   dt = abs(tprev - teff)
	   if(dt .lt. Ttol) goto 315
  310    continue
         write(nstdout,'(''Warning: BC iteration failed'')')
  315    continue
  320  continue
      else
       do 350 i=1,nmag
         phase=phmag(i)
         call getg(phase,phref,r,logg,iflag)

c-- Again we have to iterate to get bc right
c   As the mass is fixed by definition, and the radius is fixed by the 
c   Baade-Wesselink analysis, log(g) has to remain fixed as well.
c   Consequently the B.C. depends purely on the Teff over which we will
c   have to iterate to get a self-consistent solution
c
         do 340 j=1,10
           tprev=teff
           loggprev=logg
           theff=5040./teff
           call int2d(ncol,nrow,loggs,ths,bcg,logg,theff,bc,flag)
           magbol(i) = mag(i) + bc - mM
           Lum = 10**(28.48 - 0.4*magbol(i))
           rad = r + x(i)
           teff= sqrt(sqrt(Lum/(4*pi*sbc*rad**2)))
           tarr(i)=teff
           loggx(i)=logg
	   dt = abs(tprev - teff)
	   if(dt .lt. Ttol) goto 341
  340    continue
         write(nstdout,'(''Warning: BC iteration failed'')')
  341    continue
  350  continue
      endif

      magbol(nmag+1)=magbol(1)
      phmag(nmag+1)=phmag(1)+1.
      tarr(nmag+1)=tarr(1)
      sumbol=0.
      tmean=0.
      do 400 i=1,nmag
	 add = (10**(magbol(i)/-2.5) + 10**(magbol(i+1)/-2.5))/2.
         dph = phmag(i+1) - phmag(i)
	 sumbol = sumbol+dph*add
         tmean = tmean + dph*(tarr(i)+tarr(i+1))/2.
  400 continue
      Mbol = -2.5*log10(sumbol)


      Mv0 = mmag0 - mM
      g = 100.*gc*inmass*Msol/r**2
      if(g .gt. 0.) then
         logg = log10(g)
      else
	 write(nstdout,'(''ERROR: g is negative'')')
      endif

c-- Compute the physical parameters for the equivalent static star
c   assuming that the radius is the Baade-Wesselink radius.

      Lum = 10**(28.48 - 0.4*Mbol)
      Teq = sqrt(sqrt(Lum/(4*pi*sbc*r**2)))

c-- Then loop on logg to optimize. And on Mass (?)
c
      niter=niter+1
      if(niter .lt. ngiter) then
         Rref=r
         goto 100
      endif

c End of logg loop
c***********************************************************************

c-- Write to the nstdout the critical output data
c
      write(nstdout,'(''              ID: '',a40)') ident
      write(nstdout,'(''          (m-M)0: '',f6.3)') mM
      write(nstdout,'(''     sigma(m-M)0: '',f6.3)') sigmM
      write(nstdout,'(''   Radius_(Rsol): '',f6.1)') r/Rsol
      write(nstdout,'(''   sigma(Radius): '',f6.1)') sigr/Rsol
      write(nstdout,'(''           Mbol0: '',f6.3)') Mbol
      write(nstdout,'(''             Mv0: '',f6.3)') Mv0
      write(nstdout,'(''         Teq_(K): '',f7.1)') Teq
      write(nstdout,'(''       Tmean_(K): '',f7.1)') tmean

c-- Write to the output file all the output data for later inspection
c   and plotting
c
      write(fdout,'(''RESULTS:'')')
      write(fdout,'(''              ID: '',a40)') ident
      write(fdout,'(''          colsys: '',a40)') colsys
      write(fdout,'(''          phmin1: '',f6.3)') phmin1
      write(fdout,'(''          phmax1: '',f6.3)') phmax1
      write(fdout,'(''          phmin2: '',f6.3)') phmin2
      write(fdout,'(''          phmax2: '',f6.3)') phmax2
      write(fdout,'(''   Period_(days): '',f10.6)') period
      write(fdout,'(''          (m-M)0: '',f6.3)') mM
      write(fdout,'(''     sigma(m-M)0: '',f6.3)') sigmM
      write(fdout,'(''   Distance_(pc): '',f8.1)') dist
      write(fdout,'(''   Radius_(Rsol): '',f6.1)') r/Rsol
      write(fdout,'(''   sigma(Radius): '',f6.1)') sigr/Rsol
      write(fdout,'(''           Mbol0: '',f6.3)') Mbol
      write(fdout,'(''             Mv0: '',f6.3)') Mv0
      write(fdout,'(''       in_log(g): '',f6.3)') inlogg
      write(fdout,'(''      out_log(g): '',f6.3)') logg
      write(fdout,'(''         in_mass: '',f6.2)') inmass
      write(fdout,'(''Regression_coeff: '',f6.3)') reg
      write(fdout,'(''         Teq_(K): '',f7.1)') Teq
      write(fdout,'(''    gamma_(km/s): '',f7.2)') gamma
      write(fdout,'(''           <mv>0: '',f6.3)') mmag0
      write(fdout,'(''        <mv>mag0: '',f6.3)') mmag0m
      write(fdout,'(''        <color>0: '',f6.3)') mcolor0
      write(fdout,'(''     <color>mag0: '',f6.3)') mcolor0m
      write(fdout,'(''          E(B-V): '',f6.3)') ebv
      write(fdout,'(''          E(col): '',f6.3)') ecolbv*ebv
      write(fdout,'('' Synthetic_color: '',a40)') synid
      write(fdout,'(''       Sv_method: '',a40)') ctrel
      write(fdout,'(''        Warnings: '',i7)') nwarn
      if(accterm .eq. 1) then
         write(fdout,'(''       Acc._Term: ON'')')
      else
         write(fdout,'(''       Acc._Term: OFF'')')
      endif
      if(bisector .eq. 1) then
         write(fdout,'(''    Bisector_fit: YES'')')
      else
         write(fdout,'(''    Bisector_fit: NO'')')
      endif
      write(fdout,'(''    N_iterations: '',i7)') ngiter
      write(fdout,'(''       Tmean_(K): '',f7.1)') tmean
      write(fdout,'(''      Photometry: '',a40)') magfile
      write(fdout,'(''          RVdata: '',a40)') rvcfile
      write(fdout,'(''         pfactor: '',f5.3)') pfac
      write(fdout,'('' Sigma_dist_(pc): '',f6.1)') sigdist

      write(fdout,'(''END_OF_RESULT'')')

c-- Write out the linear regression data to the output file
c
      write(fdout,'(''LINDAT:'')')
      do 600 i=1,nmag
	 dy = y(i) - (b*x(i)+a)
	 write(fdout,601) phmag(i),x(i),y(i),sy(i),dy,loggx(i)
  600 continue
  601 format(f6.4,4(1x,e11.4),1x,f6.3)
      write(fdout,'(''END_OF_LINDAT'')')

c-- Write out the linear fit to the output file
c
      write(fdout,'(''LINFIT:'')')
      xmin=1e15
      xmax=1e-15
      do 610 i=1,nmag
	 if(x(i) .le. xmin) then
	    xmin=x(i)
	    j=i
         elseif(x(i) .ge. xmax) then
	    xmax=x(i)
	    k=i
         endif
  610 continue
      write(fdout,*) phmag(j),x(j),b*x(j)+a
      write(fdout,*) phmag(k),x(k),b*x(k)+a
      write(fdout,'(''END_OF_LINFIT'')')

c-- Write out the angular diameters (recompute thspec with the
c   proper reference radius)
c
      write(fdout,'(''THSPEC:'')')
      do 620 i=1,nrvc
	 phase=phrvc(i)
	 call drspec(phase,phref,sum,iflag)
	 thspec=2*(r+sum)*206264./d
	 write(fdout,*) phrvc(i),thspec,phref,sum
  620 continue
      write(fdout,'(''END_OF_THSPEC'')')

      write(fdout,'(''THPHOT:'')')
      do 630 i=1,nmag
	 write(fdout,651) phmag(i),y(i),sy(i),tarr(i),color(i),loggx(i)
  630 continue
  651 format(f8.5,1x,e10.5,1x,e10.5,1x,f8.1,1x,f7.4,1x,f6.3)
      write(fdout,'(''END_OF_THPHOT'')')

c-- Test
      do 660 i=1,nrvc
	 write(fdout,*) i,pv(i)
  660 continue
c-- End Test

      close(fdout)
      end
