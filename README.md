# **How to download genomes using the accession number**



### **Asad Prodhan PhD** 


**https://asadprodhan.github.io/**


<br />

## **Step 1: Collect the accession numbers of your interest**


- collect the assembly summary report for your organism of interest from the NCBI RefSeq Index. For example, the assembly summary report for Bacteria can be obtained as follows:


    ```
    wget ftp://ftp.ncbi.nih.gov/genomes/refseq/bacteria/assembly_summary.txt
    ```
    
    
For other organisms, navigate to the assembly summary report starting from the ‘Index of /genomes/refseq’ as shown in Fig. 1:


<br />
<p align="center">
  <img 
    src="https://github.com/asadprodhan/How-to-download-genomes-using-the-accession-number/blob/main/Index_NCBI.PNG"
  >
</p>
<p align = "center">
Figure 1. Index of the genomes in the RefSeq
</p>
<br />


- Filter out your targeted genomes from the assembly report. For example, all species of Pseudomonas can be extracted from the bacterial assembly report as follows:


    ```
    #!/bin/bash
    awk -F '\t' '{if($8 ~ /Pseudomonas/) print $1","$2","$3","$5","$8","$11","$12","$14","$15","$16","$20}' assembly_summary.txt > assembly_summary_complete_genomes_Pseudomonas.txt
    ```
    
    
    Column 8 ($8) in the assembly report contains the name of the species. ‘~ /Pseudomonas/’ will extract only the Pseudomonas species
    Here, we are extracting Pseudomonas species along with other metadata in different columns of the assembly report.
    
    
    Column 1 ($1):  # assembly_accession
    
    
    Column 2 ($2):  bioproject ID
    
    
    Column 3 ($3):  biosample ID
    
    
    Column 5 ($5):  refseq_category, is it a representative genome? representative genome are quality-checked by RefSeq team 
    
    
    Column 8 ($8):  organism_name
    
    
    Column 11 ($11):  version_status, is it latest?
    
    
    Column 12 ($12):  assembly_level, complete genome, scaffold or contig
    
    
    Column 14 ($14):  genome_rep, full? or partial?
    
    
    Column 15 ($15):  seq_rel_date, release date
    
    
    Column 16 ($16):  asm_name, assembly name
    
    
    Column 20 ($20):  ftp_path, the download link (however, the links, as they appear here, do not download the files, the links need to be amended in the following step to get them download-ready)
    
    
- Make a csv file with the accession numbers only and name it as ‘accession_list.csv’ (Fig. 2)

<br />
<p align="center">
  <img 
    src="https://github.com/asadprodhan/How-to-download-genomes-using-the-accession-number/blob/main/accession_list.PNG"
  >
</p>
<p align = "center">
Figure 2. Accession list
</p>
<br />

## **Step 2: Install ‘NCBI Datasets’ tool**


- Create a conda environment


    ```
    conda create -n ncbi_datasets
    ```


- Activate ncbi_datasets



    ```
    conda activate ncbi_datasets
    ```


- Install ncbi-datasets package


    ```
    conda install -c conda-forge ncbi-datasets-cli
    ```


Ref: https://www.ncbi.nlm.nih.gov/datasets/docs/v2/download-and-install/

<br />

## **Step 3: Download the genomes**


- Make a directory and name it “Downloads”


- cd to ‘Downloads’ directory


- Keep the following script in the ‘Downloads’ directory 

<br />

## **The script**


        ```
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

        ```
<br />


- Keep the ‘accession_list.csv’ file (Fig. 2) in the ‘Downloads’ directory


- Check the file type of ‘accession_list.csv’


    ```
    file accession_list.csv
    ```
    
    
    - If it is ‘ASCII text, with CRLF line terminators’ i.e., Windows file type; then convert it to ‘Unix’ format as follows:
    
    
    ```
    dos2unix accession_list.csv
    ```
    
    
- Run the following script as follows:


    ```
    ./name_of_the_script.sh
    ```


**The script will be automatically downloading the genomic sequences (Fig. 3).**


<br />
<p align="center">
  <img 
    src="https://github.com/asadprodhan/How-to-download-genomes-using-the-accession-number/blob/main/Output.PNG"
  >
</p>
<p align = "center">
Figure 3. The script is automatically downloading the genomic sequences
</p>

<br />

## **Output files**


<br />
<p align="center">
  <img 
    src="https://github.com/asadprodhan/How-to-download-genomes-using-the-accession-number/blob/main/FileName_and_Header_Before.PNG"
  >
</p>
<p align = "center">
Figure 4. An image showing the output files with their file names and headers. 
</p>

<br />

<br />

**Note: The script can download the entire BioProject by replacing the accession number by the BioProject number. Downloading using the BioProject number will automatically download all the associated data and metadata.**

<br />

However, if the file names and headers (Fig. 4) are too big to deal with, they can be shortented (Fig. 5) by replacing the above script by the following script:

<br />

## **The script that will retrieve the genomic data and shorten names and headers**

<br />

```
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

```

<br />

## **Output files with SHORTENED names and headers**

<br />
<p align="center">
  <img 
    src="https://github.com/asadprodhan/How-to-download-genomes-using-the-accession-number/blob/main/FileName_and_Header_After.PNG"
  >
</p>
<p align = "center">
Figure 5. An image showing the output files with their **SHORTENED** file names and headers
</p>
<br />

<br />

### **Now, you have downloaded the genomic sequences of all the accessions in the list.**


