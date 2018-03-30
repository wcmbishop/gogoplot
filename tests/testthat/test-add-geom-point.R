context("add_geom_point")

p_blank <- new_gogoplot(ggplot(mtcars, aes(disp, hp)))
default_fields <- list()
default_color <- list(color_map = CONST_NONE, color_set = CONST_NONE,
                      color_discrete = FALSE, color_mapping_enabled = FALSE,
                      alpha = 1)
default_size <- list(size_mapping_enabled = FALSE,
                     size_set = 1.5, size_map = CONST_NONE)

test_that("default settings", {
  fields <- default_fields
  color <- default_color
  size <- default_size
  p <- add_geom_point(p_blank, fields, size, color)
  code <- get_plot_code(p)
  expect_is(p, "ggplot")
  expect_equal(length(code), 2)
  expect_equal(code[2], "geom_point()")
})

# ---- alpha ----

test_that("set alpha", {
  fields <- default_fields
  color <- default_color
  size <- default_size
  color$alpha <- 0.5
  p <- add_geom_point(p_blank, fields, size, color)
  code <- get_plot_code(p)
  expect_equal(code[2], "geom_point(alpha = 0.5)")
})

# ---- color ----

test_that("map color continuous", {
  fields <- default_fields
  color <- default_color
  size <- default_size
  color$color_mapping_enabled <- TRUE
  color$color_map <- "cyl"
  p <- add_geom_point(p_blank, fields, size, color)
  code <- get_plot_code(p)
  expect_equal(code[2], "geom_point(aes(color = cyl))")
})

test_that("map color discrete", {
  fields <- default_fields
  color <- default_color
  size <- default_size
  color$color_mapping_enabled <- TRUE
  color$color_map <- "cyl"
  color$color_discrete <- TRUE
  p <- add_geom_point(p_blank, fields, size, color)
  code <- get_plot_code(p)
  expect_equal(code[2], "geom_point(aes(color = as.factor(cyl)))")
})

test_that("set color", {
  fields <- default_fields
  color <- default_color
  size <- default_size
  color$color_set <- "blue"
  p <- add_geom_point(p_blank, fields, size, color)
  code <- get_plot_code(p)
  expect_equal(code[2], "geom_point(color = \"blue\")")
})

# ---- size ----

test_that("set size", {
  fields <- default_fields
  color <- default_color
  size <- default_size
  size$size_set = 4
  p <- add_geom_point(p_blank, fields, size, color)
  code <- get_plot_code(p)
  expect_equal(code[2], "geom_point(size = 4)")
})

test_that("map size", {
  fields <- default_fields
  color <- default_color
  size <- default_size
  size$size_mapping_enabled <- TRUE
  size$size_map <- "mpg"
  p <- add_geom_point(p_blank, fields, size, color)
  code <- get_plot_code(p)
  expect_equal(code[2], "geom_point(aes(size = mpg))")
})

# ---- bad inputs ----

test_that("missing input field", {
  fields <- default_fields
  color <- default_color
  size <- default_size
  color$color_map <- NULL
  expect_error(add_geom_point(p_blank, fields, size, color),
               "fields are missing")
})

test_that("bad color scale", {
  fields <- default_fields
  color <- default_color
  size <- default_size
  color$color_discrete <- "wrong"
  expect_error(add_geom_point(p_blank, fields, size, color),
               "color_discrete must be")
})

test_that("bad size type", {
  fields <- default_fields
  color <- default_color
  size <- default_size
  size$size_mapping_enabled <- "wrong"
  expect_error(add_geom_point(p_blank, fields, size, color),
               "size_mapping_enabled must be")
})
