validate_plot_inputs <- function(input) {
  if (input$plot_type == CONST_POINT) validate_point(input)
  else if (input$plot_type == CONST_HISTOGRAM) validate_histogram(input)
  else stop("unexpected plot_type")
}

validate_point <- function(input) {
  validate(
    need(input$xvar, "  Select an x variable."),
    need(input$yvar, "  Select a y variable."),
    need(input$xvar != CONST_NONE, "  Select an x variable."),
    need(input$yvar != CONST_NONE, "  Select a y variable.")
  )
}

validate_histogram <- function(input) {
  validate(
    need(input$xvar, "  Select an x variable."),
    need(input$xvar != CONST_NONE, "  Select an x variable.")
  )
}
