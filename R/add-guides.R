add_guides <- function(p, labels) {
  # validate inputs
  # TODO

  setting <- rlang::exprs()

  if (labels$hide_legend_color)
    setting <- append_exprs(setting, color = "none")
  if (labels$hide_legend_fill)
    setting <- append_exprs(setting, fill = "none")
  if (labels$hide_legend_size)
    setting <- append_exprs(setting, size = "none")

  # compile expressions into layer
  if (length(setting) > 0)
    p <- p %++% guides(!!!setting)
  p
}
