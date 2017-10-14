
scatterTabPanel <- miniUI::miniTabPanel(
  'scatter',
  icon = shiny::icon('ellipsis-h'),
  miniUI::miniContentPanel(
    padding = 10,
    shiny::fillRow(
      flex = c(NA, 1),
      shiny::fillCol(
        flex = c(1, NA),
        width = 120,
        shiny::fillCol(
          flex = c(NA),
          shiny::radioButtons(
            "config",
            label = "Configure...",
            choices = c("fields", "color", "size", "facets", "scales"),
            selected = "fields"
          ),
          shiny::conditionalPanel(
            "input.config == 'fields'",
            shiny::helpText(shiny::strong('FIELDS')),
            shiny::uiOutput("xvar"),
            shiny::uiOutput("yvar")
          ),
          shiny::conditionalPanel(
            "input.config == 'color'",
            shiny::helpText(shiny::strong('COLOR')),
            shiny::uiOutput("color"),
            shiny::checkboxInput('legend', 'show legend', value = TRUE),
            shiny::radioButtons(
              'color_scale',
              NULL,
              choices = c('discrete', 'continuous'),
              selected = 'continuous'
            ),
            shiny::uiOutput("alpha")
          ),
          shiny::conditionalPanel(
            "input.config == 'size'",
            shiny::helpText(shiny::strong('SIZE')),
            shiny::radioButtons(
              'size_type',
              NULL,
              choices = c('set', 'map'),
              selected = 'set'
            ),
            shiny::conditionalPanel("input.size_type == 'set'",
                                    shiny::uiOutput("size_set")),
            shiny::conditionalPanel("input.size_type == 'map'",
                                    shiny::uiOutput("size_map"))
          ),
          shiny::conditionalPanel(
            "input.config == 'facets'",
            shiny::helpText(shiny::strong('FACET')),
            shiny::uiOutput("facet_row"),
            shiny::uiOutput("facet_col"),
            shiny::checkboxInput('facet_label', 'show field label',
                                 value = TRUE)
            ),
          shiny::conditionalPanel(
            "input.config == 'scales'",
            shiny::helpText(shiny::strong('SCALES')),
            shiny::helpText("coming soon.")
            )
          ),
        shiny::fillCol(
          flex = c(NA),
          shiny::checkboxInput('auto_plot', 'auto-update',
                               value = TRUE))),
      miniUI::miniContentPanel(
        padding = 0,
        shiny::plotOutput("plot_display", height = "100%")
      )
    )
  )
)
