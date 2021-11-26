
parallel(){
	
    wget -q "$CurrentPage" -O /dev/null
    exit_code=$?
    if (( exit_code == 0 ))
    then
      WebPageName=`echo "$CurrentPage" | sed -e 's|^[^/]*//||' -e 's|/.*$||'`
      
      if [[ ! -f "$WebPageName.txt" ]]
      then

        echo "$CurrentPage INIT"
        wget -q -O "$WebPageName.txt" "$CurrentPage"
      else

        sum1=` md5sum "$WebPageName.txt"`
        wget -q -O "$WebPageName.txt" "$CurrentPage"  
        sum2=` md5sum "$WebPageName.txt"`

        if [ "$sum1" != "$sum2" ];
        then
          echo "$CurrentPage"
        fi
      fi
    else
      >&2 echo "$CurrentPage FAILED"
    fi


}



while IFS= read -r line
do 
  CurrentPage="$line"
  if [[ ! "$CurrentPage" =~ ^#.*  ]] 
  then
    parallel "$CurrentPage" &
  fi
  
 
done < WebPages.txt


wait 
