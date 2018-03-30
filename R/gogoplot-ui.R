
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
          flex = c(1, NA, NA),
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
          shiny::fillRow(
            height = 120,
            shiny::fillPage(
              tags$hr(),
              shiny::fillRow(
                height = 40,
                shinyWidgets::dropdownButton(
                  LabelsInput("labels"), circle = TRUE, status = "primary",
                  size = "sm", width = "400px", label = "labels", up = TRUE,
                  icon = icon("tag"),
                  tooltip = shinyWidgets::tooltipOptions(title = "Set labels...")
                  ),
                shiny::helpText("labels")),
              # shiny::fillRow(
              #   height = 40,
              #   shinyWidgets::dropdownButton(
              #     helpText("to-do..."), circle = TRUE, status = "primary",
              #     size = "sm", width = "400px", label = "scales", up = TRUE,
              #     icon = icon("balance-scale"),
              #     tooltip = shinyWidgets::tooltipOptions(title = "Set scales...")
              #   ),
              #   shiny::helpText("scales")),
              shiny::fillRow(
                height = 40,
                shinyWidgets::dropdownButton(
                  ThemeInput("theme"), circle = TRUE, status = "primary",
                  size = "sm", width = "400px", label = "theme", up = TRUE,
                  icon = icon("gg"),
                  tooltip = shinyWidgets::tooltipOptions(title = "Set theme...")
                ),
                shiny::helpText("theme"))
            )
          ),
          shiny::fillRow(
            height = 120,
            shiny::fillPage(
              shiny::checkboxInput("show_code", "show code",
                                   value = FALSE),
              shiny::checkboxInput("auto_plot", "auto-update",
                                   value = TRUE),
              shinyjs::disabled(shiny::actionButton("btn_update", "update plot"))
            )
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
