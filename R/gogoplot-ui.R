
gogoplot_ui <- function() {
  miniUI::miniPage(
    miniUI::gadgetTitleBar("go-go plot!"),
    miniUI::miniTabstripPanel(
      plotTabPanel,
      codeTabPanel,
      dataTabPanel
    )
    # miniUI::miniButtonBlock(
    # shiny::actionButton('btn_update', 'Update Plot',
    #                     icon = shiny::icon('chart')),
    # shiny::actionButton('btn_plot', 'Return Plot',
    #                     icon = shiny::icon('chart')),
    #   shiny::actionButton('btn_code', 'Return Code',
    #                       icon = shiny::icon('keyboard-o')),
    #   shiny::downloadButton('btn_save', 'Save Plot'),
    #   border = 'top'
    # )
  )
}
