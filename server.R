source("R/create.volcano.plot.R");
source("R/modifyList2.R");
shinyServer(function(input, output) {

  input.data <- reactive({

    inFile <- input$file1
    if (is.null(inFile)) return(NULL)

    dataframe <- read.csv(
		inFile$datapath,
		header=input$header,
		sep=input$sep,
		quote=input$quote
		)
  })
  usegroups <- reactive({ input$groups })
  volcano.args <- reactive({

    colour.scheme <- unlist(strsplit(input$colour, ';'))
    colour.scheme <- gsub("^\\s+|\\s+$", "", colour.scheme)
    use.colour <- ifelse(colour.scheme %in% colours(), colour.scheme, 'black');

    list(
      xybias = input$xybias, 
      label.cex = input$labelcex,
      pr.threshold = rescale(input$threshold, to=c(0.93,1), from = c(0,1)),
      point.size.range = input$range,
      xlabel = input$xlabel,
      ylabel = parse(text=strsplit(input$ylabel, ',')),
      scheme = use.colour,
      draw.signif.line = input$signif,
      add.jitter = input$jitter,
      jitter.factor = input$jitter.factor
    )
  })

  output$contents <- renderTable({
    # input$file1 will be NULL initially. After the user selects and uploads a 
    # file, it will be a data frame with 'name', 'size', 'type', and 'datapath' 
    # columns. The 'datapath' column will contain the local filenames where the 
    # data can be found.
    dat <- input.data();
    if(is.null(dat)) return(NULL);
    head(dat);
  })

  output$histogram <- renderPlot({
    dat <- input.data();
    if(is.null(dat)) return(NULL);
    hist(x=dat[,3],main="Histogram of unadjusted p-values", xlab = "p-value");
	})

  output$volcano <- renderPlot({
    dat <- input.data();

    volcano.defaults <- formals(create.volcano.plot);
    volcano.args.in  <- modifyList2(volcano.defaults, volcano.args())
    formals(create.volcano.plot) <- volcano.args.in;
    if(is.null(dat)) return(NULL);
    plot( with(
		input.data(),
		create.volcano.plot(
			x = dat[,2],
			y = dat[,3],
			groups = if(usegroups()) dat[,4] else NULL,
			filename = NULL,
			point.labels = dat[,1],
			)
		));
	}, width=800, height=800)
})
