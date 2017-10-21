context("add_geom_histogram")

p_blank <- new_gogoplot(ggplot(mtcars, aes(disp)))
default_input <- list(color_map = CONST_NONE, color_set = CONST_NONE,
                      color_discrete = FALSE, color_mapping_enabled = FALSE,
                      alpha = 1, bins = 30, binwidth = NA_real_)

test_that("default settings", {
  input <- default_input
  p <- add_geom_histogram(p_blank, input)
  code <- get_plot_code(p)
  expect_is(p, "ggplot")
  expect_equal(length(code), 2)
  expect_equal(code[2], "geom_histogram()")
})

# ---- alpha ----

test_that("set alpha", {
  input <- default_input
  input$alpha <- 0.5
  p <- add_geom_histogram(p_blank, input)
  code <- get_plot_code(p)
  expect_equal(code[2], "geom_histogram(alpha = 0.5)")
})

# ---- color ----

test_that("map color continuous", {
  input <- default_input
  input$color_mapping_enabled <- TRUE
  input$color_map <- "cyl"
  p <- add_geom_histogram(p_blank, input)
  code <- get_plot_code(p)
  expect_equal(code[2], "geom_histogram(aes(fill = cyl))")
})

test_that("map color discrete", {
  input <- default_input
  input$color_mapping_enabled <- TRUE
  input$color_map <- "cyl"
  input$color_discrete <- TRUE
  p <- add_geom_histogram(p_blank, input)
  code <- get_plot_code(p)
  expect_equal(code[2], "geom_histogram(aes(fill = as.factor(cyl)))")
})

test_that("set color", {
  input <- default_input
  input$color_set <- "blue"
  p <- add_geom_histogram(p_blank, input)
  code <- get_plot_code(p)
  expect_equal(code[2], "geom_histogram(fill = \"blue\")")
})

# ---- size ----

test_that("set bins", {
  input <- default_input
  input$bins = 40
  p <- add_geom_histogram(p_blank, input)
  code <- get_plot_code(p)
  expect_equal(code[2], "geom_histogram(bins = 40)")
})

test_that("set binwidth", {
  input <- default_input
  input$binwidth = 10
  p <- add_geom_histogram(p_blank, input)
  code <- get_plot_code(p)
  expect_equal(code[2], "geom_histogram(binwidth = 10)")
})

# ---- bade inputs ----

test_that("missing input field", {
  input <- default_input
  input$color_map <- NULL
  expect_error(add_geom_histogram(p_blank, input), "fields are missing")
})

