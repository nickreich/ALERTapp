shinyUI(pageWithSidebar(
  
  headerPanel("The ALERT Algorithm"),
  
  sidebarPanel(
    
    tags$head(
      tags$style(HTML("
      .shiny-output-error-validation {
        color: black;
      }
    "))
    ),
    
    h4("Upload Data"),
    
    helpText('"For this app to function properly, the CSV file must consist of only two columns, the first for the "Date" and the second for "Cases." The "Date" column must be in an unambiguous YMD format.'),
    
    fileInput('file1', 'Choose CSV File', accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
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
    
    helpText(a("Send us your comments or feedback!", href="mailto:nick@schoolph.umass.edu", target="_blank")),
    
    helpText(a("Read the Paper!", 
               href="http://cid.oxfordjournals.org/content/early/2014/11/18/cid.ciu749.full.pdf", 
               target="_blank")),
    
    helpText(a("ALERT on GitHub", href="https://github.com/nickreich/ALERT", target="_blank")),
    
    helpText(a("ALERTapp on GitHub", href="https://github.com/nickreich/ALERTapp", target="_blank"))
  ),
  
  mainPanel(
    tabsetPanel(
      tabPanel("About",
               helpText('This is the web app for the paper ',
                        a('"Triggering Interventions for Influenza: The ALERT Algorithm"', 
                          href = "http://cid.oxfordjournals.org/content/early/2014/11/18/cid.ciu749.full.pdf",
                          target = "_blank"), 
                        ' by Reich et al, published in Clinical Infectious Diseases in November 2014.'),
               helpText('The Above Local Elevated Respiratory illness Threshold (ALERT) algorithm provides a simple, easy-to-use tool for defining the onset of seasonal epidemics in a community (such as a city or a hospital) that systematically collects surveillance data on a particular disease. The ALERT algorithm was designed and validated with hospital surveillance data on influenza A virus.'),
               helpText('The data provided in this app is real influenza A data that has been modified from its original source to mask the original data, as part of existing data sharing agreements. Users may use the “upload” box on the left-hand side of this page to upload their own data. To function properly, any uploaded dataset must have a column named “Date” and a column named “Cases." The "Date" column must be in an unambiguous YMD format.'),
               helpText("This project was motivated by the authors' work on the ", 
                        a("Respiratory Protection Effectiveness Clinical Trial (ResPECT)",
                          href = "http://clinicaltrials.gov/show/NCT01249625", 
                          target = "_blank"), 
                        " study. While the authors have worked hard to assure the stability and accuracy of results provided, they do not assume any legal liability or responsibility for the accuracy, completeness, or usefulness of any information provided by this Shiny web application. Individuals interested in using the app for decision making purposes are encouraged to ", 
                        a("contact the developers", 
                          href = "mailto:nick@schoolph.umass.edu", target="_blank"),
                        ".")),
      tabPanel("Data Summary", 
               dataTableOutput("summary"), 
               tags$style(type="text/css", '#summary tfoot {display:none;}'),
               tags$br(),
               plotOutput("dataplot")),
      tabPanel("Performance Graphs", plotOutput("durplot"),
               plotOutput("pctplot"),
               helpText("The highlighted area spans from the minimum to the maximum value for each threshold."))
    ),
    includeHTML("statcounter.js")
  )
))