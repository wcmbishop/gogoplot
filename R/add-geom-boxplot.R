add_geom_boxplot <- function(p, fields, color, fill) {
  # validate size inputs
  # TODO

  # build up list of "mapping" and "setting" expressions
  # which will go into a ggplot2 layer at the end
  mapping <- rlang::exprs()
  setting <- rlang::exprs()

  # COLOR
  if (color$color_mapping_enabled) {
    if (color$color_map != CONST_NONE) {
      color_expr <- if_else_expr(color$color_discrete == TRUE,
                                 rlang::expr(as.factor(!!sym(color$color_map))),
                                 rlang::expr(!!sym(color$color_map)))
      mapping <- append_exprs(mapping, color = !!(color_expr))
    }
  } else {
    if (color$color_set != CONST_NONE)
      setting <- append_exprs(setting, color = !!color$color_set)
  }

  # FILL
  if (fill$fill_mapping_enabled) {
    if (fill$fill_map != CONST_NONE) {
      fill_expr <- if_else_expr(fill$fill_discrete == TRUE,
                                rlang::expr(as.factor(!!sym(fill$fill_map))),
                                rlang::expr(!!sym(fill$fill_map)))
      mapping <- append_exprs(mapping, fill = !!(fill_expr))
    }
  } else {
    if (fill$fill_set != CONST_NONE)
      setting <- append_exprs(setting, fill = !!fill$fill_set)
  }

  # ALPHA
  if (fill$alpha != 1)
    setting <- append_exprs(setting, alpha = !!as.numeric(fill$alpha))

  # compile expressions into layer
  if (length(mapping) > 0) {
    p <- p %++% geom_boxplot(aes(!!!mapping), !!!setting)
  } else {
    p <- p %++% geom_boxplot(!!!setting)
  }
  p
}
