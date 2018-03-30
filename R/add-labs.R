add_labs <- function(p, labels) {
  # validate inputs
  # req_inputs <- c("color", "fill", "size")
  # if (!all(req_inputs %in% names(labels)))
  #   stop("some required labels fields are missing")

  setting <- rlang::exprs()

  if (labels$label_x != "")
    setting <- append_exprs(setting, x = !!labels$label_x)
  if (labels$label_y != "")
    setting <- append_exprs(setting, y = !!labels$label_y)
  if (labels$label_color != "" && labels$hide_legend_color == FALSE)
    setting <- append_exprs(setting, color = !!labels$label_color)
  if (labels$label_fill != "" && labels$hide_legend_fill == FALSE)
    setting <- append_exprs(setting, fill = !!labels$label_fill)
  if (labels$label_size != "" && labels$hide_legend_size == FALSE)
    setting <- append_exprs(setting, size = !!labels$label_size)

  # compile expressions into layer
  if (length(setting) > 0)
    p <- p %++% labs(!!!setting)
  p
}
