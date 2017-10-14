
library(rlang)
library(ggplot2)

gogoplot(mtcars)



input <- list(
  xvar = "disp",
  yvar = "hp",
  color = "cyl",
  color_scale = 'discrete',
  alpha = 0.8,
  legend = TRUE,
  facet_row = "none",
  facet_col = "none",
  facet_label = TRUE
)

p <- new_gogoplot(ggplot(mtcars, aes(!!sym(input$xvar), !!sym(input$yvar))))
p
# geom_point
if (input$color == 'none') {
  p <- p %++% geom_point(alpha = rlang::UQ(input$alpha))
} else {
  if (input$color_scale == "discrete") {
    quo_color <- quo(as.factor(!!sym(input$color)))
  } else {
    quo_color <- quo(!!sym(input$color))
  }
  p <- p %++% geom_point(aes(color = rlang::UQE(quo_color)),
                         alpha = rlang::UQ(input$alpha))
}
p

# guides
if (input$legend == FALSE) {
  p <- p %++% guides(color = 'none')
} else {
  p <- p %++% labs(color = rlang::UQ(input$color))
}

# facets
if (any(c(input$facet_row, input$facet_col) != "none")) {
  if (input$facet_label == TRUE) {
    quo_facet_labeller <- quo(ggplot2::label_both)
  } else {
    quo_facet_labeller <- quo(ggplot2::label_value)
  }
  facet_row <- ifelse(input$facet_row == "none", ".", input$facet_row)
  facet_col <- ifelse(input$facet_col == "none", ".", input$facet_col)
  p <- p %++% facet_grid(!!sym(facet_row) ~ !!sym(facet_col),
                    labeller = rlang::UQE(quo_facet_labeller))
}

p
code_vec <- attr(p, "gogoplot")

cat(paste0(code_vec, collapse = " +\n  "))

p %++% geom_maybe_vline(xintercept = 200)

# ================
draw_ref_line <- TRUE
geom_maybe_vline <- if (draw_ref_line) geom_vline else geom_ignore

geom_ignore <- function(...) {
  NULL
}



