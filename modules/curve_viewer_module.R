curve_viewer_module_UI <- function(id) {
  ns <- NS(id)
  
  fluidPage( 
    theme = shinytheme("cerulean"),
    #shinythemes::themeSelector(),

    
    #Jumbotrons are pretty, they make nice headers
    tags$div(class = "jumbotron text-center", style = "margin-bottom:0px;margin-top:0px",
             tags$h2(class = 'jumbotron-heading', stye = 'margin-bottom:0px;margin-top:0px', 'Curve Data Viewer'),
             p('Learn about using RShiny to understand curve data in production')
    ),
    
    
    
    
    br(),
    fluidRow(
      column(4, 
             pickerInput(
               inputId = ns("line_selection"),
               label = "Line Selection", 
               choices = all_stations,
               selected = all_stations[1],
               multiple = FALSE,
               autocomplete = FALSE)
      ),
      column(4, 
             pickerInput(
               inputId = ns("measuremnet_selection"),
               label = "Measurment Selection", 
               choices = measuremnet_selection,
               selected = measuremnet_selection[1],
               multiple = FALSE,
               autocomplete = FALSE)
      )
    ),
    fluidRow(
      column(12,
             plotOutput(ns("plot_dryer_fan_speed"))
      ) 
    )
  )

}

curve_viewer_module_Server <- function(input, output, session) {
  
  selected_curve_data <- reactive({  
    
    

    
    selected_station <- input$line_selection

    selected_curve_data <- curve_data %>% 
      filter(station_id == selected_station) 
    selected_curve_data <- selected_curve_data %>%
      mutate(process_time = seq(from=recent_time, to=now, length.out=nrow(selected_curve_data)))
      
      
    
    })
    
    
  output$plot_dryer_fan_speed<-renderPlot({
    
    
    measurment_selection <- input$measuremnet_selection
    
    dat <- selected_curve_data()  %>% 
      select(any_of(c("station_id", "process_time", measurment_selection))) %>% 
      rename("y" = measurment_selection)
    
    
    #browser()
    
    
    ggplot(dat,aes(x=process_time,y=y)) +
      geom_line() + 
      geom_point(colour='red', alpha=0.6) +
      xlab("Time Stamp") + 
      ylab(measurment_selection) +
      theme(axis.title=element_text(size=20), axis.text=element_text(size=15))
    
    
    
    
    
    
    
    })

}

