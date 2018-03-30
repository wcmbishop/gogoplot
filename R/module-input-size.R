
SizeInput <- function(id) {
  ns <- NS(id)

  tagList(
    shinyWidgets::switchInput(ns("size_mapping_enabled"), label = "(aes)",
                              value = FALSE, onLabel = "map",
                              offLabel = "set"),
    shiny::conditionalPanel(
      sprintf("input['%s'] == false", ns("size_mapping_enabled")),
      shiny::uiOutput(ns("size_set"))),
    shiny::conditionalPanel(
      sprintf("input['%s'] == true", ns("size_mapping_enabled")),
      shiny::uiOutput(ns("size_map")))
  )
}

Size <- function(input, output, session, var_choices, default_size = 1.5) {
  ns <- session$ns

  output$size_set <- shiny::renderUI({
    sliderInput(ns("size_set"), "size setting:",
                min = 0.5, max = 6, value = default_size, step = 0.5)
  })
  output$size_map <- shiny::renderUI({
    selectInput(ns("size_map"), "size mapping:",
                choices = var_choices, selected = CONST_NONE)
  })

  values <- reactiveValues()
  observe({
    values$size_set <- input$size_set
    values$size_map <- input$size_map
    values$size_mapping_enabled <- input$size_mapping_enabled
  })
  return(values)
}
