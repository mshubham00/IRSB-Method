      subroutine thphot(idx,logg,thetap,sigthp)

c-- Returns the photometric angular diameter (in milli arcsec)
c   for a given phase on basis on the photometric data and the
c   temperature and Bolometric corrections from model atmospheres.
c
c-----------------------------------------------------------------------
c   By: Jesper Storm                    | e-mail: jstorm@eso.org
c   At: European Southern Observatory   |
c Date: April 11, 1995                  | Version: 0.1
c-----------------------------------------------------------------------

      include 'svb.h'

      real Sv,teff,bc,v,thetap,theta,col,logg,sigthp
      real thetapx,tx
      real a0,a1,a2,a3,a4,a5,magn,smagn,scol
      integer iflag,idx

      a3=0.0
      a4=0.0
      a5=0.0
      if(ctrel .eq. 'FG_linearVVK') then
         a0=0.5474
         a1=0.262
         a2=0.0
         magn=mag(idx)
         smagn=smag(idx)
c         col=color(idx)
         col=(color(idx)-0.034)/0.993
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'Bailleul_linearVVK') then
         a=3.9572
         b=-0.1336
         a0=0.2*Sv0-2.*a
         a1=-2.*b
c         a0=0.5270
c         a1=0.2672
         magn=mag(idx)
         smagn=smag(idx)
         col=color(idx)
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'Kerv_linearVVK') then
         a0=0.5354
         a1=0.2672
         a2=0.0
         magn=mag(idx)
         smagn=smag(idx)
         col=color(idx)
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'Kerv_linearVVKtest') then
         a0=0.5054
         a1=0.2672
         a2=0.0
         magn=mag(idx)
         smagn=smag(idx)
         col=color(idx)
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'Boyajian14_VVK') then
         a0=0.53246
         a1=0.26382
         a2=0.0
         magn=mag(idx)
         smagn=smag(idx)
         col=(color(idx)-0.034)/0.993
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'Challouf_VVK') then
         a0=2.624/5.
         a1=1.798/5.
         a2=-0.776/5.
         a3=0.517/5.
         a4=-0.150/5.
         a5=0.015/5.
         magn=mag(idx)
         smagn=smag(idx)
         col=(color(idx)-0.034)/0.993
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'Challouf_linearVVK') then
c-- Linear regression to the relation between 0.0 and 2.0
         a0=2.6275/5.
         a1=1.3787/5.
         a2=0.0
         a3=0.0
         a4=0.0
         a5=0.0
         magn=mag(idx)
         smagn=smag(idx)
         col=(color(idx)-0.034)/0.993
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'Challouf_IIIVVK') then
         a0=2.497/5.
         a1=1.916/5.
         a2=-0.335/5.
         a3=0.050/5.
         magn=mag(idx)
         smagn=smag(idx)
         col=(color(idx)-0.034)/0.993
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'Challouf_IVVK') then
         a0=2.291/5.
         a1=2.151/5.
         a2=-0.461/5.
         a3=0.073/5.
         magn=mag(idx)
         smagn=smag(idx)
         col=(color(idx)-0.034)/0.993
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'Challouf_new') then
         a0=2.6585/5.
         a1=1.47056/5.
         a2=-0.09527/5.
         a3=0.
         magn=mag(idx)
         smagn=smag(idx)
         col=(color(idx)-0.034)/0.993
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'Challouf_new_linear') then
         a0=2.71131/5.
         a1=1.30523/5.
         a2=0.
         a3=0.
         magn=mag(idx)
         smagn=smag(idx)
         col=(color(idx)-0.034)/0.993
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'Challouf_new_linear2percent') then
         a0=2.77855/5.
         a1=1.24782/5.
         a2=0.
         a3=0.
         magn=mag(idx)
         smagn=smag(idx)
         col=(color(idx)-0.034)/0.993
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'Challouf_III+IVnew') then
         a0=2.45880/5.
         a1=1.8811/5.
         a2=-0.27575/5.
         a3=0.
         magn=mag(idx)
         smagn=smag(idx)
         col=(color(idx)-0.034)/0.993
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'Challouf_III+IVnew_linear') then
         a0=2.62343/5.
         a1=1.39843/5.
         a2=0.
         a3=0.
         magn=mag(idx)
         smagn=smag(idx)
         col=(color(idx)-0.034)/0.993
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'Challouf_VVVK') then
         a0=2.625/5.
         a1=1.823/5.
         a2=-0.606/5.
         a3=0.197/5.
         magn=mag(idx)
         smagn=smag(idx)
         col=(color(idx)-0.034)/0.993
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'Gallenne_VVK') then
         a0=2.667/5.
         a1=1.331/5.
         a2=0.0/5.
         a3=0.0/5.
         magn=mag(idx)
         smagn=smag(idx)
         col=(color(idx)-0.034)/0.993
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'Kerv_dwarf_linearVVK') then
         a0=0.5178
         a1=0.2652
         a2=0.0
         magn=mag(idx)
         smagn=smag(idx)
         col=color(idx)
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'diBenedetto98V_linearVVK') then
c-- Relation from class V stars linearized at V-K=1.0
         a0=0.5324
         a1=0.2736
         a2=0.0
         magn=mag(idx)
         smagn=smag(idx)
         col=(color(idx)-0.034)/0.993
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'diBenedetto98III_linearVVK') then
c-- Relation from class III stars linearized at V-K=1.0
         a0=0.5380
         a1=0.2710
         a2=0.0
         magn=mag(idx)
         smagn=smag(idx)
         col=(color(idx)-0.034)/0.993
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'diBenedetto98III_linearVVKoff') then
c-- Relation from class III stars linearized at V-K=1.0
         a0=0.5380
         a1=0.2710
         a2=0.0
         magn=mag(idx)
         smagn=smag(idx)
         col=color(idx)+0.05
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'diBenedetto98III_parabVVK') then
         a0=0.5314
         a1=0.2842
         a2=-0.0066
         magn=mag(idx)
         smagn=smag(idx)
         col=(color(idx)-0.034)/0.993
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'diBenedetto98III_parabVVKoff') then
         a0=0.5314
         a1=0.2842
         a2=-0.0066
         magn=mag(idx)
         smagn=smag(idx)
         col=color(idx)+0.05
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'diBenedetto98all_parabVVK') then
         a0=0.5126
         a1=0.2986
         a2=-0.0092
         magn=mag(idx)
         smagn=smag(idx)
         col=(color(idx)-0.034)/0.993
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'diBenedetto05_parabVVK') then
         a0=0.5130
         a1=0.2966
         a2=-0.0088
         magn=mag(idx)
         smagn=smag(idx)
