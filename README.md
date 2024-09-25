Conduct gene-based rare variant association testing by using Burden, SKAT, and SKAT-O methods. 

## Reference

Tetsuaki Kimura, Kosuke Fujita, Takashi Sakurai, Shumpei Niida, Kouichi Ozaki, and Daichi Shigemizu. Whole-genome sequencing to identify rare variants in East Asian patients with dementia with Lewy bodies, npj Aging volume XX, Article number: XX (2024)
    
## Depend Tools

* [ruby (2.3 or higher)](https://www.ruby-lang.org/en/)
* [PLINK](https://www.cog-genomics.org/plink/)
* [R (3.4.3 or higher)](https://www.r-project.org/)
* [CRAN: Package SKAT](https://cran.r-project.org/web/packages/SKAT/index.html)

## Usage
$ sh src/run.sh <1.input file: basename of PLINK formatted files> <2.output directory>
```console
$ sh src/run.sh data/bbf_setid/tmp out/
```

## Output
Final output files = out/03.sort.<Burden,SKAT,SKAT-O>.adjustedP.txt

#|column|description
-----|------|-----------
1|SetID|Gene symbol
2|SetSize|The number of SNPs
3|Offset|Offset
4|Pvalue|Raw P-value
5|gID|Gene ID
6|FDR_BH|FDR (Benjamini-Hochberg)
7|Bonferroni|Bonferroni correction
