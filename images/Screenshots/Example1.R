options(width=54)
library(DECIPHER)

# load sequences into a database
fas <- system.file("extdata",
	"50S_ribosomal_protein_L2.fas",
	package="DECIPHER")
dbConn <- dbConnect(SQLite(),
	":memory:")
Seqs2DB(fas,
	type="FASTA",
	dbFile=dbConn,
	identifier="")

# identify the sequences based on genus
x <- dbGetQuery(dbConn,
	"select description from DNA")$description
ns <- unlist(lapply(strsplit(x,
		split=" "),
	FUN=`[`,
	1L))
Add2DB(myData=data.frame(id=ns),
	dbFile=dbConn)

# align the translated sequences
dna <- SearchDB(dbConn,
	nameBy="id")
AA <- AlignTranslation(dna,
	asAAStringSet=TRUE)
Seqs2DB(AA,
	type="AAStringSet",
	dbFile=dbConn,
	identifier="",
	tblName="Aligned")
Add2DB(myData=data.frame(id=ns),
	dbFile=dbConn,
	tblName="Aligned")

# form a consensus sequence for each genus
cons <- IdConsensus(dbConn,
	tblName="Aligned",
	type="AAStringSet",
	add2tbl="Consensus",
	threshold=0.5,
	minInformation=0.5)
aa <- SearchDB(dbConn,
	"Consensus",
	type="AAStringSet",
	nameBy="description",
	limit="40,20",
	removeGaps="common")

# view the sequences in a browser
BrowseSeqs(aa,
	threshold=0.5,
	minInformation=0.5,
	colWidth=60)
dbDisconnect(dbConn)
