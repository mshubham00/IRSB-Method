BEGIN{i=1;j=1;loggprev=-1}
{
	if($1<0 || $1>10000){
	   #print "OK"
	   next
	}
	teff=$2
	logg=$3
	if(logg < 0.49){
	   next
	}
	if(teff > 7501){
	   teffidx[i]=teffprev
	   next
	}
	if(logg < loggprev){
	   teffidx[i]=teffprev
	   nlogg=j-1
           i++
	   j=1
	}else{
	   loggidx[j]=logg
	   #print j,logg
	}
	bcv[i,j]=$8
	vk[i,j]=$14
	j++

	teffprev=teff
	loggprev=logg
	nteff=i
}END{
	print "BCP_(V-K)_FeH="feh
	print nlogg,nteff
	i=0
	while(i<nteff){
	   i++
	   printf("%6.1f ",teffidx[i])
	}
	printf("\n")
	i=0
	while(i<nlogg){
	   i++
	   printf("%4.2f ",loggidx[i])
	}
	printf("\n")
	printf("0.0\n")
	i=0
	while(i<nteff){
	   i++
	   j=0
	   while(j<nlogg){
	      j++
	      printf("%6.3f ",bcv[i,j])
	   }
	   printf("\n")
	}
	printf("0.0\n")
	i=0
	while(i<nteff){
	   i++
	   j=0
	   while(j<nlogg){
	      j++
	      printf("%6.3f ",vk[i,j])
	   }
	   printf("\n")
	}
}
