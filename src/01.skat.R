args <- commandArgs(trailingOnly = TRUE)[1]
basename <- args[1]
set.seed(1010)

if (is.na(basename)){
    print("Usage: Rscript 01.skat.R data/bbf_setid/tmp<.bed/.bim/.fam/.setid>")
    q()
}


library("SKAT")
bedf   <- paste0(basename, ".bed")
bimf   <- paste0(basename, ".bim")
famf   <- paste0(basename, ".fam")
setidf <- paste0(basename, ".setid")
ssdf   <- paste0(basename, ".ssd")
infof  <- paste0(basename, ".ssd.info")

Generate_SSD_SetID(bedf, bimf, famf, setidf, ssdf, infof)
ssd <- Open_SSD(ssdf, infof)

fam <- Read_Plink_FAM(famf)
phenotype <- fam$Phenotype
setinfo   <- ssd$SetInfo

len <- length(setinfo$SetIndex)
setinfo$p.value   <- numeric(len)
setinfo$p.value.o <- numeric(len)
setinfo$p.value.corr <- numeric(len)

for (i in 1:len) {
  setid <- setinfo$SetID[i]
  setindex  <- setinfo$SetIndex[i]
  geno <- Get_Genotypes_SSD(ssd, setindex)
  model <- SKAT_Null_Model(phenotype ~ 1, out_type="D")
  setinfo$p.value[i]    <- SKAT(geno, model)$p.value                       # SKAT
  setinfo$p.value.o[i]  <- SKAT(geno, model, method="optimal.adj")$p.value # SKAT-O
  setinfo$p.value.corr[i] <- SKAT(geno, model, r.corr=1)$p.value           # Burden
}
write.table(setinfo, file=paste0(basename, ".skat"), sep="\t", quote=FALSE, row.names=FALSE)
