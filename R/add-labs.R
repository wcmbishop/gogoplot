add_labs <- function(p, input) {
  # validate inputs
  req_inputs <- c("color")
  if (!all(req_inputs %in% names(input)))
    stop("some required input fields are missing")

  p <- p %++% labs(color = !!(input$color))
  p
}
