add_geom_point <- function(p, input) {
  # validate inputs
  req_inputs <- c("alpha", "color", "color_scale",
                  "size_mappping_enabled", "size_map", "size_set")
  if (!all(req_inputs %in% names(input)))
    stop("some required input fields are missing")
  if (!is.logical(input$size_mappping_enabled))
    stop("size_mappping_enabled must be a logical value")
  if (!(input$color_scale %in% c("discrete", "continuous")))
    stop("color_scale must be either 'discrete' or 'continuous'")


  # build up list of "mapping" and "setting" expressions
  # which will go into a ggplot2 layer at the end
  mapping <- rlang::exprs()
  setting <- rlang::exprs()

  # COLOR
  if (input$color != CONST_NONE) {
    color_expr <- if_else_expr(input$color_scale == "discrete",
                               rlang::expr(as.factor(!!sym(input$color))),
                               rlang::expr(!!sym(input$color)))
    mapping <- append_exprs(mapping, color = !!(color_expr))
  }

  # ALPHA
  if (input$alpha != 1)
    setting <- append_exprs(setting, alpha = !!as.numeric(input$alpha))

  # SIZE
  if (input$size_mappping_enabled) {
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
