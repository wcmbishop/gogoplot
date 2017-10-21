## gogoplot 0.1.2

* UI has been updated to focus solely on creating plots and returning plot code
    * removed "data" tab (and tabs completely)
    * added ability to show plot code above the plot
    * updated options for gadget viewing to try to make sure the gadget window is large enough
* added more complete support for "histogram" plot type
* various backend updates (e.g. added tests for internal plotting functions)


-------------
## gogoplot 0.1.1
Big improvements!

Visible changes:
* main function `plot_gadget()` renamed to `gogoplot()`
* added configuration for point size (either "setting" or "mapping")
* added variable types to column selector drop-downs - e.g. "cyl (num)"

Under-the-hood changes:
* made added `%++%` function that adds a plot layer and captures plot code
  * this makes the method of returning plot code scalable and safe!
  * plot code is captured as a character vector stored in the plot object attribute "gogoplot"
* lots of refactoring of miniUI elements and plot building into separate functions - e.g. `add_geom_point(p, input)`


-------------
## gogoplot 0.1

Initial release!
