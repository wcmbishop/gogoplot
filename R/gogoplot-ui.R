
gogoplot_ui <- function(data_name) {
  miniUI::miniPage(
    shinyjs::useShinyjs(),
    miniUI::gadgetTitleBar(data_name),
    miniUI::miniContentPanel(
      padding = 8,
      scrollable = FALSE,
      shiny::fillRow(
        flex = c(NA, 1),
        shiny::fillCol(
          flex = c(1, NA),
          width = 120,
          shiny::fillPage(
            shiny::uiOutput("plot_type"),
            # display correct plot config
            shiny::conditionalPanel(sprintf("input.plot_type == '%s'", CONST_POINT),
                                    GeomPointInput("geom_point")),
            shiny::conditionalPanel(sprintf("input.plot_type == '%s'", CONST_HISTOGRAM),
                                    GeomHistogramInput("geom_histogram")),
            shiny::conditionalPanel(sprintf("input.plot_type == '%s'", CONST_LINE),
                                    GeomLineInput("geom_line")),
            shiny::conditionalPanel(sprintf("input.plot_type == '%s'", CONST_BOXPLOT),
                                    GeomBoxplotInput("geom_boxplot"))
          ),
          shiny::fillPage(
            tags$hr(),
            shinyWidgets::dropdownButton(
              LabelsInput("labels"), circle = TRUE, status = "primary",
              size = "xs", width = "400px", label = "labels", up = TRUE,
              icon = icon("tag"),
              tooltip = shinyWidgets::tooltipOptions(title = "Set labels...")
            ),
            shiny::checkboxInput("show_code", "show code",
                                 value = FALSE),
            shiny::checkboxInput("auto_plot", "auto-update",
                                 value = TRUE),
            shinyjs::disabled(shiny::actionButton("btn_update", "update plot"))
          )
        ),
        miniUI::miniContentPanel(
          padding = 5,
          shiny::fillCol(
            flex = c(NA, 1),
            shiny::conditionalPanel(
              "input.show_code == true",
              shiny::verbatimTextOutput("render_code_text")
            ),
            shiny::plotOutput("plot_display", height = "100%")
            )
          )
      )
    )
  )
}
