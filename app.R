library(shiny)
library(data.table)
library(shinydashboard)
library(DT)
library(shinyURL)


DT <- data.table(datasets::CO2)

server <- function(input, output) {
    
    shinyURL.server()
    
    output$.dtOutput <-  DT::renderDataTable( {
      
      DT2render <- eventReactive(input$.input_type,  {
        
        if (!is.null(input$.input_type)) {
          # browser()
          
          DT <- DT[Type %in% input$.input_type]
        } else {
          DT
        }
      })
      
      
      datatable(
        data = DT2render(), 
        selection = 'multiple', class = 'cell-border strip hover',
        escape = FALSE,   
        rownames = TRUE,  
        filter = list(position = "top",
                      clear = F,
                      plain = T),
        extensions = list(
          'Buttons' = NULL
        ),
        options = list(
          processing = T,
          searchHighlight = TRUE,
          search = list(regex = TRUE, caseInsensitive = T),
          dom = 'Blfrtip',
          buttons = c('colvis', 'csv')
        )
      )}, server = T )
    
}

ui <- fluidPage(
  
  sidebarLayout(
    sidebarPanel(
      
      shinyURL.ui() ,
      
      choices <- sort(unique(as.character(DT$Type))),
      
      selectizeInput(".input_type", "Select Type", choices , selected = NULL, multiple = FALSE, options = NULL)
    ),
    mainPanel( fluidPage(  DT::dataTableOutput('.dtOutput') ) )
  )
)

shinyApp(ui = ui, server = server)