c         col=(color(idx)-0.034)/0.993
         col=1.011*color(idx)-0.026
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'diBenedetto05_linearVVK') then
         a0=0.5218
         a1=0.2802
         a2=0.0
         magn=mag(idx)
         smagn=smag(idx)
         col=(color(idx)-0.034)/0.993
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'diBenedetto05_linearVVKoff') then
         a0=0.5218
         a1=0.2802
         a2=0.0
         magn=mag(idx)
         smagn=smag(idx)
         col=color(idx)+0.055
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'diBenedetto05CEP_linearVVK') then
c-- Is based on SAAO colors on the Carter system
         a0=0.5434
         a1=0.2624
         a2=0.0
         magn=mag(idx)
         smagn=smag(idx)
         col=color(idx)
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'dCep_linearVVK') then
         a0=0.5594
         a1=0.2468
         a2=0.0
         magn=mag(idx)
         smagn=smag(idx)
         col=color(idx)
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'dCep22_linearVVK') then
         a0=0.5594
         a1=0.22
         a2=0.0
         magn=mag(idx)
         smagn=smag(idx)
         col=color(idx)
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'dCep24_linearVVK') then
         a0=0.5594
         a1=0.24
         a2=0.0
         magn=mag(idx)
         smagn=smag(idx)
         col=color(idx)
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'dCep26_linearVVK') then
         a0=0.5594
         a1=0.26
         a2=0.0
         magn=mag(idx)
         smagn=smag(idx)
         col=color(idx)
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'V9_linearVVK') then
         a0=0.55
         a1=0.256
         a2=0.0
         magn=mag(idx)
         smagn=smag(idx)
         col=color(idx)
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'Gro08_linearVVK') then
         a0=0.5283
         a1=0.2724
         a2=0.0
         magn=mag(idx)
         smagn=smag(idx)
         col=color(idx)
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'FG_linearVVK075') then
         a0=0.5474
         a1=0.257
         a2=0.0
         magn=mag(idx)
         smagn=smag(idx)
         col=color(idx)
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'SEDF_VVK') then
         thetap = 10**(0.5135 - 0.2*mag(idx) + 0.2687*color(idx)
     +            - 0.0174*color(idx)*color(idx)
     +            - 0.0028*logg)
         sigthp = sqrt((0.2*smag(idx))**2 + (0.2687*scolor(idx))**2)
     +            * thetap * log(10.)
         return
      elseif(ctrel .eq. 'FG_linearVVK225') then
         a0=0.5474
         a1=0.2658
         a2=0.0
         magn=mag(idx)
         smagn=smag(idx)
         col=color(idx)
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'FG_linearVVKsmc') then
         a0=0.5520
         a1=0.2603
         a2=0.0
         magn=mag(idx)
         smagn=smag(idx)
         col=color(idx)
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'FG_linearVVKexp') then
         a0=0.5074
         a1=0.308
         a2=0.0
         magn=mag(idx)
         smagn=smag(idx)
         col=color(idx)
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'FG_linearVVR') then
         a0=0.5474
         a1=0.760
         a2=0.0
         magn=mag(idx)
         smagn=smag(idx)
         col=color(idx)
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'FG_linearVVRexp') then
         a0=0.5474
         a1=0.700
         a2=0.0
         magn=mag(idx)
         smagn=smag(idx)
         col=color(idx)
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'FG_linearKJK') then
         a0=0.5474
         a1=0.220
         a2=0.0
         magn=mag(idx)
         smagn=smag(idx)
         col=color(idx)
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'FG_parabVVR') then
         a0=0.4419
         a1=0.9685
         a2=-0.10652
         magn=mag(idx)
         smagn=smag(idx)
         col=color(idx)
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'Darek_test') then
         a0=2.6733/5.
         a1=1.3319/5.
         magn=mag(idx)
         smagn=smag(idx)
         col=color(idx)
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'Darek_linearVVK') then
         a0=2.6547/5.
         a1=1.3637/5.
         a2=0.0
         a3=0.0
         a4=0.0
         a5=0.0
         magn=mag(idx)
         smagn=smag(idx)
         col=color(idx)
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'Graczyk17_linearVVK') then
         a0=2.644/5.
         a1=1.358/5.
         a2=0.0
         a3=0.0
         a4=0.0
         a5=0.0
         magn=mag(idx)
         smagn=smag(idx)
         col=color(idx)
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'RRLyr_linearVVK') then
         a0=2.6547/5.
         a1=1.32/5.
         a2=0.0
         a3=0.0
         a4=0.0
         a5=0.0
         magn=mag(idx)
         smagn=smag(idx)
         col=color(idx)
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'Darek_3deg') then
         a0=2.6277/5.
         a1=1.6508/5.
         a2=-0.3825/5.
         a3=0.1328/5.
         a4=0.0
         a5=0.0
         magn=mag(idx)
         smagn=smag(idx)
         col=color(idx)
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'Darek_5deg') then
         a0=2.61178/5.
         a1=1.78504/5.
         a2=-0.68352/5.
         a3=0.397499/5.
         a4=-0.09299/5.
         a5=0.00934/5.
         magn=mag(idx)
         smagn=smag(idx)
         col=color(idx)
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'Graczyk17_5deg') then
         a0=2.606/5.
         a1=1.526/5.
         a2=-0.989/5.
         a3=1.498/5.
         a4=-0.835/5.
         a5=0.156/5.
         magn=mag(idx)
         smagn=smag(idx)
         col=color(idx)
         scol=scolor(idx)
         goto 198
      elseif(ctrel .eq. 'tabular') then
         goto 200
      else
         write(nstdout,'(''ERROR: No valid color-temperature '',
     +   '' relation specified'')')
         return
      endif

  198 continue
      thetap = 10**(a0 + a1*col + a2*col*col + 
     +              a3*col**3 + a4*col**4
     +              + a5*col**5 - 0.2*magn)
      sigthp = sqrt((0.2*smagn)**2 + (a1*scol)**2)
     +         * thetap * log(10.)
      return

