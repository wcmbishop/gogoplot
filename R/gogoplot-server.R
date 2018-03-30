
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
                  choices = c(CONST_POINT, CONST_HISTOGRAM, CONST_LINE,
                              CONST_BOXPLOT),
                  selected = CONST_POINT)
    })

    # create each geom module
    geom_point_module <- callModule(GeomPoint, "geom_point",
                                    var_choices = var_choices,
                                    data_name = data_name)
    geom_histogram_module <- callModule(GeomHistogram, "geom_histogram",
                                        var_choices = var_choices,
                                        data_name = data_name)
    geom_line_module <- callModule(GeomLine, "geom_line",
                                   var_choices = var_choices,
                                   data_name = data_name)
    geom_boxplot_module <- callModule(GeomBoxplot, "geom_boxplot",
                                      var_choices = var_choices,
                                      data_name = data_name)
    # high-level input modules
    labels <- callModule(Labels, "labels")
    theme <- callModule(Theme, "theme")

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

      # assign geom from the right module object
      if (input$plot_type == CONST_POINT) geom <- geom_point_module
      else if (input$plot_type == CONST_HISTOGRAM) geom <- geom_histogram_module
      else if (input$plot_type == CONST_LINE) geom <- geom_line_module
      else if (input$plot_type == CONST_BOXPLOT) geom <- geom_boxplot_module
      else geom <- NULL
      validate(need(!is.null(geom), "WARNING: invalid plot object"))

      p <- geom$plot()
      if (!is.null(geom$facets))
        p <- p %>% add_facet_grid(geom$facets)
      p <- p %>%
        add_guides(labels) %>%
        add_labs(labels) %>%
        add_ggtitle(labels) %>%
        add_theme(theme)
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

    # ---- update button ----
    shiny::observeEvent(input$btn_update, {
      # shinyjs::disable("btn_update")
      updateActionButton(session, "btn_update", label = "update plot")
    })
    # disable update if auto_plot turned on
    shiny::observeEvent(input$auto_plot, {
      if (input$auto_plot == T) {
        shinyjs::disable("btn_update")
        updateActionButton(session, "btn_update", label = "update plot")
      }
    })
    # indicate if plot is stale
    shiny::observeEvent(plot(), {
      if (input$auto_plot == T) {
        shinyjs::disable("btn_update")
        updateActionButton(session, "btn_update", label = "update plot")
      } else {
        shinyjs::enable("btn_update")
        updateActionButton(session, "btn_update", label = "update plot *")
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

