BEGIN{i=1;j=1}
{
	if(NR==1){
	   title=$0
	}
	if(NR==2){
	  ni=$1
	  nj=$2
	  dim=$0
	}
	if(NR==3){
	  teff=$0
	}
	if(NR==4){
	  logg=$0
	}
	if(NR==5){
	  bcoff=$0
	}
	if(NR > 5 && NR < nj+6){
	   while(j<=nj){
	      while(i<=ni){
	        bclow[i,j]=$i
	        i++
	      }
	      #print NR,i,j,$0
	      i=1
	      j++
	      next
	   }
	}
	if(NR == nj+6){
	   i=1
	   j=1
	}
	if(NR > nj+6 && NR <= 2*nj+6){
	   while(j<=nj){
	      while(i<=ni){
	        vklow[i,j]=$i
	        i++
	      }
	      #print NR,i,j,$0
	      i=1
	      j++
	      next
	   }
	}
	if(NR == 2*nj+11){
	   i=1
	   j=1
	}
	if(NR > 2*nj+11 && NR <= 3*nj+11){
	   while(j<=nj){
	      while(i<=ni){
	        bchi[i,j]=$i
	        i++
	      }
	      #print NR,i,j,$0
	      i=1
	      j++
	      next
	   }
	}
	if(NR == 3*nj+12){
	   i=1
	   j=1
	}
	if(NR > 3*nj+12 && NR <= 4*nj+12){
	   while(j<=nj){
	      while(i<=ni){
	        vkhi[i,j]=$i
	        i++
	      }
	      #print NR,i,j,$0
	      i=1
	      j++
	      next
	   }
	}
}
END{
	j=1
	i=1
	#print "Output:"
	print "BCP_(V-K)_FeH="feh
	print dim
	print teff
	print logg
	print bcoff
	while(j<=nj){
	   while(i<=ni){
	     slp=(bchi[i,j]-bclow[i,j])/(fehhi-fehlow)
	     dfeh=feh-fehlow
	     bc=bclow[i,j]+dfeh*slp
	     printf("%6.3f ",bc)
	     #printf("%6.3f ",bchi[i,j])
	     i++
	   }
	   i=1
	   printf("\n")
	   j++
	}
	print "0.0"
	j=1
	i=1
	while(j<=nj){
	   while(i<=ni){
	     slp=(vkhi[i,j]-vklow[i,j])/(fehhi-fehlow)
	     dfeh=feh-fehlow
	     vk=vklow[i,j]+dfeh*slp
	     printf("%6.3f ",vk)
	     #printf("%6.3f ",vkhi[i,j])
	     i++
	   }
	   i=1
	   printf("\n")
	   j++
	}
}
