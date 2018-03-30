
FieldsInput <- function(id, xvar = TRUE, yvar = TRUE) {
  ns <- NS(id)

  tagList(
    if(xvar) shiny::uiOutput(ns("xvar")),
    if(yvar) shiny::uiOutput(ns("yvar"))
  )
}

Fields <- function(input, output, session, var_choices) {
  ns <- session$ns

  output$xvar <- shiny::renderUI({
    selectInput(ns("xvar"), "x variable:",
                choices = var_choices, selected = CONST_NONE)
  })
  output$yvar <- shiny::renderUI({
    selectInput(ns("yvar"), "y variable:",
                choices = var_choices, selected = CONST_NONE)
  })

  values <- reactiveValues()
  observe({
    values$xvar <- input$xvar
    values$yvar <- input$yvar
  })
  return(values)
}
