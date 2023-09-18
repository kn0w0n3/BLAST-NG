# BLAST-NG    
Bioinformatics tool for searching sequence similarities:  

Windows Installer Download: https://github.com/kn0w0n3/BLAST-NG/releases/tag/v1.2.0    

The Basic Local Alignment Search Tool (BLAST) finds regions of local similarity between sequences. The program compares nucleotide or protein sequences to sequence databases and calculates the statistical significance of matches.    

![blast-ng-gui-8-14-23](https://github.com/kn0w0n3/BLAST-NG/assets/22214754/7aed3bfe-cd63-46c5-8c8c-a24a4d36e6a6)  

# **Usage:**    

* **BLASTp:** Searches a protein query against a protein database           

* **BLASTn:** Searches a nucleotide query against a nucleotide database       

* **BLASTx:** Searches a nucleotide query, dynamically translated in all six frames, against a protein database    
  
* **tBLASTn:** Searches a protein query against a nucleotide database dynamically translated in all six frames    

* **tBLASTx:** Searches a nucleotide query, dynamically translated in all six frames, against a nucleotide database similarly translated    

### Databases are required to perform BLAST queries.

* Option 1: Build a custom databse using BLAST-NG.      

* Option 2: Download databases manually from the NCBI/other sources and use BLAST-NG to build/format the database.  
https://ftp.ncbi.nlm.nih.gov/blast/db/FASTA/ 

* Option 3: Use Bio Database Manager to download and automatically decompress preformatted databases from the NCBI. 

Windows Installer Download: https://github.com/kn0w0n3/Bio-Database-Manager/releases  
![bio_database_manager_gui_8-19-23](https://github.com/kn0w0n3/Bio-Database-Manager/assets/22214754/77b58dd3-8006-4564-bb65-aa5263c71ed3)          

# **Examples:**  

<iframe width="560" height="315" src="https://www.youtube.com/embed/EgrcW8B15vs?si=bcJcquv1FrhqIZWX" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>    

## **Ex-1 Build a database using FASTA files downloaded from the NCBI (swissprot).**   
1) Select the build database icon    
![build_DB_1_A](https://github.com/kn0w0n3/BLAST-NG/assets/22214754/d40a2fa9-334c-4b6d-8c7f-18f19bb17982)

2) Select the database files directory, type of database, name of databse, storage location of database    
![build_DB_2_A](https://github.com/kn0w0n3/BLAST-NG/assets/22214754/b0608642-f002-4891-b052-ff04a4c92da8)

3) A database build completion message will appear in the output window  
![build_DB_3_A](https://github.com/kn0w0n3/BLAST-NG/assets/22214754/573224e0-872d-4e0c-979d-8ae6ba7cba51)   

5) The database destination folder should contain files similar to what is shown in the image below
![build_DB_4_A](https://github.com/kn0w0n3/BLAST-NG/assets/22214754/c3a2be1c-1d86-4ebf-ae24-32a54377b0b5)

   The swissprot database files used in this example were downloaded from the NCBI:  https://ftp.ncbi.nlm.nih.gov/blast/db/FASTA/

# **Resources:**  
![ncbi-logo](https://user-images.githubusercontent.com/22214754/204448800-2b846e5b-2c68-4c4e-8687-43aac8ac752e.png)      
https://www.ncbi.nlm.nih.gov/  
https://ftp.ncbi.nlm.nih.gov/blast/db/  
https://www.ncbi.nlm.nih.gov/home/develop/  
https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastDocs&DOC_TYPE=Download  
https://www.ncbi.nlm.nih.gov/books/NBK569839/  
https://blast.ncbi.nlm.nih.gov/Blast.cgi  

NCBI BLAST Executables: https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/  
   
# **Work Environment:**       
![QtLogo](https://user-images.githubusercontent.com/22214754/179895211-d52559ab-35df-4fcc-bf69-7377739330d4.png)    
Qt Creator 11.0.2  
Based on Qt 6.4.3 (MSVC 2019, x86_64)  
Built on Aug 12 2023 01:19:23  
From revision 7bb49b58df  
Kit 6.5.1 MinGW 64-bit      
https://www.qt.io/  

# **Notes:**  
A BLAST search against a database requires at least a –query and –db option. The command:  

blastn –db nt –query nt.fsa –out results.out  
