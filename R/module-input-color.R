
ColorInput <- function(id, show_alpha = TRUE) {
  ns <- NS(id)
  tagList(
    shinyWidgets::switchInput(ns("color_mapping_enabled"), label = "(aes)",
                              value = FALSE, onLabel = "map",
                              offLabel = "set"),
    shiny::conditionalPanel(
      sprintf("input['%s'] == false", ns("color_mapping_enabled")),
      shiny::uiOutput(ns("color_set"))),
    shiny::conditionalPanel(
      sprintf("input['%s'] == true", ns("color_mapping_enabled")),
      shiny::uiOutput(ns("color_map")),
      shiny::uiOutput(ns("color_discrete"))),
    if (show_alpha) shiny::uiOutput(ns("alpha"))
  )
}

Color <- function(input, output, session, var_choices) {
  ns <- session$ns

  output$color_map <- shiny::renderUI({
    selectInput(ns("color_map"), "color mapping:",
                choices = var_choices, selected = CONST_NONE)
  })
  output$color_set <- shiny::renderUI({
    selectInput(ns("color_set"), "color setting:",
                choices = c(CONST_NONE, "red", "orange", "yellow",
                            "green", "blue", "purple"),
                selected = CONST_NONE)
  })
  output$color_discrete <- shiny::renderUI({
    shiny::checkboxInput(ns('color_discrete'), 'force discrete', value = FALSE)
  })
  output$alpha <- shiny::renderUI({
    sliderInput(ns("alpha"), "alpha:", min = 0, max = 1, value = 1, step = 0.1)
  })

  values <- reactiveValues()
  observe({
    values$color_map <- input$color_map
    values$color_set <- input$color_set
    values$color_mapping_enabled <- input$color_mapping_enabled
    values$color_discrete <- input$color_discrete
    values$alpha <- input$alpha
  })
  return(values)
}
