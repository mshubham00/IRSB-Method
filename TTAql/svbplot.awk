BEGIN{ok=0}
{
	if($1 == str2){
	   exit
	}
	if(ok == 1){
	   print $0
	}
	if($1 == str1){
	   ok=1
	}
}
