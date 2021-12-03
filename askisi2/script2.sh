#! /bin/bash

IsTXT() {

  for file in $dir/*
  do
    if [[ $file == *.txt ]]
    then 

      while IFS= read -r line
        do 
          if [[ ! "$line" =~ ^#.*  ]] && [[ "$line" == "https"* ]]
          then
            cd assingments
            git clone "$line" -q
            if [ $? -eq 0 ] 
            then
              echo `basename $line`": Cloning OK"
            else
              echo `basename $line`": Cloning  FAILED"
            fi
            cd ..
            break
          fi
 
      done < "$file"

    fi
  done

}

SearchDirs() {

for dir in $directory/*
do
    if [ -d "$dir" ] 
    then
      
      IsTXT "$dir"
      directory=$dir
      SearchDirs "$directory"        
        
    fi
done

}
FilesOrdered=("DataA.txt" "more" "DataB.txt" "DataC.txt")

CountFiles() {

  for file in $repo/*
    do 
    
      count=$((count+1))
      if [[ "${FilesOrdered[$count]}" != `basename $file` ]]
      then
        flag=0
      fi
      if [[ $file == *.txt ]]
      then
        txts=$(( txts + 1 ))
      elif [ -d "$file" ]
      then 
        dirs=$(( dirs + 1 ))
        repo="$file"
        CountFiles "$repo"
      else
        otherFiles=$(( otherFiles + 1 ))
      fi
      
    done
}


StructureCheck() {

  for repo in $directory/*
  do 
    flag=1
    count=-1
    dirs=0
    txts=0
    otherFiles=0

    echo `basename $repo`":"
    CountFiles "$repo"

    echo "Number of directories: "$dirs
    echo "Number of txt files: "$txts
    echo "Number of other files: "$otherFiles


    if [[ $flag == 1 && count==6 ]]
    then
      echo "Directory structure is OK."
    else  
      echo "Directory structure is NOT OK."
    fi
  
  done
}

tar xf $1
mkdir assingments


directory="${1%%.*}"
SearchDirs "$directory"
directory="assingments"
StructureCheck "$directory"

