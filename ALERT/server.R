require(ggplot2)
require(ALERT)
data(fluData)
#source("ALERT.R")
#load("fluData.RData")
cbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

shinyServer(function(input, output) {
  data <- reactive({
    inFile <- input$file1
    if(is.null(inFile)){
      ddd <- fluData
    }
    
    else
      ddd <- read.csv(inFile$datapath, header=input$header, sep=input$sep)
    
    colnames(ddd) <- c("Date", "Cases")
    ddd$Date <- as.Date(ddd$Date, "%m/%d/%y")
    as.data.frame(ddd)
  })
  
  output$dataplot <- renderPlot({
    data.plot <- ggplot(data=data()) + 
      geom_bar(aes(x=Date, y=Cases), stat="identity", fill="#0072B2", color="#0072B2") + 
      scale_y_continuous(name="Case Counts") +
      theme_bw() + 
      theme(axis.title.x = element_blank(),
            axis.title.y = element_text(face="bold", size=18),
            axis.text.x  = element_text(size=16),
            axis.text.y  = element_text(size=16))
    print(data.plot)
  })
  
  threshdat <- reactive({
    tmp <- createALERT(data=data(), 
                       firstMonth=input$firstMonth, 
                       minWeeks=input$minWeeks, 
                       k=input$k, 
                       lag=input$lag, 
                       target.pct=input$target.pct/100, 
                       allThresholds=input$allThresholds
    )$out
    as.data.frame(round(tmp,1))
  })
  
  output$summary = renderDataTable({
    threshdat <- threshdat()
    colnames(threshdat) <- c("Threshold", "Median Duration", "Median % Cases Captured", 
                             "Min % Cases Captured", "Max % Cases Captured", 
                             "% Peaks Captured", "% Peaks +/- k Weeks Captured", 
                             "Mean # of Weeks Below Threshold", "Mean # of Weeks Longer Than Optimal")
    threshdat
  }, options=list(bFilter=0, bSortClasses=TRUE, bProcessing=0, bPaginate=0, bInfo=0))
  
  details <- reactive({
    tmp <- createALERT(data=data(), 
                       firstMonth=input$firstMonth, 
                       minWeeks=input$minWeeks, 
                       k=input$k, 
                       lag=input$lag, 
                       target.pct=input$target.pct/100, 
                       allThresholds=input$allThresholds
    )$details
    tmp
  })
  
  output$durplot <- renderPlot({
    threshdat <- threshdat()
    details <- details()
    threshdat$min.dur <- sapply(details, FUN=function(x) min(x[,"duration"]))
    threshdat$max.dur <- sapply(details, FUN=function(x) max(x[,"duration"]))
    
    p <- qplot(data=threshdat, x=threshold, y=median.dur) + 
      geom_point(color=cbPalette[6], size=4) +
      geom_line(color=cbPalette[6], size=2) +
      geom_ribbon(aes(ymin=min.dur, ymax=max.dur), alpha=0.3, fill=cbPalette[6]) +
      scale_x_continuous(name = "", breaks=threshdat$threshold) + 
      scale_y_continuous(name = "Median Duration (Weeks)", 
                         breaks=seq(0,max(30,max(threshdat$max.dur)),6), 
                         limits=c(0,max(30,max(threshdat$max.dur)))) +
      geom_hline(aes(yintercept=input$target.dur), color=cbPalette[7], linetype="dashed", size=1) +
      #ggtitle("Median Duration and Median Percentage of Cases Captured by Threshold") +
      theme_bw() + theme(axis.text.x = element_text(size=16),
                         axis.text.y = element_text(size=16),
                         axis.title.y = element_text(size=18, face="bold"),
                         plot.title = element_text(size=20, face="bold"))
    
    print(p)   
  })
  
  output$pctplot <- renderPlot({
    threshdat <- threshdat()
    
    p <- qplot(data=threshdat, x=threshold, y=median.pct.cases.captured) +
      geom_ribbon(aes(ymin=min.pct.cases.captured, ymax=max.pct.cases.captured), alpha=0.3, 
                  fill=cbPalette[4]) +
      geom_point(color=cbPalette[4], size=4) +
      geom_line(color=cbPalette[4], size=2) +
      scale_x_continuous(name = "Threshold", breaks=threshdat$threshold) + 
      scale_y_continuous(name = "Median % Cases Captured", breaks=seq(0,100,20), limits=c(0,100)) +
      geom_hline(aes(yintercept=input$target.pct), color=cbPalette[7], linetype="dashed", size=1) +
      theme_bw() + theme(axis.title.x = element_text(size=18, face="bold"),
                         axis.text.x = element_text(size=16),
                         axis.text.y = element_text(size=16),
                         axis.title.y = element_text(size=18, face="bold"))
    
    print(p)   
  })
})