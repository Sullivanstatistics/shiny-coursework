library(shiny)

shinyUI(fluidPage(
        
    titlePanel("The Law of Large Numbers"),
    
    # Sidebar with a slider input for the number of bins
    sidebarLayout(
        sidebarPanel(            
            sliderInput("mean", label = h3("Mean"), value = 40, min = 1, max = 99),
            sliderInput("sd", label = h3("Standard deviation"), value = 10, 
                        min = 1, max = 30),        
            numericInput("seed", label = h3("Random Seed"), value = 123, 
                         min = 1, max = 100000)
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(
                type = "tabs",
                tabPanel(
                    "Introduction",
                    br(),
                    includeHTML('introduction.html')
                ),
                tabPanel(
                    "Sampling",
                    br(),
                    p("A plot of the distribution from which we are drawing samples from,",
                      "along with a plot of the sample sizes vs sample means."),
                    p("In both plots, the population mean is drawn in as a dashed line."),
                    h3("Drawing samples"),            
                    fluidRow(
                        column(6, plotOutput("distribution")),
                        column(6, plotOutput("approximation"))
                    )
                ),
                tabPanel(
                    "Residuals",
                    br(),
                    p("Here we examine the residuals between the true population mean and the",
                      "observed sample means. "),
                    h3("Residual plot"),
                    fluidRow(
                        p("A plot of the residuals vs sample sizes. Notice the trend of reduced residuals",
                          "as sample sizes increases."),
                        plotOutput("residualPlot")
                    ),                    
                    h3("Observed Residual"),
                    fluidRow( 
                        p("The sample means for different sample sizes and the obtained residuals."),
                        tableOutput("residuals")
                    )
                )                        
            )            
        )
    )
))