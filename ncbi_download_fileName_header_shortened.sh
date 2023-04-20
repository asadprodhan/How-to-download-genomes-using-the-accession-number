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
    echo "${Bold}Renaming "${field1}" fasta file${reset}"
    mv *.fna "${field1}.fasta"
    echo "${Bold}Shortening the "${field1}" fasta file header${reset}"
    for fasta in *.fasta; 
    do
        cut -f 1 -d " " $fasta > ${fasta%.*}.temp;
        mv ${fasta%.*}.temp $fasta
    done
    echo "${Bold}Moving "${field1}.fasta" into home directory${reset}"
    mv "${field1}.fasta" ../../../
    cd "../../../"
    rm -r "${field1}".zip ncbi_dataset *.md  
    echo "${Green}${Bold}Download_completed ${reset}: ${field1}" 
    echo ""
done < ${metadata}

