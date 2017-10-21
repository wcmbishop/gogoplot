add_geom_point <- function(p, input) {
  # validate inputs
  req_inputs <- c("alpha", "color_mapping_enabled",
                  "color_map", "color_set", "color_discrete",
                  "size_mapping_enabled", "size_map", "size_set")
  if (!all(req_inputs %in% names(input)))
    stop("some required input fields are missing")
  if (!is.logical(input$size_mapping_enabled))
    stop("size_mapping_enabled must be a logical value")
  if (!is.logical(input$color_mapping_enabled))
    stop("color_mapping_enabled must be a logical value")
  if (!is.logical(input$color_discrete))
    stop("color_discrete must be a logical value")


  # build up list of "mapping" and "setting" expressions
  # which will go into a ggplot2 layer at the end
  mapping <- rlang::exprs()
  setting <- rlang::exprs()

  # COLOR
  if (input$color_mapping_enabled) {
    if (input$color_map != CONST_NONE) {
      color_expr <- if_else_expr(input$color_discrete == TRUE,
                                 rlang::expr(as.factor(!!sym(input$color_map))),
                                 rlang::expr(!!sym(input$color_map)))
      mapping <- append_exprs(mapping, color = !!(color_expr))
    }
  } else {
    if (input$color_set != CONST_NONE)
      setting <- append_exprs(setting, color = !!input$color_set)
  }

  # ALPHA
  if (input$alpha != 1)
    setting <- append_exprs(setting, alpha = !!as.numeric(input$alpha))

  # SIZE
  if (input$size_mapping_enabled) {
    if (input$size_map != CONST_NONE)
      mapping <- append_exprs(mapping, size = !!sym(input$size_map))
  } else {
    if (input$size_set != 1.5)
      setting <- append_exprs(setting, size = !!as.numeric(input$size_set))
  }

  # compile expressions into layer
  if (length(mapping) > 0) {
    p <- p %++% geom_point(aes(!!!mapping), !!!setting)
  } else {
    p <- p %++% geom_point(!!!setting)
  }
  p
}
