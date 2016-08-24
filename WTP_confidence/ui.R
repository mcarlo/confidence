library(shiny)
library(googleVis)

# Define the overall UI
shinyUI(fluidPage(
  includeCSS("styles.css"),
  fluidRow(
    #column(3, p("")),
    column(12,
           h3("Subscriber picks for 2016"), #style = "color: #06018f;"),
           h6("Appropriate for confidence pools with a weekly payout"),
           sliderInput("players", "   Number of Players in Pool:", min = 5,
                       max = 100, step = 5, value = 35),
           p("Weekly payout:"),
           numericInput("first", "1st", min = 10,
                        max = 250, step = 5, value = 100),
           numericInput("second", "2nd", min = 0,
                        max = 250, step = 5, value = 50),
           numericInput("third", "3rd", min = 0,
                        max = 250, step = 5, value = 25),


           fluidRow(
             column(6,
                    h4(paste0("Highest average payoff, Week 1")),
                    p(paste0("Simulations updated ", as.character.Date(Sys.time()), as.character.Date(Sys.timezone()))),
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
                                .myTablerow {background-color:#D9D9D9;}"))))
           )
  ),
  tags$head(includeScript("google-analytics.js"))
)

)