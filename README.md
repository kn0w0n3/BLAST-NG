# BLAST-NG    
Bioinformatics tool for searching sequence similarities:  

Status: In Progress  

The Basic Local Alignment Search Tool (BLAST) finds regions of local similarity between sequences. The program compares nucleotide or protein sequences to sequence databases and calculates the statistical significance of matches.    

![blast-ng-gui-8-14-23](https://github.com/kn0w0n3/BLAST-NG/assets/22214754/7aed3bfe-cd63-46c5-8c8c-a24a4d36e6a6)  

# **Usage:**    

* **BLASTp:** Compare a protein query to a protein (nr) database.     

* **BLASTn:** Translates the DNA sequence in all possible reading frames and compares it with the non redundant NCBI (nt) protein database.     

* **BLASTx:** A translated nucleotide sequence searched against protein sequences: compares a nucleotide query sequence that is translated in six reading frames (resulting in six protein sequences) against a database of protein sequences.
  
* **tBLASTn:** Operates by translating database nucleotide sequences to hypothetical amino acid sequences in all six reading frames and then aligning the hypothetical amino acid sequences to the query. TBLASTN is widely used as associating proteins with chromosomes or with mRNAs is useful in many biological studies.

* **tBLASTx:** Accepts nucleotide query sequence(s) as well as database subject sequences, translates both to 6‐frame amino acid sequences and, finally, compares them at the amino acid level. tBLASTx is a tool for discovering novel genes in the nucleotide sequences, such as single pass expressed sequence tags and draft genome records which are unannotated and riddled with errors (e.g., wrong bases and frame shifts). These errors often make one coding sequence difficult to be detected.  

Databases are required to perform BLAST queries. Databases can be downloaded from the following link:  

https://ftp.ncbi.nlm.nih.gov/blast/db/FASTA/  

Some database files have a size greater than 300GB and could take some time to download.    
![db](https://github.com/kn0w0n3/BLAST-NG/assets/22214754/8ff73180-e8f6-4f8a-9a43-ba32554f5eae)    

# **Example:**  
## **Build a Database**   
### **1) Select the build database icon**  
![build_DB_1_A](https://github.com/kn0w0n3/BLAST-NG/assets/22214754/d40a2fa9-334c-4b6d-8c7f-18f19bb17982)

### **2) Select database files to build, type of database, name of databse, storage location of database**  
![build_DB_2_A](https://github.com/kn0w0n3/BLAST-NG/assets/22214754/6ce3a502-a0e5-4b58-88d8-cb62065965d7)  

# **Resources:**  
![ncbi-logo](https://user-images.githubusercontent.com/22214754/204448800-2b846e5b-2c68-4c4e-8687-43aac8ac752e.png)      
https://www.ncbi.nlm.nih.gov/  
https://ftp.ncbi.nlm.nih.gov/blast/db/  
https://www.ncbi.nlm.nih.gov/home/develop/  
https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastDocs&DOC_TYPE=Download  
https://www.ncbi.nlm.nih.gov/books/NBK569839/  
https://blast.ncbi.nlm.nih.gov/Blast.cgi  

NCBI BLAST Executables: https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/  

# **Notes:**  
A BLAST search against a database requires at least a –query and –db option. The command:  

blastn –db nt –query nt.fsa –out results.out  

# **Work Environment:**       
![QtLogo](https://user-images.githubusercontent.com/22214754/179895211-d52559ab-35df-4fcc-bf69-7377739330d4.png)    
Qt Creator 11.0.2  
Based on Qt 6.4.3 (MSVC 2019, x86_64)  
Built on Aug 12 2023 01:19:23  
From revision 7bb49b58df  
Kit 6.5.1 MinGW 64-bit      
https://www.qt.io/        
