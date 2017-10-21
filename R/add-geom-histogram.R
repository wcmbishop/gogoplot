add_geom_histogram <- function(p, input) {
  # validate inputs
  req_inputs <- c("alpha", "bins", "binwidth",
                  "color_mapping_enabled", "color_map", "color_set")
  if (!all(req_inputs %in% names(input)))
    stop("some required input fields are missing")
  if (!is.logical(input$color_mapping_enabled))
    stop("color_mapping_enabled must be a logical value")

  mapping <- rlang::exprs()
  setting <- rlang::exprs()

  # COLOR
  if (input$color_mapping_enabled) {
    if (input$color_map != CONST_NONE) {
      color_expr <- if_else_expr(input$color_discrete == TRUE,
                                 rlang::expr(as.factor(!!sym(input$color_map))),
                                 rlang::expr(!!sym(input$color_map)))
      mapping <- append_exprs(mapping, fill = !!(color_expr))
    }
  } else {
    if (input$color_set != CONST_NONE)
      setting <- append_exprs(setting, fill = !!input$color_set)
  }

  # ALPHA
  if (input$alpha != 1)
    setting <- append_exprs(setting, alpha = !!as.numeric(input$alpha))

  # SIZE
  if (is.na(input$binwidth)) {
    if (input$bins != 30)
      setting <- append_exprs(setting, bins = !!as.numeric(round(input$bins)))
  } else {
    setting <- append_exprs(setting, binwidth = !!input$binwidth)
  }

  # compile expressions into layer
  if (length(mapping) > 0) {
    p <- p %++% geom_histogram(aes(!!!mapping), !!!setting)
  } else {
    p <- p %++% geom_histogram(!!!setting)
  }
  p
}
