
ThemeInput <- function(id) {
  ns <- NS(id)
  tagList(
    shiny::selectInput(ns("theme"), label = "plot theme:",
                       choices = c("theme_gray", "theme_bw", "theme_light",
                                   "theme_dark", "theme_minimal", "theme_void"),
                       selected = CONST_DEFAULT_THEME),
    shiny::sliderInput(ns("base_size"), label = "base size:",
                       min = 5, max = 20, step = 1,
                       value = CONST_DEFAULT_THEME_BASE_SIZE)
  )
}

Theme <- function(input, output, session) {
  ns <- session$ns

  values <- reactiveValues()
  observe({
    values$theme <- input$theme
    values$base_size <- input$base_size
  })
  return(values)
}
