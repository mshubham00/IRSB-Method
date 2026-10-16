C************************************************************************
C************************* SUBROUTINE SIXLIN ****************************
C************************************************************************
C
       SUBROUTINE SIXLIN(NMAX,N,X,Y,A,SIGA,B,SIGB)
C     *
C     *                     SIX LINEAR REGRESSIONS
C     *     WRITTEN BY T. ISOBE, G. J. BABU AND E. D. FEIGELSON
C     *               CENTER FOR SPACE RESEARCH, M.I.T.
C     *                             AND
C     *              THE PENNSYLVANIA STATE UNIVERSITY
C     *
C     *                   REV. 1.0,   SEPTEMBER 1990
C     *
C     *       THIS SUBROUTINE PROVIDES LINEAR REGRESSION COEFFICIENTS
C     *    COMPUTED BY SIX DIFFERENT METHODS DESCRIBED IN ISOBE,
C     *    FEIGELSON, AKRITAS, AND BABU 1990, ASTROPHYSICAL JOURNAL
C     *    AND BABU AND FEIGELSON 1990, SUBM. TO TECHNOMETRICS.
C     *    THE METHODS ARE OLS(Y/X), OLS(X/Y), OLS BISECTOR, ORTHOGONAL,
C     *    REDUCED MAJOR AXIS, AND MEAN-OLS REGRESSIONS.
C     *
C     *    INPUT
C     *         X(I) : INDEPENDENT VARIABLE
C     *         Y(I) : DEPENDENT VARIABLE
C     *            N : NUMBER OF DATA POINTS
C     *
C     *    OUTPUT
C     *         A(J) : INTERCEPT COEFFICIENTS
C     *         B(J) : SLOPE COEFFICIENTS
C     *      SIGA(J) : STANDARD DEVIATIONS OF INTERCEPTS
C     *      SIGB(J) : STANDARD DEVIATIONS OF SLOPES
C     *     WHERE J = 1, 6.
C     *
C     *    ERROR RETURNS
C     *         CALCULATION IS STOPPED WHEN DIVISION BY ZERO WILL
C     *         OCCUR (I.E. WHEN SXX, SXY, OR EITHER OF THE OLS
C     *         SLOPES IS ZERO).
C
C
       IMPLICIT REAL*8(A-H,O-Z)
       DIMENSION X(NMAX),Y(NMAX)
       DIMENSION A(6),B(6),SIGA(6),SIGB(6)
C
C
C     *         INITIALIZATIONS
C
       S1 = 0.0
       S2 = 0.0
       SXX = 0.0
       SYY = 0.0
       SXY = 0.0
       SUM1 = 0.0
       SUM2 = 0.0
       SUM3 = 0.0
       RN = N
       DO 50 J = 1, 6
         A(J)    = 0.0
         SIGA(J) = 0.0
         B(J)    = 0.0
         SIGB(J) = 0.0
   50  CONTINUE
C
C     *         COMPUTE AVERAGES AND SUMS
C
       DO 100 I=1,N
         S1 = S1 + X(I)
         S2 = S2 + Y(I)
  100  CONTINUE
       XAVG = S1/RN
       YAVG = S2/RN
       DO 200 I = 1, N
       X(I) = X(I) - XAVG
       Y(I) = Y(I) - YAVG
       SXX  = SXX  + X(I)**2
       SYY  = SYY  + Y(I)**2
       SXY  = SXY  + X(I)*Y(I)
 200   CONTINUE
       IF(SXY.EQ.0.0) THEN
         WRITE(*,992) (X(I),Y(I),I=1,N)
 992     FORMAT(2F10.3)
         WRITE(*,991)
         STOP
 991   FORMAT(5X,'SXY IS ZERO.  SIXLIN TERMINATED.')
       ENDIF
       SIGN = 1.0
       IF(SXY .LT. 0.0) SIGN = -1.0
C
C
C     *               COMPUTE THE SLOPE COEFFICIENTS
C
C
       B(1) = SXY/SXX
       B(2) = SYY/SXY
       B(3) = (B(1)*B(2) - 1.0
     +  + DSQRT((1.0 + B(1)**2)*(1.0 + B(2)**2)))/(B(1) + B(2))
       B(4) = 0.5*(B(2) - 1.0/B(1)
     +                 + SIGN*DSQRT(4.0 + (B(2) - 1.0/B(1))**2))
       B(5) = SIGN*DSQRT(B(1)*B(2))
       B(6) = 0.5*(B(1) + B(2))
