F77 = gfortran
FFLAGS = -O
BINDIR = ${HOME}/bin
SCRDIR = ${HOME}/scr

svb: svb.h svb.o gett.o int1d.o int2d.o readin.o thphot.o \
     drspec.o getg.o getidx.o sixlin.o
	${F77} ${FFLAGS} svb.o gett.o int1d.o int2d.o readin.o \
	    thphot.o drspec.o getg.o getidx.o sixlin.o -o svb

svb_pvk: svb.h svb_pvk.o gett.o int1d.o int2d.o readin.o thphot.o \
     drspec.o getg.o getidx.o sixlin.o
	${F77} ${FFLAGS} svb_pvk.o gett.o int1d.o int2d.o readin.o \
	    thphot.o drspec.o getg.o getidx.o sixlin.o -o svb_pvk

svb_dfit: svb.h svb_dfit.o gett.o int1d.o int2d.o readin.o thphot.o \
     drspec.o getg.o getidx.o sixlin.o
	${F77} ${FFLAGS} svb_dfit.o gett.o int1d.o int2d.o readin.o \
	    thphot.o drspec.o getg.o getidx.o sixlin.o -o svb_dfit
	mv svb_dfit ${BINDIR}

svbtest: svb.h svbtest.o gett.o int1d.o int2d.o readin.o thphot.o \
     drspec.o getg.o getidx.o sixlin.o
	${F77} ${FFLAGS} svbtest.o gett.o int1d.o int2d.o readin.o \
	    thphot.o drspec.o getg.o getidx.o sixlin.o -o svbtest
	mv svbtest ${BINDIR}

install: svb scripts/svbinit
	mv svb ${BINDIR}
	cp scripts/svbinit ${SCRDIR}

clean:
	rm *.o
