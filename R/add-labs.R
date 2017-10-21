add_labs <- function(p, input) {
  # validate inputs
  req_inputs <- c("color_mapping_enabled", "color_map")
  if (!all(req_inputs %in% names(input)))
    stop("some required input fields are missing")

  if (input$color_mapping_enabled == TRUE && input$color_map != CONST_NONE)
    p <- p %++% labs(color = !!(input$color_map))
  p
}
