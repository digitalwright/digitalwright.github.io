options(width=54)
library(DECIPHER)

# import a GenBank sequence file
gen <- system.file("extdata",
	"Bacteria_175seqs.gen",
	package="DECIPHER")
dbConn <- dbConnect(SQLite(),
	":memory:")
Seqs2DB(gen,
	"GenBank",
	dbConn,
	"")

# add rank information to the database
ids <- IdentifyByRank(dbConn,
	level=10,
	add2tbl=TRUE)

# add length information to the database
lns <- IdLengths(dbConn,
	add2tbl=TRUE)

# view the database table in a browser
BrowseDB(dbConn,
	maxChars=25)

dbDisconnect(dbConn)

