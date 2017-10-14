
gogoplot_server <- function(.data, data_name) {

  # create a data-object with the same name as the .data input
  # NOTE: this is created here so it is available in the environment
  #       of the returned server function
  assign(data_name, .data)

  function(input, output, session) {

    # dynamic UI input elements
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    output$xvar <- shiny::renderUI({
      selectInput("xvar", "x variable:",
                  choices = c('choose...', names(.data)), selected='choose...')
    })
    output$yvar <- shiny::renderUI({
      selectInput("yvar", "y variable:",
                  choices = c('choose...', names(.data)), selected='choose...')
    })
    output$color <- shiny::renderUI({
      selectInput("color", NULL,
                  choices = c('none', names(.data)), selected='choose...')
    })
    output$alpha <- shiny::renderUI({
      sliderInput("alpha", "alpha",
                  min = 0, max = 1, value = 1, step = 0.1)
    })
    output$facet_row <- shiny::renderUI({
      selectInput("facet_row", "facet rows:",
                  choices = c('none', names(.data)), selected='choose...')
    })
    output$facet_col <- shiny::renderUI({
      selectInput("facet_col", "facet cols:",
                  choices = c('none', names(.data)), selected='choose...')
    })

    # Render the plot
    output$plot_display <- shiny::renderPlot({
      if (input$auto_plot == TRUE) {
        plot <- plot()
      } else {
        input$btn_update
        plot <- isolate(plot())
      }
      plot
    })

    plot <- shiny::reactive({
      validate(
        need(input$xvar, 'Select an x variable.'),
        need(input$yvar, 'Select a y variable.'),
        need(input$xvar != 'choose...', 'Select an x variable.'),
        need(input$yvar != 'choose...', 'Select a y variable.')
      )

      # empty plot object
      p <- new_gogoplot(ggplot(!!sym(data_name),
                               aes(!!sym(input$xvar), !!sym(input$yvar))))

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
    })

    # ---- plot_code ----
    plot_code <- shiny::reactive({
      attr(plot(), "gogoplot")
    })

    output$data_table <- shiny::renderDataTable({
      .data
    }, options = list(pageLength = 5))

    # indicate if plot is stale
    shiny::observeEvent(plot(), {
      if (input$auto_plot == T) {
        updateCheckboxInput(session, 'auto_plot', label = 'auto-update')
      } else {
        updateCheckboxInput(session, 'auto_plot', label = 'auto-update (*)')
      }
    })
    shiny::observeEvent(input$btn_update, {
      updateCheckboxInput(session, 'auto_plot', label = 'auto-update')
    })

    # buttons
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~

    # return Code
    shiny::observeEvent(input$btn_code, {
      code_str <- paste0(plot_code(), collapse = " +\n  ")
      # return function call
      if(rstudioapi::isAvailable()){
        rstudioapi::insertText(text = code_str)
        shiny::stopApp()
      } else{
        shiny::stopApp(code_str)
      }
    })

    # return Plot object
    shiny::observeEvent(input$btn_plot, {
      shiny::stopApp(plot())
    })

    # download plot image
    output$btn_save <- downloadHandler(
      filename = function() {
        paste0(Sys.Date(), '-plot.png')
      },
      content = function(con) {
        ggsave(con, output$plot, device = 'png')
      }
    )
  }
}
