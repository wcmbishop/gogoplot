
LabelsInput <- function(id) {
  ns <- NS(id)
  tagList(

    # title
    tags$h5("Plot Title"),
    shiny::splitLayout(
      cellWidths = c("15%", "85%"),
      shiny::helpText("title:"),
      shiny::textInput(ns("title"), label = NULL)
    ),
    shiny::splitLayout(
      cellWidths = c("15%", "85%"),
      shiny::helpText("subtitle:"),
      shiny::textInput(ns("subtitle"), label = NULL)
    ),

    # axes
    tags$h5("Axes Labels"),
    shiny::splitLayout(
      cellWidths = c("15%", "85%"),
      shiny::helpText("x-axis:"),
      shiny::textInput(ns("label_x"), label = NULL)
    ),
    shiny::splitLayout(
      cellWidths = c("15%", "85%"),
      shiny::helpText("y-axis:"),
      shiny::textInput(ns("label_y"), label = NULL)
    ),

    # legend
    tags$h5("Legend Label"),
    shiny::splitLayout(
      cellWidths = c("15%", "70%", "15%"),
      shiny::helpText("color:"),
      shiny::textInput(ns("label_color"), NULL),
      shiny::checkboxInput(ns("hide_legend_color"), "hide", value = FALSE)
    ),
    shiny::splitLayout(
      cellWidths = c("15%", "70%", "15%"),
      shiny::helpText("fill:"),
      shiny::textInput(ns("label_fill"), NULL),
      shiny::checkboxInput(ns("hide_legend_fill"), "hide", value = FALSE)
    ),
    shiny::splitLayout(
      cellWidths = c("15%", "70%", "15%"),
      shiny::helpText("size:"),
      shiny::textInput(ns("label_size"), NULL),
      shiny::checkboxInput(ns("hide_legend_size"), "hide", value = FALSE)
    )
  )
}

Labels <- function(input, output, session) {
  ns <- session$ns

  values <- reactiveValues()
  observe({
    values$title <- input$title
    values$subtitle <- input$subtitle

    values$label_x <- input$label_x
    values$label_y <- input$label_y

    values$label_color <- input$label_color
    values$hide_legend_color <- input$hide_legend_color
    values$label_fill <- input$label_fill
    values$hide_legend_fill <- input$hide_legend_fill
    values$label_size <- input$label_size
    values$hide_legend_size <- input$hide_legend_size
  })
  return(values)
}
