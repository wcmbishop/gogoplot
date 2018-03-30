add_geom_line <- function(p, fields, size, color, group) {
  # TODO - validate inputs

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

  # ALPHA
  if (color$alpha != 1)
    setting <- append_exprs(setting, alpha = !!as.numeric(color$alpha))

  # SIZE
  if (size$size_mapping_enabled) {
    if (size$size_map != CONST_NONE)
      mapping <- append_exprs(mapping, size = !!sym(size$size_map))
  } else {
    if (size$size_set != CONST_DEFAULT_LINE_SIZE)
      setting <- append_exprs(setting, size = !!as.numeric(size$size_set))
  }

  # GROUP
  if (!is.null(group$group_fields)) {
    if (length(group$group_fields) == 1) {
      # assign single-variable mapping
      mapping <- append_exprs(mapping, group = !!sym(group$group_fields))
    } else {
      # assign multi-variable mapping with `interaction`
      mapping <- append_exprs(mapping, group = interaction(!!!syms(as.list(group$group_fields))))
    }
  }

  # LINETYPE
  # TODO

  # compile expressions into layer
  if (length(mapping) > 0) {
    p <- p %++% geom_line(aes(!!!mapping), !!!setting)
  } else {
    p <- p %++% geom_line(!!!setting)
  }
  p
}