c-- For the tabular approach (Fry and Carney tables f.ex.)
c
  200 continue

      phase=phmag(idx)
c-- Get the color and magnitude at the requested phase
c
      call int1d(nmag,phmag,color,phase,col,iflag)
      call int1d(nmag,phmag,mag,phase,v,iflag)

c-- Get the temperature
c
      call gett(ncol,nrow,loggs,ths,colg,logg,col,teff,iflag)
      if(iflag .lt. 0) then
	 write(nstdout,'(''Warning: gett Interpolation failed'')')
	 nwarn=nwarn+1
	 write(nstdout,*) phase,logg,col,v
      endif
      theta=5040./teff

c-- Get the Bolometric Correction
c
      call int2d(ncol,nrow,loggs,ths,bcg,logg,theta,bc,iflag)
      if(iflag .lt. 0) then
	 write(nstdout,'(''Warning: Interpol. failed for Theta and BC'')')
	 nwarn=nwarn+1
      endif

      teff=5040./theta

      if(teff .gt. 0) then
         Sv = Sv0 - 10. * log10(teff) - bc
      else
	 write(nstdout,'(''ERROR: Teff negative in thphot'')')
      endif

      tempo = (Sv - v)/5.
      thetap = 10**((Sv - v)/5.)
      sigthp = 1.0

c      thetapx=10**(0.5474 - 0.2*mag(idx) + 0.760*color(idx))
c      tx=10**(3.947 - 0.379*color(idx)-0.1*bc)
c      write(nstdout,*) phase,color(idx),col,logg,bc
c      write(nstdout,*) teff,tx,thetap,thetapx

  900 continue
      return
      end
