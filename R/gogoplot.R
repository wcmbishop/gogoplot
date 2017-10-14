# gogoplot.R

#' @title Interactively build a plot.
#' @description Launch an interactive shiny gadget that lets you
#' build a \pkg{ggplot2} plot from the given data.
#'
#' @param .data  a data-frame to visualize
#' @param popup  logical value to display the UI as a pop-up window.
#'               The default is FALSE, which will show the UI in
#'               the Viewer pane.
#'
#' @return the UI supports different return objects:
#' \itemize{
#'    \item Return Plot - returns a \pkg{ggplot2} plot object
#'    \item Return Code - returns a character vector of the plotting code. If
#'    you're using RStudio, this will insert the code at your cursor using the
#'    \pkg{rstudioapi} \code{\link[rstudioapi]{insertText}} function.
#' }
#'
#' @examples
#' \dontrun{
#' library(gogoplot)
#' gogoplot(mtcars)
#' }
#'
#' @import ggplot2 shiny
#' @importFrom rlang !! sym UQ UQE quo enquo
#' @export
gogoplot <- function(.data, popup = FALSE) {
  if (!inherits(.data, "data.frame"))
    stop(".data must be a data-frame.")

  # capture name of passed .data object
  data_name <- deparse(substitute(.data))

  ui <- gogoplot_ui()
  server <- gogoplot_server(.data, data_name)

  # select viewer
  if (popup) {
    viewer = shiny::dialogViewer("GoGoPlot", width = 900, heigh = 800)
  } else {
    viewer = shiny::paneViewer()
  }
  shiny::runGadget(app = ui,
                   server = server,
                   viewer = viewer)
}

