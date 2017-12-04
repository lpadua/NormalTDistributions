
# This is the server logic for a Shiny web application
# created as a final Course Project of Developint Data Products by Coursera
#
# autor: Luis Padua
# date: 03Dec2017
#

library(shiny)
library(dplyr)
library(ggplot2)

shinyServer(function(input, output, session) {
        
        values <- reactiveValues()
        values$df <- data.frame(Entries = numeric(0))
        values$mean <- 0
        values$sd <- 1
        values$nrow <- 0
        p1 <- reactiveValues()
        newEntry <- observe({
                if(input$saveInput > 0) {
                        Entries <- isolate(c(input$newinput))
                        isolate(values$df <- bind_rows(values$df, data.frame(Entries)))
                        isolate(values$mean <- mean(values$df$Entries))
                        isolate(values$sd <- sd(values$df$Entries))
                        isolate(values$nrow <- nrow(values$df))
                        updateSliderInput(session, "probInput", value = values$mean,
                                          min = round(values$mean-5*values$sd,2), 
                                          max = round(values$mean+5*values$sd,2), step = 0.01)
                }
        })
        observeEvent(input$clear, {
                isolate(values$df <- data.frame(Entries = numeric(0)))
                isolate(values$mean <- 0)
                isolate(values$sd <- 1)
                isolate(values$nrow <- 0)
        })
        output$table <- renderTable({values$df})
        output$mean <- renderText({
                values$mean
        })
        output$sd <- renderText({
                values$sd
        })
        output$sampleSize <- renderText({
                values$nrow
        })
        output$distPlot <- renderPlot({
                maxSample <- values$mean + 5*values$sd
                minSample <- values$mean - 5*values$sd
                tFun <- function(x) {dt(x - values$mean, values$nrow)}
                probInput <- input$probInput
                p1 <- ggplot(data = data.frame(x = c(minSample, maxSample)), aes(x)) +
                        stat_function(fun = dnorm, n = 101, 
                                      args = list(mean = values$mean, sd = values$sd), 
                                      aes(colour = "Normal"), size = 1.5) +
                        stat_function(fun = tFun, aes(colour = "T Student"), size = 1.5) +
                        scale_colour_manual("Distributions", values = c("deeppink", "dodgerblue3")) +
                        scale_x_continuous(name = "Entries") +
                        scale_y_continuous(name = "Frequency", breaks = NULL) +
                        geom_vline(xintercept = probInput, color = "red", size=1.5)
                p1
        })
        output$pNorm <- renderText({
                pnorm(input$probInput, mean = values$mean, sd = values$sd, lower.tail = input$type)
        })
        output$pDT <- renderText({
                pt(input$probInput-values$mean, df = values$nrow, lower.tail = input$type)
        })

})
