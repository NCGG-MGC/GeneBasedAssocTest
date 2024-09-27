Conduct gene-based rare variant association testing by using Burden, SKAT, and SKAT-O methods. 
    
## Depend Tools
* [ruby (2.3 or higher)](https://www.ruby-lang.org/en/)
* [PLINK](https://www.cog-genomics.org/plink/)
* [R (3.4.3 or higher)](https://www.r-project.org/)
* [CRAN: Package SKAT](https://cran.r-project.org/web/packages/SKAT/index.html)

## Required Input Files
1. tmp.bed (PLINK formatted file)
2. tmp.bim (PLINK formatted file)
3. tmp.fam (PLINK formatted file)
4. tmp.setid (define SNPs sets: The first and second columns are set to gene name and SNP ID, respectively)

## Usage
$ sh src/run.sh <1.input file: basename of PLINK formatted files and the setid file> <2.output directory> <br>
```console
$ tar -zxvf data.tar.gz
$ sh src/run.sh data/bbf_setid/tmp out/
```

## Output Files
**1. out/01.sort.<Burden,SKAT,SKAT-O>.txt**
#|column|description
-----|------|-----------
1|SetID|gene symbol
2|SetSize|the number of SNPs
3|Offset|offset
4|Pvalue|raw P-value

**2. out/02.sort.<Burden,SKAT,SKAT-O>.rm_singleton.txt**: Exclude sigletons (genes with SetSize 1) from output file1. <br>
#|column|description
-----|------|-----------
1|SetID|gene symbol
2|SetSize|the number of SNPs
3|Offset|offset
4|Pvalue|raw P-value
5|gID|gene ID

**3. out/03.sort.<Burden,SKAT,SKAT-O>.adjustedP.txt**: Final output file with adjusted P values to output file 2. <br>
#|column|description
-----|------|-----------
1|SetID|gene symbol
2|SetSize|the number of SNPs
3|Offset|offset
4|Pvalue|raw P-value
5|gID|gene ID
6|FDR_BH|Benjamini-Hochberg FDR
7|Bonferroni|Bonferroni corrected P value

## Reference
Tetsuaki Kimura, Kosuke Fujita, Takashi Sakurai, Shumpei Niida, Kouichi Ozaki, and Daichi Shigemizu. **Whole-genome sequencing to identify rare variants in East Asian patients with dementia with Lewy bodies**. _npj Aging_. Vol. XX, Article number: XX (2024)
