library(shiny)
library(ggplot2)
library(magrittr)

shinyServer(function(input, output, clientData, session) {  
    
    n <- 550
    points <- seq(1, n)
    
    # If the mean or standard deviation updates, we want to update the seed
    # value.
    observe({
        input$mean
        input$sd
        
        updateNumericInput(session, "seed", value = round(runif(1, 1, 10000)))
    })

    # Renders the population distribution
    output$distribution <- renderPlot({
        mu <- input$mean
        sigma <- input$sd                    
        
        g <- ggplot(data.frame(x = c(0, 100)), aes(x = x))
        g <- g + stat_function(fun = dnorm, arg = list(mean = mu, sd = sigma),
                               geom="ribbon", mapping = aes(ymin = 0, ymax=..y..),
                               fill = "grey", colour = "black")
        g <- g + geom_vline(x = mu, linetype = "dotdash", colour = "darkblue")
        g <- g + theme_light() 
        g <- g + labs(title = bquote("Population distribution with " * mu == .(input$mean)),
                      x = "Mean", y = "Density")
        g <- g + theme(plot.title = element_text(size = 15, face = "bold", vjust=1),
                       axis.title.y = element_text(vjust = 0.95))
        g
    })
    
    currentData <- reactive({
        seed <- input$seed
        mu <- input$mean
        sigma <- input$sd        
        
        set.seed(seed)
        lapply(points, function(n) {                        
            rnorm(n, mean = mu, sd = sigma)
        }) %>% sapply(mean)
    })
    
    # Render the approximation of the means
    output$approximation <- renderPlot({        
        g <- ggplot(data.frame(x = points, y = currentData()), aes(x = x, y = y))
        g <- g + geom_hline(y = input$mean, linetype = 'dotdash', colour = 'darkblue')
        g <- g + geom_line()
        g <- g + theme_light() 
        g <- g + labs(title = "Sample means as n increases",
                      x = "Sample size", y = "Mean")
        g <- g + theme(plot.title = element_text(size = 15, face = "bold", vjust=1),
                       axis.title.y = element_text(vjust = 0.95))
        g                
    })
    
    output$residuals <- renderTable({
        d_points <- seq(1, n, 61)
        data <- currentData()[d_points]        
                
        data_table <- c(data, abs(data - input$mean)) %>%
            matrix(length(data), 2) %>%
            t %>%
            as.data.frame() 
        data_table[1,] <- round(data_table[1,])
        rownames(data_table) <- c(
            "Sample mean",
            "Residual"
        )    
        colnames(data_table) <- d_points
            
        data_table
    })
    
    output$residualPlot <- renderPlot({
        residuals <- data.frame(
            sample = points,
            residual = abs(currentData() - input$mean)
        )    
        
        g <- ggplot(residuals, aes(x = sample, y = residual))        
        g <- g + geom_line(alpha = 0.5)
        g <- g + theme_light() 
        g <- g + labs(title = "Residuals as sample sizes increase",
                      x = "Sample size", y = "Residual")
        g <- g + theme(plot.title = element_text(size = 15, face = "bold", vjust=1),
                       axis.title.y = element_text(vjust = 0.95))
        g                
    })
    
})