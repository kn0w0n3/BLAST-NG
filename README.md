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

Bio Database Manager Windows Installer Download: https://github.com/kn0w0n3/Bio-Database-Manager/releases  
![bio_database_manager_gui_8-19-23](https://github.com/kn0w0n3/Bio-Database-Manager/assets/22214754/77b58dd3-8006-4564-bb65-aa5263c71ed3)          

# **Examples:**  

YouTube Tutorials: https://youtu.be/qsfZ0KjK7kI?si=B118q-QLYmKFzle0  

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
     
# **Notes:**  
A BLAST search against a database requires at least a –query and –db option. Ex:    

blastn –db nt –query nt.fsa –out results.out  

## Megablast indexed searches
Indexing provides an alternative way to search for initial matches in nucleotide-nucleotide searches (blastn and megablast) by pre-indexing the N-mer locations in a special data structure, called a database index.  

Using an index can improve search times significantly under certain conditions. It is most beneficial when the queries are much shorter than the database and works best for queries under 1 Mbases long. The advantage comes from the fact that the whole database does not have to be scanned during the search.  

Indices can capture masking information, thereby enabling search against databases masked for repeats, low complexity, etc.  

There are, however, limitations to using indexed search in blast:  

* Index files are about four times larger than the blast databases. If an index does not fit into computer operating memory, then the advantage of using it is eliminated.  
* Word size must be set to 16 or more in order to use an indexed search.  
* Discontiguous search is not supported.  
Reference: Morgulis A, Coulouris G, Raytselis Y, Madden TL, Agarwala R, Schäffer AA. Database Indexing for Production MegaBLAST Searches. Bioinformatics 2008, 24(16):1757-64. PMID:18567917

# **Work Environment:**  
Last Update: 11-23-23  
![Qt_Creator_Version](https://github.com/kn0w0n3/BLAST-NG/assets/22214754/56f995e3-a7c6-4a01-9933-8c2e7279a3b3)  
