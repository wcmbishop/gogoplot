# gogoplot.R

#' @title Interactively build a plot.
#' @description Launch an interactive shiny gadget that lets you
#' build a \pkg{ggplot2} plot from the given data. This function is also
#' callable using an RStudio Addin -- you can high-light a data-frame
#' object and select the "gogoplot" addin.
#'
#' @param .data  a data-frame to visualize
#' @param popup  logical value to display the UI as a pop-up window.
#'               The default is FALSE, which will show the UI in
#'               the Viewer pane.
#' @param width  width of the pop-up window, in pixels.
#' @param height height of the pop-up window, in pixels.
#'
#' @return When using RStudio, the generated plot code is inserted at your
#' cursor using the \pkg{rstudioapi} \code{\link[rstudioapi]{insertText}}
#' function. Outside of RStudio, the code is printed as a message.
#' Plot code is also invisibly returned as a string, if you want
#' to capture the return object.
#'
#' @examples
#' \dontrun{
#' library(ggplot2)
#' library(gogoplot)
#' gogoplot(mtcars)
#' }
#'
#' @export
gogoplot <- function(.data, popup = FALSE, width = 900, height = 800) {
  if (!inherits(.data, "data.frame"))
    stop(".data must be a data-frame.")

  # capture name of passed .data object
  data_name <- deparse(substitute(.data))

  ui <- gogoplot_ui(data_name)
  server <- gogoplot_server(.data, data_name)

  # select viewer
  if (popup) {
    viewer = shiny::dialogViewer("GoGoPlot", width = width, height = height)
  } else {
    viewer = shiny::paneViewer(minHeight = 800)
  }

  shiny::runGadget(app = ui,
                   server = server,
                   viewer = viewer,
                   stopOnCancel = FALSE)
}
