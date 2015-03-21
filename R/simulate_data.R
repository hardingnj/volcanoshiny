simulate_data <- function(n){
	# function that simulates n genes of varying p/fc values
	fold_changes = rnorm(n)
	sd = runif(n, .8, 10)
	q_values = -pnorm(0, abs(fold_changes), sd, log.p=T)
	p_values = 10^(-q_values)
	# pvalues cannot be exactly 0
	gene_strings = sapply(1:n, function(x){ paste0(paste(sample(toupper(letters), 5), collapse=""), sample(1:100, 1)) })
	dat <- data.frame(GENE=gene_strings, M=fold_changes, P=p_values, GROUP=ifelse(runif(n) > 0.5, "24h_vs_control", "12h_vs_control"))

	return(dat)
}
