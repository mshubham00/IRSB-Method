      parameter(NPTSX=500,NCOLX=20,NROWX=20)
      parameter(nstdin=5,nstdout=6)
C      parameter(stdin=7,stdout=8)

      real mag(NPTSX),color(NPTSX),rv(NPTSX),rvc(NPTSX)
      real phmag(NPTSX),phrv(NPTSX),phrvc(NPTSX)
      real smag(NPTSX),scolor(NPTSX),srv(NPTSX),srvc(NPTSX)
      real pfactor(NPTSX)
      real colg(NCOLX*NROWX),bcg(NCOLX*NROWX)
      real temps(NROWX),ths(NROWX),loggs(NCOLX)
      real pv(NPTSX)
      real inmass,indist,inlogg,ebv,ecolbv,dabsorb,Mass
      real massstep,massrng,diststep,distrng,loggstep,loggrng
      real gamma,pfac,period
      real Msol,Rsol,Lsol,gc,sbc,pi,Sv0,mpc
      real phmin1,phmax1,phmin2,phmax2
      real mmag0,mmag0m,mmbol,mcolor0,mcolor0m
      integer ncol,nrow,nmag,nrv,nrvc,ncolor,accterm,nwarn
      integer bisector,ngiter
      integer fdout,fdlog

      character*80 infile,outfile,logfile
      character*40 ident,colsys,synid,ctrel,pfacrel,Massrel
      character*80 syntab,magfile,rvfile,rvcfile

      common/data/phmag,mag,smag,phcol,color,scolor,pv,phrv,
     +            rv,srv,phrvc,rvc,srvc,nrv,nrvc,pfactor,
     +            nmag,ncolor
      common/indata1/inmass,indist,inlogg,massstep,massrng,
     +               diststep,distrng,loggstep,loggrng,
     +               phmin1,phmax1,phmin2,phmax2,Mass
      common/indata2/ebv,ecolbv,dabsorb,gamma,pfac,period,accterm,
     +               mmag0,mmag0m,mmbol,mcolor0,mcolor0m,nwarn
      common/indata3/bisector,ngiter
      common/identi/ident,colsys,synid
      common/tables/temps,ths,loggs,colg,bcg,ncol,nrow
      common/fname/infile,outfile,logfile,syntab,magfile,rvfile,rvcfile,
     +             ctrel,pfacrel,Massrel
      common/fd/fdout,fdlog
      common/const/Msol,Rsol,Lsol,gc,sbc,pi,Sv0,mpc
