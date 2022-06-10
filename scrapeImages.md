Scrape Images from a Website
================
Richard Sprague
6/10/2022

A roofing company sent me their estimate, plus a pageful of photos they
took of my roof. I’d like permanent copies of the photos, but rather
than download each one individually, can I scrape the html page and save
them automatically?

Here’s a portion of the web page:

``` html
/head>
<body class="galleries show ">
  
  <div class="cc-page-title">
    <span>Roof Smart shared a gallery with you.</span>
  </div>

  <div class="cc-gallery-details">
    <div class="gallery-title">
      <span class="gallery-name">Roof Smart</span>
      <span class="gallery-text">
        <i class="mdi mdi-image-multiple"></i>
        <span>Shared Photo Gallery</span>
      </span>
    </div>

    <a class="ccb-blue" data-remote="true" href="/ujs/image_galleries/JW1Nr1Js/downloads/new">
      <i class="mdi mdi-download"></i>
      <span>Download All Photos</span>
</a>  </div>

  <div id="gridImageContainer" class="cc-grid">
        <div class="cc-grid-item">
    <div
      class="cc-grid-image"
      style="background-image: url('https://companyname.com/longurl')"
      data-background-image-url="https://companyname.com/longurl0"
      data-thumb="https://companyname.com/longurl1"
      data-full="https://companyname.com/longurl2"
    >
    </div>
```

## Read the URLs

The `rvest` package, which installs automatically as part of the
Tidyverse, lets me read that page like this:

``` r
library(tidyverse)

url <- rstudioapi::showPrompt(title = "Please enter URL",
                              message = "Please enter URL",
                              default="https://app.companycam.com/galleries/JW1Nr1Js")
photo_grid_page <- rvest::read_html(url)

photo_urls <- photo_grid_page %>% rvest::html_elements(".cc-grid-image") %>%
  rvest::html_attr("data-full")
```

Now I have a bunch of photo urls, so I read them using the
[`magick`](https://docs.ropensci.org/magick/articles/intro.html)
package.

``` r
photos <- magick::image_read(photo_urls[1]) # remove the [1] part to grab all the photos
```

Reading each photo can take some time, so in this example I only bother
reading the first one, the element `photos_urls[1]`.

## Save photos

Finally, write to disk each of the individual items in object `photos`.

``` r
for(i in 1:length(photos)){
  print(str_c("writing photo",i,"\n"))
  magick::image_write(photos[i],
                      path = file.path(getwd(),
                                       stringr::str_c("file",i,".jpeg")),
                      format = "JPEG")
}
```

    ## [1] "writing photo1\n"
