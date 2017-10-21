
gogoplot_server <- function(.data, data_name) {

  # create a data-object with the same name as the .data input
  # NOTE: this is created here so it is available in the environment
  #       of the returned server function
  assign(data_name, .data)

  function(input, output, session) {

    # ---- render UI ----
    var_choices <- select_choices(.data)
    output$plot_type <- shiny::renderUI({
      selectInput("plot_type", "Plot Type:",
                  choices = c(CONST_POINT, CONST_HISTOGRAM),
                  selected = CONST_POINT)
    })
    output$xvar <- shiny::renderUI({
      selectInput("xvar", "x variable:",
                  choices = var_choices, selected = CONST_NONE)
    })
    output$yvar <- shiny::renderUI({
      selectInput("yvar", "y variable:",
                  choices = var_choices, selected = CONST_NONE)
    })
    output$color_map <- shiny::renderUI({
      selectInput("color_map", "color mapping:",
                  choices = var_choices, selected = CONST_NONE)
    })
    output$color_set <- shiny::renderUI({
      selectInput("color_set", "color setting:",
                  choices = c(CONST_NONE, "red", "orange", "yellow", "green",
                              "blue", "purple"),
                  selected = CONST_NONE)
    })
    output$color_discrete <- shiny::renderUI({
      shiny::checkboxInput('color_discrete', 'force discrete', value = FALSE)
    })
    output$alpha <- shiny::renderUI({
      sliderInput("alpha", "alpha:",
                  min = 0, max = 1, value = 1, step = 0.1)
    })
    output$facet_row <- shiny::renderUI({
      selectInput("facet_row", "facet rows:",
                  choices = var_choices, selected = CONST_NONE)
    })
    output$facet_col <- shiny::renderUI({
      selectInput("facet_col", "facet cols:",
                  choices = var_choices, selected = CONST_NONE)
    })
    output$size_set <- shiny::renderUI({
      sliderInput("size_set", "size setting:",
                  min = 1, max = 6, value = 1.5, step = 0.5)
    })
    output$size_map <- shiny::renderUI({
      selectInput("size_map", "size mapping:",
                  choices = var_choices, selected = CONST_NONE)
    })

    # ---- plot_display ----
    output$plot_display <- shiny::renderPlot({
      if (input$auto_plot == TRUE) {
        plot <- plot()
      } else {
        input$btn_update
        plot <- isolate(plot())
      }
      plot
    })

    # ---- plot ----
    plot <- shiny::reactive({
      validate(need(input$plot_type, "  Select a plot type"))
      validate_plot_inputs(input)

      # build plot
      p <- base_plot(data_name, input)
      p <- p %>%
        add_facet_grid(input) %>%
        # add_guides(input) %>%
        add_labs(input) %>%
        add_theme(input)
      p
    })

    # ---- plot_code ----
    plot_code <- shiny::reactive({
      get_plot_code(plot())
    })

    # ---- render_code ----
    output$render_code_html <- shiny::renderText({
      code <- paste0(
        "<code>",
        paste0(plot_code(), collapse = " +<br>&nbsp;&nbsp;&nbsp;&nbsp;"),
        "</code>"
        )
      code
    })

    output$render_code_text <- shiny::renderText({
      paste0(plot_code(), collapse = " +\n  ")
    })

    # ---- data_table ----
    output$data_table <- shiny::renderDataTable({
      .data
    }, options = list(pageLength = 5))
    output$data_table_header <- shiny::renderText({
      header <- shiny::tags$h3(sprintf("%s: %i x %i", data_name,
                                       nrow(.data), ncol(.data)))
      header <- paste(header)
      header
    })

    # ---- update button ----
    shiny::observeEvent(input$btn_update, {
      updateCheckboxInput(session, 'auto_plot', label = 'auto-update')
    })
    # indicate if plot is stale
    shiny::observeEvent(plot(), {
      if (input$auto_plot == T) {
        updateCheckboxInput(session, 'auto_plot', label = 'auto-update')
      } else {
        updateCheckboxInput(session, 'auto_plot', label = 'auto-update (*)')
      }
    })

    # ---- done button ----
    shiny::observeEvent(input$done, {
      code_str <- paste0(plot_code(), collapse = " +\n  ")
      # print(plot())
      if (rstudioapi::isAvailable()) {
        rstudioapi::insertText(text = code_str)
        shiny::stopApp(invisible(code_str))
      } else{
        message(cat(cod_str))
        shiny::stopApp(invisible(code_str))
      }
    })

    # ---- cancel button ----
    shiny::observeEvent(input$cancel, {
      shiny::stopApp()
    })

  }
}
