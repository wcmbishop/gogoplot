
ScalesInput <- function(id) {
  ns <- NS(id)
  tagList(
    # shiny::splitLayout(
    #   cellWidths = c("20%", "80%"),
    #   shiny::helpText("theme:"),
    #   shiny::selectInput(ns("theme"), label = NULL,
    #                      choices = c("theme_gray", "theme_bw", "theme_light",
    #                                  "theme_dark", "theme_minimal", "theme_void"),
    #                      selected = CONST_DEFAULT_THEME)
    # ),
    # shiny::splitLayout(
    #   cellWidths = c("20%", "80%"),
    #   shiny::helpText("base size:"),
    #   shiny::sliderInput(ns("base_size"), label = NULL,
    #                      min = 5, max = 20, step = 1,
    #                      value = CONST_DEFAULT_THEME_BASE_SIZE)
    # )
  )
}

Scales <- function(input, output, session) {
  ns <- session$ns

  values <- reactiveValues()
  observe({
    # values$theme <- input$theme
  })
  return(values)
}