C
C
C     *            COMPUTE INTERCEPT COEFFICIENTS
C
C
       DO 300 J = 1, 6
         A(J) = YAVG - B(J)*XAVG
 300   CONTINUE
C
C
C      *     PREPARE FOR COMPUTATION OF VARIANCES
C
C
       GAM1 = B(3)/((B(1) + B(2))
     +         *DSQRT((1.0 + B(1)**2)*(1.0 + B(2)**2)))
       GAM2 = B(4)/(DSQRT(4.0*B(1)**2 + (B(1)*B(2) - 1.0)**2))
       DO 400 I = 1, N
        SUM1 = SUM1 + (X(I)*(Y(I) - B(1)*X(I)))**2
        SUM2 = SUM2 + (Y(I)*(Y(I) - B(2)*X(I)))**2
        SUM3 = SUM3 + X(I)*Y(I)*(Y(I) - B(1)*X(I))*(Y(I) - B(2)*X(I))
  400  CONTINUE
       COV = SUM3/(B(1)*SXX**2)
C
C
C     *    COMPUTE VARIANCES OF THE SLOPE COEFFICIENTS
C
C
       SIGB(1) = SUM1/(SXX**2)
       SIGB(2) = SUM2/(SXY**2)
       SIGB(3) = (GAM1**2)*(((1.0 + B(2)**2)**2)*SIGB(1)
     +               + 2.0*(1.0 + B(1)**2)*(1.0 + B(2)**2)*COV
     +               + ((1.0 +B(1)**2)**2)*SIGB(2))
       SIGB(4) = (GAM2**2)*(SIGB(1)/B(1)**2 + 2.0*COV
     +               + B(1)**2*SIGB(2))
       SIGB(5) = 0.25*(B(2)*SIGB(1)/B(1)
     +                       + 2.0*COV + B(1)*SIGB(2)/B(2))
       SIGB(6) = 0.25*(SIGB(1) + 2.0*COV + SIGB(2))
C
C
C     *   COMPUTE VARIANCES OF THE INTERCEPT COEFFICIENTS
C
C
       DO 500 I = 1, N
          SIGA(1) = SIGA(1) + ((Y(I) - B(1)*X(I))
     +                        *(1.0 - RN*XAVG*X(I)/SXX))**2
          SIGA(2) = SIGA(2) + ((Y(I) - B(2)*X(I))
     +                        *(1.0 - RN*XAVG*Y(I)/SXY))**2
          SIGA(3) = SIGA(3) + ((X(I)*(Y(I)
     +            - B(1)*X(I))*(1.0 + B(2)**2)/SXX
     +            + Y(I)*(Y(I) - B(2)*X(I))*(1.0 + B(1)**2)/SXY)
     +              *GAM1*XAVG*RN - Y(I) + B(3)*X(I))**2
          SIGA(4) = SIGA(4) + ((X(I)*(Y(I) - B(1)*X(I))/SXX
     +            + Y(I)*(Y(I) - B(2)*X(I))*(B(1)**2)/SXY)*GAM2
     +               *XAVG*RN/DSQRT(B(1)**2) - Y(I) + B(4)*X(I))**2
          SIGA(5) = SIGA(5) + ((X(I)*(Y(I)
     +            - B(1)*X(I))*DSQRT(B(2)/B(1))/SXX
     +            + Y(I)*(Y(I) - B(2)*X(I))*DSQRT(B(1)/B(2))/SXY)
     +              *0.5*RN*XAVG - Y(I) + B(5)*X(I))**2
          SIGA(6) = SIGA(6) + ((X(I)*(Y(I) - B(1)*X(I))/SXX
     +            + Y(I)*(Y(I) - B(2)*X(I))/SXY)
     +              *0.5*RN*XAVG - Y(I) + B(6)*X(I))**2
  500  CONTINUE
C
C
C     *  CONVERT VARIANCES TO STANDARD DEVIATIONS
C
C
       DO 600 J = 1, 6
          SIGB(J) = DSQRT(SIGB(J))
          SIGA(J) = DSQRT(SIGA(J))/RN
  600  CONTINUE
C
C
C     *  RETURN DATA ARRAYS TO THEIR ORIGINAL FORM
C
C
       DO 900 I = 1, N
          X(I) = X(I) + XAVG
          Y(I) = Y(I) + YAVG
  900  CONTINUE
C
C
       RETURN
       END
