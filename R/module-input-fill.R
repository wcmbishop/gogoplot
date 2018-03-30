
FillInput <- function(id) {
  ns <- NS(id)
  tagList(
    shinyWidgets::switchInput(ns("fill_mapping_enabled"), label = "(aes)",
                              value = FALSE, onLabel = "map",
                              offLabel = "set"),
    shiny::conditionalPanel(
      sprintf("input['%s'] == false", ns("fill_mapping_enabled")),
      shiny::uiOutput(ns("fill_set"))),
    shiny::conditionalPanel(
      sprintf("input['%s'] == true", ns("fill_mapping_enabled")),
      shiny::uiOutput(ns("fill_map")),
      shiny::uiOutput(ns("fill_discrete"))),
    shiny::uiOutput(ns("alpha"))
  )
}

Fill <- function(input, output, session, var_choices) {
  ns <- session$ns

  output$fill_map <- shiny::renderUI({
    selectInput(ns("fill_map"), "color mapping:",
                choices = var_choices, selected = CONST_NONE)
  })
  output$fill_set <- shiny::renderUI({
    selectInput(ns("fill_set"), "color setting:",
                choices = c(CONST_NONE, "red", "orange", "yellow",
                            "green", "blue", "purple"),
                selected = CONST_NONE)
  })
  output$fill_discrete <- shiny::renderUI({
    shiny::checkboxInput(ns('fill_discrete'), 'force discrete', value = FALSE)
  })
  output$alpha <- shiny::renderUI({
    sliderInput(ns("alpha"), "alpha:", min = 0, max = 1, value = 1, step = 0.1)
  })

  values <- reactiveValues()
  observe({
    values$fill_map <- input$fill_map
    values$fill_set <- input$fill_set
    values$fill_mapping_enabled <- input$fill_mapping_enabled
    values$fill_discrete <- input$fill_discrete
    values$alpha <- input$alpha
  })
  return(values)
}
