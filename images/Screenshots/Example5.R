options(width=54)
library(DECIPHER)

probes <- DNAStringSet(c("AAGGTCGGCCGCTACAAGGT",
	"GATGTCGTCGGTCTCGAC"))
targets <- reverseComplement(probes)

FAs <- 0:70 # % formamide
eff <- matrix(NA,
	nrow=length(FAs),
	ncol=length(probes))

for (i in seq_along(FAs))
	eff[i,] <- CalculateEfficiencyFISH(probes,
		targets,
		46, # temp
		250e-9, # [Po]
		1, # [Na+]
		FAs[i])[, "HybEff"]

matplot(FAs,
	eff,
	type="l",
	ylab="Hybridization Efficiency",
	xlab="Formamide Concentration (% v/v)",
	col=3:4)
legend("topright",
	paste("Probe",
		1:2),
	lty=1:2,
	col=3:4)
