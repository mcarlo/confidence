library(shiny)
library(googleVis)

# Define the overall UI
shinyUI(fluidPage(
  includeCSS("styles.css"),
  fluidRow(
    h3("2016 tactical picks"), #style = "color: #06018f;"),
    h6("Appropriate for confidence pools with a weekly payout"),
    h6(htmlOutput(outputId="updateTime")), #style = "color: #06018f;"),
    #column(3, p("")),
	           fluidRow(
             column(6,
                    #h4(htmlOutput(outputId = "weekNum") ), #paste0("Highest average payoff, Week 17")),
                    #htmlOutput(outputId="updateTime"), #12/31/15 12:38p PST")),
                    h4(htmlOutput(outputId = "weekNum") ),
                    
                    htmlOutput(outputId="gSlate1")
                    ,
                    tags$head(tags$style(type="text/css",
                                ".myTableHeadrow {color:#FFFFFF; background-color:#FF0000;}
                                .myTablerow {background-color:#D9D9D9;}"))),
             column(6,
                    h4("Most often in the money"),
                    br(),
                    htmlOutput(outputId="gITM1")
                    ,
                    tags$head(tags$style(type="text/css",
                                ".myTableHeadrow {color:#FFFFFF; background-color:#FF0000;}
                                .myTablerow {background-color:#D9D9D9;}")))),
    column(4,
           sliderInput("players", "   Number of Players in Pool:", min = 5,
                       max = 100, step = 5, value = 35)),
    column(8,
           p("Weekly payout:"),
           numericInput("first", "1st", min = 10,
                        max = 250, step = 5, value = 100),
           numericInput("second", "2nd", min = 0,
                        max = 250, step = 5, value = 50),
           numericInput("third", "3rd", min = 0,
                        max = 250, step = 5, value = 25)
           #,



           )
  ),
  tags$head(includeScript("google-analytics.js"))
)

)