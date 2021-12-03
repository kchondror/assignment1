#! /bin/bash


flag=0


clean() {
   	local a=`echo "$1" | cut -d"'" -f1`
   	a=`echo "${a,,}"`
   	
   	
   	IFS='-'     
	read -ra ADDR <<< "$a"   
	for i in "${ADDR[@]}"
	do   
	    	a=${i//[^[:alnum:]]/} 
    		echo "$a" >> temp.txt
	done
	IFS=' ' 
   		
}



while read line
do

	if [[ "$line" == "*** START OF THE PROJECT GUTENBERG EBOOK"* ]]
	then
		flag=1
		continue
		
	elif [[ "$line" == "*** END OF THE PROJECT GUTENBERG EBOOK"* ]]
	then
		flag=0
	fi
	
	
	if [[ $flag == 1 ]] 
	then
		for word in $line
		do
			clean $word
		done
		
	fi

done < $1

sed -e 's/\s/\n/g' < temp.txt | sort | uniq -c | sort -nr | head  -$2 > temp2.txt

while read line
do
	echo "$line"|tr ' ' '\n'|tac|tr '\n' ' '
	echo " "
done < temp2.txt



rm temp2.txt
rm temp.txt


