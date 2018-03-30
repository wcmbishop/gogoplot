add_ggtitle <- function(p, labels) {
  # validate inputs
  req_inputs <- c("title", "subtitle")
  if (!all(req_inputs %in% names(labels)))
    stop("some required labels fields are missing")

  setting <- rlang::exprs()

  if (labels$title != "")
    setting <- append_exprs(setting, label = !!labels$title)
  if (labels$subtitle != "")
    setting <- append_exprs(setting, subtitle = !!labels$subtitle)

  # compile expressions into layer
  if (length(setting) > 0)
    p <- p %++% ggtitle(!!!setting)
  p
}
