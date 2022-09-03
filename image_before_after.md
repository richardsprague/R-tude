Image before-after
================
Richard Sprague
2022-09-03

I’m using the Magick package to manipulate photos and generate a morph
animation.

Two photos of a house, one before it was painted and another afterwards:

Read the two images from their URL.

``` r
house_before <- magick::image_read("https://sat02pap004files.storage.live.com/y4mgiWcxG-hGv6gcIYyuziTiKcBq5Oe5vpNAn5-pIAUMlhkQNH1HEtg8-qE-KZnA1oiTKiUDn9cQE9qRivXu7QDsOD-v9qMGYOCC4cVqEN5yd3_AGvM-pQQCpobvZ2PoyLwJn5NsDgqM-ZdkQTxno3xTCzy9YvRHwZ-R5MjqtXVbL8lEjSZhewB6dJAbE3dSSdc?width=660&height=495&cropmode=none")
house_after <- magick::image_read("https://sat02pap004files.storage.live.com/y4m8HTFlKqGqdP4ewqQ_8r_ZP4svgIa20wdbuLMIAu1MQ6LlEXaitYLyysbRqA4fbFQGKACCkkGdQJNRu9TPIZWXTZ9wwM99RGKAVZ-2Qj5IVA_WMEWAgptZA3FHDOUIWWx4Jc8-ujQ12sS9QR0OgZsW-YQGXWik5O3AAdmS-xG107AiprIlrDWqcepJ2eRdF0L?width=660&height=495&cropmode=none")

magick::image_resize(c(house_before,house_before,house_after,house_after,house_before),"640") %>%
  magick::image_background("white") %>%
  magick::image_morph(frames=8) %>%
  magick::image_animate(optimize=TRUE) %>% 
  magick::image_write_gif("house_before_after.gif")
```

    ## Images are not the same size. Resizing to 640x480...

    ## [1] "house_before_after.gif"

![](./house_before_after.gif)
