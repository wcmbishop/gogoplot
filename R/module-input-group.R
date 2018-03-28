
GroupInput <- function(id) {
  ns <- NS(id)
  tagList(
    shiny::uiOutput(ns("group_fields"))
  )
}

Group <- function(input, output, session, var_choices) {
  ns <- session$ns

  output$group_fields <- shiny::renderUI({
    selectInput(ns("group_fields"), "line grouping:",
                multiple = TRUE, choices = var_choices)
  })

  values <- reactiveValues()
  observe({
    values$group_fields <- input$group_fields
  })
  return(values)
}
