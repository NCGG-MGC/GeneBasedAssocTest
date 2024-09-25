Performe gene-based rare variant association testing (Burden, SKAT, and SKAT-O). 

## Reference

Tetsuaki Kimura, Kosuke Fujita, Takashi Sakurai, Shumpei Niida, Kouichi Ozaki, and Daichi Shigemizu. Whole-genome sequencing to identify rare variants in East Asian patients with dementia with Lewy bodies, npj Aging volume XX, Article number: XX (2024)
    
## depend tools

* [ruby (2.3 or higher)](https://www.ruby-lang.org/en/)
* [PLINK](https://www.cog-genomics.org/plink/)
* [R (3.4.3 or higher)](https://www.r-project.org/)
* [CRAN: Package SKAT](https://cran.r-project.org/web/packages/SKAT/index.html)

## usage

```console
$ sh src/run.sh ../res/01.bbf/ tmp ../res/02.skat_fdr
```

## output:03.sort.<Burden,SKAT,SKAT-O>.rm_singleton.FDR.txt

#|column|description
-----|------|-----------
1|SetID|Gene Name
2|SetSize|The number of SNPs
3|Offset|Offset
4|p.value|raw P-value
5|gID|Gene ID
6|BH|FDR (Benjamini-Hochberg)
7|Bonf|Bonferroni correction
