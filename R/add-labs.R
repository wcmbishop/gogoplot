add_labs <- function(p, input) {
  # validate inputs
  req_inputs <- c("color_mapping_enabled", "color_map")
  if (!all(req_inputs %in% names(input)))
    stop("some required input fields are missing")

  setting <- rlang::exprs()

  if (input$plot_type == CONST_POINT) {
    if (input$color_mapping_enabled == TRUE && input$color_map != CONST_NONE)
      setting <- append_exprs(setting, color = !!input$color_map)
  } else if (input$plot_type == CONST_HISTOGRAM) {
    if (input$color_mapping_enabled == TRUE && input$color_map != CONST_NONE)
      setting <- append_exprs(setting, fill = !!input$color_map)
  }

  # compile expressions into layer
  if (length(setting) > 0)
    p <- p %++% labs(!!!setting)
  p
}
