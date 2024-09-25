# ------------------------------------------------------------------------------------------
# Usage: sh src/run.sh <1.input file: basenaeme of PLINK formatted files> <2.output directory>
# e.g. sh src/run.sh data/bbf_setid/tmp out
# ------------------------------------------------------------------------------------------
# 
# + prepare the following 4 input files and set them in the same directory: e.g. ../data/bbf_setid/
# 1. tmp.bed (PLINK formatted file)
# 2. tmp.bim (PLINK formatted file)
# 3. tmp.fam (PLINK formatted file) 
# 4. tmp.setid (define SNP set: The first colomn is Set ID and the second column is SNP ID)
#
# + prepare Ruby and R progmammings and the R package "SKAT"
#
dir=`dirname $1`
Rscript src/01.skat.R $1 $2
ruby src/02.skat_fdr.rb --iptd $dir --outd $2
