# TODOs

* Expose options in form:
  - accessKey - Authentication key.
  - url - Full URL to fetch.
  - pageSize - Specify page size of the generated PDF. Can be A3, A4, A5, Legal, Letter, Tabloid or <width>x<height> in microns (e.g. 210000x297000 for A4)(default: A4)
  - marginsType - Specify the type of margins to use (default: 0)
  - printBackground - Whether to print CSS backgrounds. (default: true)
  - landscape - true for landscape, false for portrait. (default: false)
  - removePrintMedia - Removes any <link media="print"> stylesheets on page before render. (default: false)
  - delay - Specify how many seconds to wait before generating the PDF (default: 0)
  - waitForText - Specify a specific string of text to find before generating the PDF (default: false)
* start page should show whitelisted domains
* 401 page (no or wrong password) should show some text why auth is required
* some real tests with missing params etc.
* async: return with handle; download in background, provide link to regular http download
* Concurrency?
