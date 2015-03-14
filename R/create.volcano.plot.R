require(scales);
require(plyr);
require(futile.logger);
require(lattice);
create.volcano.plot <- function(x, y, filename=NULL, point.labels = rep('', length(x)), point.size.range = c(0.25,2.5), label.cex = 0.5, groups = NULL, scheme = c('red', 'blue'), pr.threshold=0.96, xybias = 1, add.jitter=TRUE, jitter.factor=5, draw.signif.line = TRUE, xlabel = expression(Effect), ylabel = expression(paste("-log"[10], "P"[adj]))) {
# X = EFFECT
# Y = PVALUE

# sort by y then x?

# some checks-
	if(min(y < 0) | max(y > 1)) stop('y does not look like a p or a q value');
	if(length(unique(length(x), length(y), length(point.labels))) != 1) stop('supplied values must be same length');

    # determine where to draw significance line
    q.vals <- p.adjust(y, method='fdr');

	# adjust y
	y <- -log10(y);
	flog.debug('x:', head(x), capture=TRUE);
	flog.debug('y:', head(y), capture=TRUE);

	plotting.cex <- rescale(Mod(x), to = point.size.range);

    # determine which genes get point.labels.plot
    bias = exp(xybias);
	euc.dist <- sqrt((rescale(x,to=c(-0.5,0.5))*(1/bias))^2 + (rescale(y)*(bias/1))^2);
	flog.debug("EUC dist: %s", summary(euc.dist), capture=T);
	threshold <- quantile(euc.dist, pr.threshold, na.rm=T);
	flog.debug("Threshold: %s", threshold)
	point.labels.plot <- ifelse(
			euc.dist > threshold,
			as.character(point.labels),
			''
			);
	flog.debug("labels %s", paste(point.labels.plot, collapse=", "))

    # determine where to draw significance line
    if(all(q.vals > 0.05)) { draw.signif.line <- FALSE; }
    else { threshold.p.value <- mean(c(min(y[which(q.vals<0.05)]), max(y[which(q.vals>=0.05)]))) }

	x.limit <- round_any(1.1*max(abs(x), na.rm = TRUE), 0.2, ceiling);
	y.limit <- round_any(1.1*max(y, na.rm = TRUE), 0.2, ceiling);
	flog.debug('x/y axis limits: %s / %s', x.limit, y.limit)
	flog.debug('x/y max: %s / %s', max(abs(x), na.rm=TRUE), max(y, na.rm=TRUE))

	if(!is.null(groups)) {
		rescaled.y <- rescale(y);
		plotting.colours <- sapply( 1:length(x), function(i) { alpha(scheme[as.numeric(groups[i])],rescaled.y[i])})
		this.key <- list(
			text = list(
			lab = levels(groups),
			cex = 0.8,
			#fontface = 'bold',
			col = 'black'
			),
		points = list(
		pch = 20,
		col = scheme,
		cex = 2
		),
		x = 0.02,
		y = 0.99,
		padding.text = 1,
		alpha.background = 1
		);
	} else { plotting.colours <- alpha(scheme[1], rescale(y)); this.key <- NULL };

# take log of y before jittering.
	if(add.jitter) { x <- jitter(x, jitter.factor); y <-jitter(y, jitter.factor);}

	volcano <- xyplot(
		y ~ x,
		data = data.frame(x,y),
		pch = 20,
		xlab = list(
			xlabel,
			cex = 2
			),
		ylab = list( 
			ylabel,
			cex = 2
			),
		key= this.key,
		col = plotting.colours,
		cex = plotting.cex,
		xlim = c( -x.limit, x.limit),
		ylim = c(0, y.limit),
		panel = function(x, y, ...) {
		panel.xyplot(x, y, ...);
		ltext(x=x, y=y, labels = point.labels.plot, pos=sample(1:4, length(x), TRUE), offset=runif(length(x)), cex=label.cex);
		if(draw.signif.line) panel.abline(h = threshold.p.value, lty = 2 );
		}
	)
	if(is.null(filename)) return(volcano);
	png(filename, width=15, height = 15, unit = 'cm', res=1000);
	plot(volcano);
	dev.off();
	return(TRUE);
	}
