context("add_geom_point")

p_blank <- new_gogoplot(ggplot(mtcars, aes(disp, hp)))
default_input <- list(color_map = CONST_NONE, color_set = CONST_NONE,
                      color_discrete = FALSE, color_mapping_enabled = FALSE,
                      alpha = 1, size_mapping_enabled = FALSE,
                      size_set = 1.5, size_map = CONST_NONE)

test_that("default settings", {
  input <- default_input
  p <- add_geom_point(p_blank, input)
  code <- get_plot_code(p)
  expect_is(p, "ggplot")
  expect_equal(length(code), 2)
  expect_equal(code[2], "geom_point()")
})

# ---- alpha ----

test_that("set alpha", {
  input <- default_input
  input$alpha <- 0.5
  p <- add_geom_point(p_blank, input)
  code <- get_plot_code(p)
  expect_equal(code[2], "geom_point(alpha = 0.5)")
})

# ---- color ----

test_that("map color continuous", {
  input <- default_input
  input$color_mapping_enabled <- TRUE
  input$color_map <- "cyl"
  p <- add_geom_point(p_blank, input)
  code <- get_plot_code(p)
  expect_equal(code[2], "geom_point(aes(color = cyl))")
})

test_that("map color discrete", {
  input <- default_input
  input$color_mapping_enabled <- TRUE
  input$color_map <- "cyl"
  input$color_discrete <- TRUE
  p <- add_geom_point(p_blank, input)
  code <- get_plot_code(p)
  expect_equal(code[2], "geom_point(aes(color = as.factor(cyl)))")
})

test_that("set color", {
  input <- default_input
  input$color_set <- "blue"
  p <- add_geom_point(p_blank, input)
  code <- get_plot_code(p)
  expect_equal(code[2], "geom_point(color = \"blue\")")
})

# ---- size ----

test_that("set size", {
  input <- default_input
  input$size_set = 4
  p <- add_geom_point(p_blank, input)
  code <- get_plot_code(p)
  expect_equal(code[2], "geom_point(size = 4)")
})

test_that("map size", {
  input <- default_input
  input$size_mapping_enabled <- TRUE
  input$size_map <- "mpg"
  p <- add_geom_point(p_blank, input)
  code <- get_plot_code(p)
  expect_equal(code[2], "geom_point(aes(size = mpg))")
})

# ---- bade inputs ----

test_that("missing input field", {
  input <- default_input
  input$color_map <- NULL
  expect_error(add_geom_point(p_blank, input), "fields are missing")
})

test_that("bad color scale", {
  input <- default_input
  input$color_discrete <- "wrong"
  expect_error(add_geom_point(p_blank, input), "color_discrete must be")
})

test_that("bad size type", {
  input <- default_input
  input$size_mapping_enabled <- "wrong"
  expect_error(add_geom_point(p_blank, input), "size_mapping_enabled must be")
})
