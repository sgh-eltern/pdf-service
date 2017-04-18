# TODOs

* GET requests always need to go through the form so that the user can customize it.
* The URL for POST request have the URL of the form with all query parameters filled in, so that bookmarking the URL will create a URL that points to the form and not the POST result.
* More tests with missing params etc.
* 401 page (no or wrong password) should show some text why auth is required
* Expose options in form:
  - printBackground - Whether to print CSS backgrounds. (default: true)
  - landscape - true for landscape, false for portrait. (default: false)
  - pageSize - Specify page size of the generated PDF. Can be A3, A4, A5, Legal, Letter, Tabloid or <width>x<height> in microns (e.g. 210000x297000 for A4)(default: A4)
  - marginsType - Specify the type of margins to use (default: 0)
  - removePrintMedia - Removes any <link media="print"> stylesheets on page before render. (default: false)
  - delay - Specify how many seconds to wait before generating the PDF (default: 0)
  - waitForText - Specify a specific string of text to find before generating the PDF (default: false)
* Consider async jobs if we get more load
  * return with a redirect to a status page for this job
  * job downloads from renderer in background
  * browser keeps polling
  * when done, a link to a regular http download is shown (maybe even a redirect)

  A dead-simple prototype was removed with a3d45b7172056d03cd4afec3a50d277d1818976e.
* Concurrency?
