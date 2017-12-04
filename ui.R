
# This is the user-interface definition of a Shiny web application
# created as a final Course Project of Developint Data Products by Coursera
#
# autor: Luis Padua
# date: 03Dec2017
#

library(shiny)
library(BH)

shinyUI(fluidPage(

  # Application title
  titlePanel("Normal vs. T-Student Distribution Probabilities"),

   # Sidebar with User Entries
  sidebarLayout(
    sidebarPanel(
    h5("This app aims to help you understand the differences of the Normal and T Distribution."),
    h5("Based on the Decimals you include with the ADD DATA button, the app will show mean and the density distribution for Normal and T student based on the standard deviation or the degrees of freedom."),
    h5("You can also select a number on the slider to calculate the probability of getting greater or lesser than for each of the distributions"),
    h5("IMPORTANT: when your data has less than 3 entries, the app returns an error calculating the T student. Adds more than 3 to be valid"),
    numericInput("newinput",
          "Enter a new number for your data:",
          value = 0),
      actionButton("saveInput", "Add Data"),
      tableOutput("table"),
      actionButton("clear", "Clear Data")
    ),

    # Show a plot of the generated distribution
    mainPanel(
            fluidRow(
                    column(4,
                           h4("Mean of Data:"),
                           textOutput("mean")),
                    column(4,
                           h4("Standard Deviation:"),
                           textOutput("sd")),
                   column(4,
                          h4("Samples (Degrees of Freedom):"),
                          textOutput("sampleSize"))
                           
            ),
            plotOutput("distPlot"),
            hr(),
            fluidRow(
                    column(4,
                           sliderInput("probInput", "Choose a value to calculate probability:",
                                       min = 0, max = 1,
                                       value = 0, step = 0.1)),
                    column(4,
                           radioButtons("type", h4("Type:"),
                                        choices = list("Less Than" = 1, "Greater Than" = 0),selected = 1)),
                    column(4,
                           h4("Probabilities:"),
                           fluidRow(
                                   column(6,
                                          h5("Normal:"),
                                          h5("T Student:")),
                                   column(6,
                                          h5(textOutput("pNorm")),
                                          h5(textOutput("pDT")))
                                   
                           )
                    )
            )
    )
  )
))
