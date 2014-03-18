shinyUI(pageWithSidebar(
  headerPanel("Interactive Volcano Plot Viewer"),
  sidebarPanel(
    fileInput('file1', 'Choose File',
              accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
    tags$hr(),
    checkboxInput('header', 'Header', FALSE),
    radioButtons('sep', 'Separator', c( Tab='\t', Comma=','), 'Tab'),
    radioButtons('quote', 'Quote', c(None='', 'Double Quote'='"', 'Single Quote'="'"), 'Double Quote'),
    tags$hr(),
    sliderInput("labelcex", "Label size", min=0, max=3, value=0, step = 0.05),
    sliderInput("xybias", "X/Y bias", min=-2, max=2, value=0, step = 0.01),
    sliderInput("threshold", "Label print strictness", min=0.0, max=1.00, value=0.5, step = 0.01),
    sliderInput("range", "Point Size Range:", min = 0, max = 7, step = 0.05, value = c(0.25,2.5)),
    checkboxInput('groups', 'Add grouping variable', FALSE),
    textInput('colour', "Colour Scheme", 'red;blue'),
    textInput('xlabel', "Label for X-axis", 'Fold Change'),
    textInput('ylabel', "Label for Y-axis", '-Log[10]'),
    checkboxInput('jitter', 'Jitter', TRUE),
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
