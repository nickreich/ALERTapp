shinyUI(pageWithSidebar(
  
  headerPanel("The ALERT Algorithm"),
  
  sidebarPanel(
    
    h4("Upload Data"),
    
    fileInput('file1', 'Choose CSV File (Must consist of only two columns, the first for the "Date" and the second for "Cases")', accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
    checkboxInput('header', 'Header', TRUE),
    radioButtons('sep', 'Separator', c(Comma=',',Semicolon=';', Tab='\t'),','),
    #helpText('Do you authorize the authors of this website to use this data in the interest of improving the ALERT algorithm?'),
    #actionButton('authorize', 'Authorize'),
    #h5(textOutput("thanks")),
    tags$hr(),
    
    h4("Choose Parameters"),
    
    sliderInput("firstMonth", "First Month of Flu Season", min=1, max=12, value=9),
    sliderInput("minWeeks", "Shortest Possible Flu Season (Weeks)", min=1, max=10, value=8),
    sliderInput("k", "+/- k Weeks", min=0, max=5, value=2),
    sliderInput("lag", "Days Between Cases Reports and Policy Action", min=1, max=21, value=7),
    sliderInput("target.dur", "Target Duration (Weeks)", min=1, max=20, value=12),
    sliderInput("target.pct", "Target % of Cases Covered", min=30, max=100, value=85, step=5),
    checkboxInput("allThresholds", "Use More Thresholds?", FALSE),
    
    tags$hr(),
    
    helpText("Created by Stephen A Lauer and Nicholas G Reich"),
    
    helpText(a("Send us your comments or feedback!", href="mailto:slauer@schoolph.umass.edu", target="_blank")),
    
    helpText(a("ALERT on GitHub", href="https://github.com/nickreich/ALERT", target="_blank")),
    
    helpText(a("ALERTapp on GitHub", href="https://github.com/nickreich/ALERTapp", target="_blank")),
    
    tags$hr(),
    
    h5(textOutput("counter"))
  ),
  
  mainPanel(
    tabsetPanel(
      tabPanel("About",
               helpText('The Above Local Elevated Respiratory illness Threshold (ALERT) algorithm provides a simple, easy-to-use tool for defining the onset of seasonal epidemics in a community (such as a city or a hospital) that systematically collects surveillance data on a particular disease. The ALERT algorithm was designed and validated with hospital surveillance data on influenza A virus. A description of the underlying methodology is currently under review.'),
               helpText('The data provided in this app is real influenza A data that has been modified from its original source to mask the original data, as part of existing data sharing agreements. Users may use the “upload” box on the left-hand side of this page to upload their own data. To function properly, any uploaded dataset must have a column named “Date” and a column named “Cases."')),
      tabPanel("Data Summary", 
               dataTableOutput("summary"), 
               tags$style(type="text/css", '#summary tfoot {display:none;}'), 
               plotOutput("dataplot")),
      tabPanel("Performance Graphs", plotOutput("durplot"),
               plotOutput("pctplot"),
               helpText("The highlighted area spans from the minimum to the maximum value for each threshold."))
    )#,
    #includeHTML("statcounter.js")
  )
))