add_guides <- function(p, input) {
  # validate inputs
  req_inputs <- c("color")
  if (!all(req_inputs %in% names(input)))
    stop("some required input fields are missing")

  if (input$legend == FALSE) {
    p <- p %++% guides(color = "none")
  }
  p
}
