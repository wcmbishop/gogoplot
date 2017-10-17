
gogoplot_ui <- function() {
  miniUI::miniPage(
    miniUI::gadgetTitleBar("go-go plot!"),
    miniUI::miniTabstripPanel(
      plotTabPanel,
      codeTabPanel,
      dataTabPanel
    )
  )
}
