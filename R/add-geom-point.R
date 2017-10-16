add_geom_point <- function(p, input) {
  # validate inputs
  req_inputs <- c("alpha", "color", "color_scale",
                  "size_type", "size_map", "size_set")
  if (!all(req_inputs %in% names(input)))
    stop("some required input fields are missing")
  if (!(input$size_type %in% c("map", "set")))
    stop("size_type must be either 'map' or 'set'")
  if (!(input$color_scale %in% c("discrete", "continuous")))
    stop("color_scale must be either 'discrete' or 'continuous'")


  # build up list of "mapping" and "setting" expressions
  # which will go into a ggplot2 layer at the end
  mapping <- rlang::exprs()
  setting <- rlang::exprs()

  # COLOR
  if (input$color != CONST_NONE) {
    if_else_expr(input$color_scale == "discrete",
                 rlang::expr(as.factor(!!sym(input$color))),
                 rlang::expr(!!sym(input$color)))
    mapping <- append_exprs(mapping, color = !!(color_expr))
  }

  # ALPHA
  setting <- append_exprs(setting, alpha = !!input$alpha)

  # SIZE
  if (input$size_type == "set") {
    setting <- append_exprs(setting, size = !!input$size_set)
  } else if (input$size_map != CONST_NONE) {
    mapping <- append_exprs(mapping, size = !!sym(input$size_map))
  }

  # compile expressions into layer
  p <- p %++% geom_point(aes(!!!mapping), !!!setting)
  p
}
