get_plot_code <- function(p) {
  if (!inherits(p, "ggplot"))
    stop("input must be a ggplot2 object")
  attr(p, "gogoplot")
}
