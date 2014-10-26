 library(shiny)
 require(rCharts)
##options(RCHART_LIB = 'polycharts')

#pageWithSidebar
 dat<-read.csv("monitor.dat")
 df<-read.csv("df.csv",stringsAsFactors=F)
 dfday<-read.csv("df-day.csv",stringsAsFactors=F) 
 dfmon<-read.csv("df-mon.csv",stringsAsFactors=F)
 
 
shinyUI(pageWithSidebar(
        headerPanel("Air Quality Index (AQI) PM2.5 From U.S. Embassy at China(2014-01-01 to 2014-08-31)"),
        
         sidebarPanel(

             h4("Select the air pullution Range:"),
             
             sliderInput("range", 
                         label = "PM2.5 Air Quality Index (AQI)", 
                         min = 0, max = 600, value = c(200, 500), step=1,
                         format="### µg/m³", locale="us", animate=TRUE),
  
             h4("Location of U.S. Embassy in China:"),
             
             plotOutput("map"),             
             
                h4("The AQI plot at Date:"), 

             selectInput("mon", 
                         "Month:(scroll to see more)", 
                         unique(dfday$mon),
                         selected=1),
             #                                    selected =1),     
             
             selectInput("day", 
                         "Day:(scroll to see more)", 
                         unique(dfday$day),
                         selected=1),
             selectInput("year", 
                         "Year:", 
                         2014)
             
#                 checkboxGroupInput("city", "Monitor Locations:",
#                                    c("U.S. Embassy in Beijing"="Beijing",
#                                      "U.S. Embassy in Shanghai"="Shanghai",
#                                      "U.S. Embassy in Guangzhou"="Guangzhou",
#                                      "U.S. Embassy in Shenyang"="Shenyang",
#                                      "U.S. Embassy in Chengdu"="Chengdu")
#                         ),
 
             
             

             
                
         ),                     
                
                
#                submitButton('Submit'),
                

        
        mainPanel(

            
                tabsetPanel(
                    position = "above",
                    tabPanel("Plot", 
                             h4("Wthin the Selected AQI Range,"),
                             h4("Number of Days in Each City(2014):"),
                             showOutput("aqiplot", "nvd3"),
                             h4("24 hours Air pullution(change Date on the left):"),
                             showOutput('dayplot', "highcharts")
#                             # htmlOutput("view")
                             ),
#                     
#                     
#                     
#     
#                     
#                     
#                     
                    tabPanel("Summary",
                                     h3("Air Polution Report"),
                            # showOutput("my1", "morris"),
                            h4("Compare the AQI in each Month:"),
                             showOutput("my3", "nvd3"),
                            h4("Compare the AQI in each City:"),
                            showOutput("my2", "nvd3"),
                           
                            h4("Compare the AQI each Month by City(line Chart):"),
                            showOutput("my4", "highcharts")
                            ),

tabPanel("Table", 
         fluidPage(
             titlePanel("Basic DataTable"),
#              fluidRow(
#                  column(4, 
#                         selectInput("AQI", 
#                                     "Air Quality Index (AQI):", 
#                                     c("All", 
#                                       unique(as.character(dfday$Air.Quality.Index..AQI.)))
#                  ),
#                  column(4, 
#                         selectInput("city",
#                                     "City (U.S. Embassy):", 
#                                     c("All", 
#                                       unique(as.character(dfday$city))))
#                  ),
#                  column(4, 
#                         selectInput("mon", 
#                                     "Month:", 
#                                     c("All", 
#                                       unique(dfday$mon)))
#                  ),     
#                  column(4, 
#                         selectInput("day", 
#                                     "Day:", 
#                                     c("All", 
#                                       unique(dfday$day)))
#                  )        
                 
#              ),
             # Create a new row for the table.
             fluidRow(
                 dataTableOutput(outputId="table")
             )    
         )
) # end tabPanel



))
)# end main panel
)#shinyUI