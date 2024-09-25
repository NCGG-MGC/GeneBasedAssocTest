#!/usr/bin/env ruby
# -*- coding: utf-8 -*-


# ------------------------------------
# extract gene names and gene IDs
# ------------------------------------
def gName_to_gID(seq_genef)
  gName_to_gID = Hash.new 
  File.open(seq_genef) do |lines|
    lines.each do |line|
      next if /^#/ =~ line
      list  = line.chomp.split("\t")
      gID   = list[10].split(":").last
      gName = list[11]
      gName_to_gID[gName] = gID
    end
  end
  return gName_to_gID
end




def mod_outf(tmpf, outf)
  f = open(outf, "w")
  File.open(tmpf) do |lines|
    lines.each.with_index do |line, index|
      setID, setSize, offset, pval = line.chomp.split("\t")
      pval = "Pvalue" if index == 0
      f.puts "#{setID}\t#{setSize}\t#{offset}\t#{pval}"
    end
  end
  system("rm -rf #{tmpf}")
  f.close
end





if __FILE__ == $0
  require "optparse"
  require "fileutils"
  require "tempfile"

  opt  = OptionParser.new
  opts = Hash.new
  required = [:outd, :iptd]
  opt.on('--iptd ipt_dir'){|v| opts[:iptd] = v} 
  opt.on('--outd out_dir'){|v| opts[:outd] = v}    
  opt.parse!(ARGV)

  required.each do |opt|
    if opts[opt].nil?
      puts "Usage: ruby 02.skat_fdr.rb --iptd ../res/01.bbf --outd ../res/02.skat_fdr"
      exit
    end
  end
  iptd = opts[:iptd] 
  outd = opts[:outd]
  FileUtils.mkdir_p(outd) if not File.exist?(outd)

  # -----------------------------
  #
  # extract gene IDs and gene names
  #
  # -----------------------------
  seq_genef = "../data/seq_gene.md" 
  gName_to_gID = gName_to_gID(seq_genef)

  # ------------------------------------
  #
  # 1. cat + sort by p-values 
  #
  # ------------------------------------
  #
  tmp_SKATf  = "#{outd}/tmp.sort.SKAT.txt"
  tmp_SKATOf = "#{outd}/tmp.sort.SKAT_O.txt"
  tmp_Burdf  = "#{outd}/tmp.sort.Burden.txt"
  system("cat #{iptd}/*skat|sort -k5,5g|uniq|cut -f2-5   >#{tmp_SKATf}")
  system("cat #{iptd}/*skat|sort -k6,6g|uniq|cut -f2-4,6 >#{tmp_SKATOf}")
  system("cat #{iptd}/*skat|sort -k7,7g|uniq|cut -f2-4,7 >#{tmp_Burdf}")

  sort_SKATf  = "#{outd}/01.sort.SKAT.txt"
  sort_SKATOf = "#{outd}/01.sort.SKAT_O.txt"
  sort_Burdf  = "#{outd}/01.sort.Burden.txt"

  mod_outf(tmp_SKATf,  sort_SKATf)
  mod_outf(tmp_SKATOf, sort_SKATOf)
  mod_outf(tmp_Burdf,  sort_Burdf)
  puts
  # -----------------------------------------------------------
  #
  # 2. add gene IDs and exclude genes with SetSize(SNP)=1
  #
  # -----------------------------------------------------------
  #
  sortrmfs = Array.new
  [sort_SKATf, sort_SKATOf, sort_Burdf].each.with_index do |sortf, index|
    name = "SKAT"   if index == 0
    name = "SKAT_O" if index == 1
    name = "Burden" if index == 2
    sortrmf = "#{outd}/02.sort.#{name}.rm_sigleton.txt"
    f = open(sortrmf, "w")
    File.open(sortf) do |lines|
      lines.each.with_index do |line, index|
        line.chomp!
        if index == 0
          f.puts "#{line}\tgID"
        else
          gName, setsize, offset, pval = line.split("\t")
          next if setsize == "1" # exclude SNP-based AS
          gID = gName_to_gID[gName]
          next if gID.nil? 
          f.puts "#{line}\t#{gID}"
        end
      end
    end
    f.close
    sortrmfs << sortrmf
  end
  puts
  # ------------------------------------------------
  #
  # 3. calculate FDR (BH and Bonferroni) using R
  #
  # ------------------------------------------------
  #
  puts ">Final output files:"
  pval = "Pvalue"
  sortrmfs.each.with_index do |sortf, index|
    tmp = Tempfile.new("mytmp")
    tmp.puts "data = read.table(\"#{sortf}\", sep= \"\\t\", header=TRUE)"
    name = "SKAT"   if index == 0
    name = "SKAT_O" if index == 1
    name = "Burden" if index == 2

    tmp.puts "fdr.BH   = p.adjust(data$#{pval}, \"BH\")"
    tmp.puts "fdr.Bonf = p.adjust(data$#{pval}, \"bonferroni\")"
    tmp.puts "data$FDR_BH     = fdr.BH"
    tmp.puts "data$Bonferroni = fdr.Bonf"

    outf = "#{outd}/03.sort.#{name}.adjustedP.txt"
    tmp.puts "write.table(data, \"#{outf}\", sep=\"\\t\",quote=F,row.names=F)"
    tmp.close
    puts "#{index+1}. #{outf}"
    system("Rscript #{tmp.path}")
    tmp.close(true)
  end
end
