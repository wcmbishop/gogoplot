base_plot <- function(data_name, input) {
  if (input$plot_type == CONST_POINT) {
    p <- new_gogoplot(ggplot(!!sym(data_name),
                             aes(!!sym(input$xvar), !!sym(input$yvar)))) %>%
      add_geom_point(input)

  } else if (input$plot_type == CONST_HISTOGRAM) {
    validate_histogram(input)
    p <- new_gogoplot(ggplot(!!sym(data_name), aes(!!sym(input$xvar)))) %>%
      add_geom_histogram(input)

  } else {
    stop("unexpected plot_type")
  }
  p
}
