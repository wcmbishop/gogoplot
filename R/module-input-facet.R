
FacetsInput <- function(id) {
  ns <- NS(id)
  tagList(
    shiny::uiOutput(ns("facet_row")),
    shiny::uiOutput(ns("facet_col")),
    shiny::checkboxInput(ns("facet_label"), "show field label",
                         value = TRUE)
  )
}

Facets <- function(input, output, session, var_choices) {
  ns <- session$ns

  output$facet_row <- shiny::renderUI({
    selectInput(ns("facet_row"), "facet rows:",
                choices = var_choices, selected = CONST_NONE)
  })
  output$facet_col <- shiny::renderUI({
    selectInput(ns("facet_col"), "facet cols:",
                choices = var_choices, selected = CONST_NONE)
  })

  values <- reactiveValues()
  observe({
    values$facet_row <- input$facet_row
    values$facet_col <- input$facet_col
    values$facet_label <- input$facet_label
  })
  return(values)
}
