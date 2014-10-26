require(rCharts)
library(ggplot2)
library(maptools)
library(mapdata)
library(maps)
library(zoo)
library(plyr)
#library(googleVis)



dat<-read.csv("monitor.dat")
df<-read.csv("df.csv",stringsAsFactors=F)
dfday<-read.csv("df-day.csv",stringsAsFactors=F) 
dfmon<-read.csv("df-mon.csv",stringsAsFactors=F)

options(RCHART_WIDTH = 500)

shinyServer(function (input, output){


output$dayplot <- renderChart({
    
    data1 <-read.csv("df.csv",stringsAsFactors=F)

    h1 <- hPlot(x = "date", y = "value", data = data1[data1$mon==input$mon,][data1[data1$mon==input$mon,]$Day==input$day,], type = c("line"), group = "city")
    #h1 <- hPlot(x = "date", y = "value", data = data1[data1$mon==1,][data1[data1$mon==1,]$Day==1,], type = c("line"), group = "city")
    
    h1$xAxis(ticks="" )
    h1$set(dom = 'dayplot')
    return(h1)
})


output$aqiplot <- renderChart({
    pm1<-as.numeric(input$range)[1]
    pm2<-as.numeric(input$range)[2]
    
    aqi<-dfday
    aqi<-aqi[aqi$mean>pm1 & aqi$mean <=pm2,]
    # Step 1. create subsets of data by gender
    pmday   <- ddply(aqi,.(city),
               summarise,
               count = length(mean))
    n1 <- nPlot(count ~ city, data = pmday, type = "multiBarChart")
    n1$set(dom = 'aqiplot')
    n1
})
    


output$my1 <- renderChart({

m1 <- mPlot(x = "date", y = c("mean", "max", "min"), type = "Line", data = dfday)
m1$set(pointSize = 0, lineWidth = 1)
#m1$yAxis( axisLabel = "PM2.5 (µg/m³)", width = 40 )
m1$set(dom = 'my1')
return(m1)
})

output$my2 <- renderChart({
nn1 <- nPlot(mean ~ city, group = "date", data = dfmon, type = "multiBarChart")
#nn1$chart(stacked = T)
nn1$set(dom = 'my2')
return(nn1)
})
output$my3 <- renderChart({
g1 <- nPlot(mean ~ date, group = "city", data = dfmon, type = "multiBarChart")
g1$set(title = "AQI in China each month")
g1$yAxis( axisLabel = "PM2.5 (µg/m³)", width = 50)
g1$xAxis( axisLabel = "Month", width = 50)
g1$set(dom = 'my3')
return(g1)
})
output$my4 <- renderChart({
h1 <- hPlot(x = "mon", y = "mean", data = dfmon, type = c("line"), group = "city")
h1$xAxis(ticks="" )
h1$set(dom = 'my4')
return(h1)
})



##for my table, choose by day, by month
# Define a server for the Shiny app
    # Filter data based on selections
output$table <- renderDataTable({
        data <- dfday[,-c(2,4)]
#         if (input$city != "All"){
#             data <- data[data$city == input$city,]
#         }
#         if (input$mon != "All"){
#             data <- data[data$mon == input$mon,]
#         }
#         if (input$day != "All"){
#             data <- data[data$day == input$day,]
#         }
#         if (input$AQI != "All"){
#             data <- data[data$AQI == input$Air.Quality.Index..AQI.,]
#         }
        data
    }) #renderDataTable
    

# # 
# # 
# # output$view <- renderGvis({
# # 
# #             sday<-dfday
# #             sday<-sday[sday$mon == input$mon,]
# #             sday<-sday[sday$day == input$day,]
# # #             sday<-sday[sday$AQI == input$city,]
# # gvisGauge(sday[1,c(5,9)], options=list(min=0, max=500, greenFrom=0,
# #                                                     greenTo=50, yellowFrom=51, yellowTo=100,
# #                                                     redFrom=101, redTo=500, 
# #                                                     width=400, height=300)) 
# # 
# # })
# # 
# 
# 
# 
output$map <-renderPlot(
{
    par(mar=rep(0,4))
    map("china", col = "green", ylim = c(18, 54), panel.first = grid(), lwd=3)
    points(dat$long, dat$lat, pch = 19, col = rgb(0, 0, 0, 0.5))
    text(dat$long, dat$lat, dat[, 2], cex = 1, col = rgb(1,0, 0, 0.7), 
         pos = c(2, 4, 4, 4, 3, 4, 2, 3, 4, 2, 4, 2, 2,4, 3, 2, 1, 3, 1,
                 1, 2, 3, 2, 2, 1, 2, 4, 3, 1, 2, 2, 4, 4, 2))
    axis(1, lwd = 0); axis(2, lwd = 0); axis(3, lwd = 0); axis(4, lwd = 0)   
})

})



# 
# 
# 
# df[,1]<-as.character(df[,1])
# df[,1][df$mean<=50]<-"Good"
# df[,1][df$mean>50]<-"Moderate"
# df[,1][df$mean>100]<-"Unhealthy for Sensitive Groups"
# df[,1][df$mean>150]<-"Unhealthy"
# df[,1][df$mean>200]<-"Very Unhealthy"
# df[,1][df$mean>300]<-"Hazardous"
# df[,1][df$mean>500]<-"Beyond Index"
# names(df)[1]<-"Air Quality Index (AQI)"

