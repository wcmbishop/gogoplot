context("new_ggplot")


test_that("blank plot", {
  data_name <- "mtcars"
  input <- list(xvar = "disp", yvar = "hp")
  p_blank <- new_gogoplot(ggplot(!!sym(data_name), aes(!!sym(input$xvar),
                                                       !!sym(input$yvar))))
  code <- get_plot_code(p_blank)
  expect_is(p_blank, "ggplot")
  expect_equal(length(code), 1)
  expect_equal(code[1], "ggplot(mtcars, aes(disp, hp))")
})

