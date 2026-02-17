options(width=54)
library(DECIPHER)

# load sequences into a database
fas <- system.file("extdata",
	"Streptomyces_ITS_aligned.fas",
	package="DECIPHER")
dbConn <- dbConnect(SQLite(),
	":memory:")
Seqs2DB(fas,
	type="FASTA",
	dbFile=dbConn,
	"")

# identify the sequences by their species
x <- dbGetQuery(dbConn,
	"select description from DNA")$description
x <- unlist(lapply(strsplit(x,
		"Streptomyces "),
	`[`,
	2L))
x <- unlist(lapply(strsplit(x,
		" "),
	function(x) {
		if (x[1]=="sp.")
			return(x[2])
		x[1]
	}))
x <- ifelse(x=="sp_AA4",
	"S. AA4",
	paste("S.",
		x))
Add2DB(myData=data.frame(id=x),
	dbConn)

# form a consensus for each species
cons <- IdConsensus(dbConn,
	threshold=0.3,
	minInformation=0.1)

# calculate a maximum likelihood tree
d <- DistanceMatrix(cons,
	correction="Jukes-Cantor")
dend <- IdClusters(d,
	method="ML",
	asDendrogram=TRUE,
	myXStringSet=cons)
dend <- dendrapply(dend,
	FUN=function(n) {
		if(is.leaf(n)) 
			attr(n, "label") <- as.expression(substitute(italic(leaf),
				list(leaf=attr(n, "label"))))
	n
	})

# display the phylogenetic tree
p <- par(mar=c(1, 1, 1, 8),
	xpd=TRUE)
plot(dend,
	yaxt="n",
	horiz=TRUE)
arrows(-0.1, 6, -0.2, 6,
	angle=90,
	length=0.05,
	code=3)
text(-0.15, 6,
	"0.1",
	adj=c(0.5, -0.5))
par(p)

dbDisconnect(dbConn)

