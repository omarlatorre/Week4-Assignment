#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

# Read Data
library(datasets)
data(mtcars)
#mtcars[,1]
#head(mtcars)

# Define UI for application that draws a plot
ui <- fluidPage(
  
  # Application title
  # head("Plotting the mtcars data set"), 
  titlePanel(title = h3("Plotting the mtcars data set", align="center")),
  br(),  
  p("In this app, we will display the mtcars data set and explore the relationship between a set of variables and miles per gallon (MPG)."),
  sidebarLayout(
    sidebarPanel(
      p("Establish a competitive range"),
      #------------------------------------------------------------------
      # Add Variable for mpg Selection
      sliderInput("MPGRange", "Select MPG Range : ", min=10.4, max=33.9, value=c(10.4, 33.9), step=0.5
                  
      ),
      
      br(),   br(),
      #------------------------------------------------------------------
      # Add Variables selection option from mtcars : 
      p("Choose columns from mtcars to be analyze."),
      selectInput("var", "Select Variable from Dataset", 
                  choices=c("mpg"=1, "cyl"=2, "disp"=3, "hp"=4, "drat"=5, "wt"=6,
                            "qsec"=7, "vs"=8, "am"=9, "gear"=10, "carb"=11),
                  multiple=TRUE, selected = "mpg"
      ),
      
      br(),   br()
    ),
    
    mainPanel(
      p("Click on Summary to show a stadistical summary."),
      p("Click on Structure to display the data structure corresponding dataframe."),
      p("Click on Data to display the data for the user selected options."),
      p("Click on Plot to plot the data for corresponding dataframe"),
      #------------------------------------------------------------------
      # Create tab panes
      tabsetPanel(type="tab",
                  tabPanel("Summary",verbatimTextOutput("sumry")),
                  tabPanel("Structure", verbatimTextOutput("struct")),
                  tabPanel("Data", tableOutput("displayData")),
                  tabPanel("Plot", plotOutput("mygraph"))
      )
      
      #------------------------------------------------------------------
    )
  )
  
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  cols <- reactive({
    as.numeric(c(input$var))
    
  })
  
  myFinalData <- reactive({
    #------------------------------------------------------------------
    # Get data rows for selected mpg range
    mydata1 <- mtcars[mtcars$mpg >= input$MPGRange[1], ] # From mpg
    mydata1 <- mydata1[mydata1$mpg <= input$MPGRange[2], ] # To mpg
    #------------------------------------------------------------------
    # Get Data for selected mtcars columns as variable
    mydata2<- mydata1[, c(1, sort(cols()))]
    #------------------------------------------------------------------
    # Get data rows for selected mpg range
    data.frame(mydata2)
    #------------------------------------------------------------------
    
  })
  
  # Prepare "Data tab"
  output$displayData <- renderTable({
    myFinalData()
  })
  
  # Prepare Structure Tab
  renderstr <- reactive({ str(myFinalData())})
  
  output$struct <- renderPrint({
    renderstr()
  })
  
  # Prepare Summary Tab
  rendersumry <- reactive({ summary(myFinalData())})
  
  output$sumry <- renderPrint({
    rendersumry()
  })
  
  # Prepare Plot Tab
  output$mygraph <- renderPlot({
    plotdata <- myFinalData()
    plot(plotdata, col=c(1,2,3,4,5,6,7,8,9), main="Plot Motor Trend Car Road Tests")
  })
  
  
}



# Run the application 
shinyApp(ui = ui, server = server)

