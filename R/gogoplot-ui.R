
gogoplot_ui <- function(data_name) {
  miniUI::miniPage(
    miniUI::gadgetTitleBar(data_name),
    miniUI::miniTabstripPanel(
      plotTabPanel,
      # codeTabPanel,
      dataTabPanel
    )
  )
}
