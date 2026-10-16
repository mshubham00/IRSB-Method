BEGIN{ni=10;nj=17;i=1;j=1}
{
	while(j<=nj){
	   while(i<=ni){
	     arr[i,j]=$i
	     i++
	   }
	   print NR,i,j,$0
	   i=1
	   j++
	   next
	}
}
END{
	j=1
	i=1
	print "Output:"
	while(j<=nj){
	   while(i<=ni){
	     printf("%6.3f ",arr[i,j])
	     i++
	   }
	   i=1
	   printf("\n")
	   j++
	}
}
