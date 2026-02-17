options(width=54)
library(DECIPHER)

# read in sequences from a FASTA file
fas <- system.file("extdata",
	"IDH2.fas",
	package="DECIPHER")
dna <- readDNAStringSet(fas)

# simulate melting the DNA sequences
temps <- seq(80, 95, 0.1)
melts <- MeltDNA(subseq(dna,
		start=492,
		end=542),
	type="derivative",
	temps=temps)

# plot the melt curves' derivatives
matplot(x=temps,
	y=melts,
	type="l",
	xlab="Temperature (\u00B0C)",
	ylab="-d(\u03F4)/dTemp")
legend("topright",
	c("IDH2 common allele",
		"R172K SNP allele",
		"R172G SNP allele",
		"R172M SNP allele"),
	col=1:4,
	lty=1:4,
	cex=0.8)
