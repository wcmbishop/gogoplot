#' Add a plot layer and capture plot code
#'
#' \code{%++%} is the key to constructing "code tracked" plot objects.
#' It adds a new plotting layer to an existing plot (the traditional
#' goal of the \pkg{ggplot2} \code{+} method), and it also captures the
#' code for that new layer in a new attribute "gogoplot". This attribute
#' is a character vector that captures the plot layers as code strings.
#'
#' @param e1 an existing ggplot2 plot object
#' @param e2 a new plot layer to add
#'
#' @return an updated plot object
#' @export
#'
`%++%` <- function(e1, e2) {
  quo_layer <- rlang::enquo(e2)
  p <- e1 + rlang::eval_tidy(quo_layer)
  # add code string to "gogoplot" attribute
  attr(p, "gogoplot") <- c(attr(p, "gogoplot"),
                           rlang::quo_text(quo_layer, width = 200L))
  p
}


new_gogoplot <- function(new_layer) {
  quo_layer <- rlang::enquo(new_layer)
  p <- rlang::eval_tidy(quo_layer)
  attr(p, "gogoplot") <- rlang::quo_text(quo_layer, width = 200L)
  p
}
