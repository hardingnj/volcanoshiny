shinyUI(pageWithSidebar(
  headerPanel("Interactive Volcano Plot Viewer"),
  sidebarPanel(
    h2("About"),
    p("This tool draws a volcano plot- typically used for showing relationships between fold change and p-values of genes in microarray studies.",
      "Points are sized according to their X-value, and coloured by their Y-value"), 
    p("Which genes to label are chosen based on Euclidean distance, but can be biased towars the X or Y dimension. All other settings should be self explanatory.",
      "Editing any settings will cause the plot to be redrawn, label positions are random NESW, so redraw to avoid overlapiping labels."),
    fileInput('file1', 'Choose File',
              accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
    p("File columns must be in order: Gene, X-axis (usually fold change), Y-axis (p-value), Group (optional)"),
    checkboxInput('header', 'Header', FALSE),
    radioButtons('sep', 'Separator', c( Tab='\t', Comma=','), 'Tab'),
    radioButtons('quote', 'Quote', c(None='', 'Double Quote'='"', 'Single Quote'="'"), 'Double Quote'),
    tags$hr(),
    sliderInput("labelcex", "Label size", min=0, max=3, value=1.0, step = 0.05),
    sliderInput("xybias", "X/Y bias", min=-2, max=2, value=0, step = 0.1),
    sliderInput("threshold", "Label print strictness", min=0.0, max=1.00, value=0.8, step = 0.01),
    sliderInput("range", "Point Size Range:", min = 0, max = 7, step = 0.05, value = c(2.00,4.00)),
    checkboxInput('groups', 'Add grouping variable', TRUE),
    textInput('colour', "Colour Scheme", 'red;green'),
    textInput('xlabel', "Label for X-axis", 'Fold Change'),
    textInput('ylabel', "Label for Y-axis", '-Log[10]'),
    checkboxInput('jitter', 'Jitter', FALSE),
    checkboxInput('signif', 'Show Q-value cut off', TRUE),
    sliderInput("jitter.factor", "Jitter Factor", min=0, max=5,value=1, step = 0.5)
  ),
  # label slider
  # colour
  # x bias
  # y bias
  mainPanel(
    tabsetPanel(
      tabPanel("Volcano Plot", plotOutput(outputId = 'volcano', width = "800px", height = "800px")),
      tabPanel("Histogram", plotOutput(outputId = 'histogram', width = "100%")),
      tabPanel("Data Preview", tableOutput("contents"))
    )
  )
))
