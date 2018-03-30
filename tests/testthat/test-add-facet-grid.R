context("add_facet_grid")

p_blank <- new_gogoplot(ggplot(mtcars, aes(disp, hp)))
default_input <- list(facet_row = CONST_NONE,
                      facet_col = CONST_NONE,
                      facet_label = FALSE)

test_that("default settings", {
  input <- default_input
  p <- add_facet_grid(p_blank, input)
  code <- get_plot_code(p)
  expect_is(p, "ggplot")
  expect_equal(length(code), 1)
})

test_that("facet row", {
  input <- default_input
  input$facet_row <- "cyl"
  p <- add_facet_grid(p_blank, input)
  code <- get_plot_code(p)
  expect_equal(length(code), 2)
  expect_equal(code[2], "facet_grid(cyl ~ .)")
})

test_that("facet col", {
  input <- default_input
  input$facet_col <- "gear"
  p <- add_facet_grid(p_blank, input)
  code <- get_plot_code(p)
  expect_equal(length(code), 2)
  expect_equal(code[2], "facet_grid(. ~ gear)")
})

test_that("facet row and col", {
  input <- default_input
  input$facet_row <- "cyl"
  input$facet_col <- "gear"
  p <- add_facet_grid(p_blank, input)
  code <- get_plot_code(p)
  expect_equal(length(code), 2)
  expect_equal(code[2], "facet_grid(cyl ~ gear)")
})

test_that("facet labeller", {
  input <- default_input
  input$facet_row <- "cyl"
  input$facet_label <- TRUE
  p <- add_facet_grid(p_blank, input)
  code <- get_plot_code(p)
  expect_equal(length(code), 2)
  expect_equal(code[2], "facet_grid(cyl ~ ., labeller = label_both)")
})

test_that("missing input", {
  input <- default_input
  input$facet_row <- NULL
  expect_error(add_facet_grid(p_blank, input), "fields are missing")
})
