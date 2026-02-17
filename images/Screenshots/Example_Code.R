library(DECIPHER)

dna <- readDNAStringSet("seqs.fasta")

subMatrix <- matrix(c(12, 3, 5, 3,
		3, 12, 3, 6,
		5, 3, 11, 3,
		3, 6, 3, 9),
	nrow=4, ncol=4,
	dimnames=list(DNA_BASES, DNA_BASES))

DNA <- AlignSeqs(dna,
	substitutionMatrix=subMatrix)

# view aligned sequences in a browser
BrowseSeqs(DNA,
	highlight=0)

writeXStringSet(DNA,
	"aligned_seqs.fasta")
