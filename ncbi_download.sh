#!/bin/bash

#metadata
metadata=./*.csv
#
Red="$(tput setaf 1)"
Green="$(tput setaf 2)"
Bold=$(tput bold)
reset=`tput sgr0` # turns off all atribute
while IFS=, read -r field1  

do 
    echo ""
    echo "${Red}${Bold}Downloading ${reset}: "${field1}"" 
    datasets download genome accession "${field1}" --filename "${field1}".zip
    echo "${Bold}Extracting "${field1}.zip" ${reset}"
    unzip "${field1}.zip" 
    cd "ncbi_dataset/data/${field1}" 
    echo "${Bold}Moving "${field1}" fasta file into home directory${reset}"
    mv *.fna ../../../
    cd "../../../"
    rm -r "${field1}".zip ncbi_dataset *.md  
    echo "${Green}${Bold}Download_completed ${reset}: ${field1}" 
    echo ""
done < ${metadata}

