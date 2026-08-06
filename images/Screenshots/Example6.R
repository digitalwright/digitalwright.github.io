options(width=54)
library(DECIPHER)

genomes <- c(`Y. pestis antiqua`="Yersinia_pestis_Antiqua_uid58607/NC_008150",
   `Y. pestis CO92`="Yersinia_pestis_CO92_uid57621/NC_003143",
   `Y. pestis KIM10`="Yersinia_pestis_KIM_10_uid57875/NC_004088",
   `Y. pestis Microtus`="Yersinia_pestis_biovar_Microtus_91001_uid58037/NC_005810",
   `Y. pestis Nepal`="Yersinia_pestis_Nepal516_uid58609/NC_008149",
   `Y. enterocolitica palearctica`="Yersinia_enterocolitica_palearctica_105_5R_r__uid63663/NC_015224",
   `Y. pestis Pestoides`="Yersinia_pestis_Pestoides_F_uid58619/NC_009381",
   `Y. pseudotuberculosis IP31758`="Yersinia_pseudotuberculosis_IP_31758_uid58487/NC_009708")

dbConn <- dbConnect(SQLite(), ":memory:")
path <- "ftp://ftp.ncbi.nlm.nih.gov/genomes/archive/old_refseq/Bacteria/"
for (i in seq_along(genomes)) {
   Seqs2DB(paste(path,
         genomes[i],
         ".fna",
         sep=""),
      "FASTA",
      dbConn,
      names(genomes)[i],
      verbose=FALSE)
}

# find syntenic blocks
synteny <- FindSynteny(dbConn)

# display a dot plot
labels <- sapply(lapply(strsplit(rownames(synteny), " "),
		abbreviate,
		minlength = 9),
	paste,
	collapse="\n")
pairs(synteny, labels=labels)

# display a bar plot
plot(synteny)

# align syntenic blocks
DNA <- AlignSynteny(synteny, dbConn)

dbDisconnect(dbConn)
