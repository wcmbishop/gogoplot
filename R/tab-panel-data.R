dataTabPanel <- miniUI::miniTabPanel(
  'data',
  icon = shiny::icon('database'),
  miniUI::miniContentPanel(padding = 5,
                           shiny::dataTableOutput('data_table'))
)
