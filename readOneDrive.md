Read OneDrive
================
Richard Sprague
6/4/2022

# Read and Write to OneDrive

An [announcement by
Hong](https://community.rstudio.com/t/microsoft365r-interface-to-microsoft-365-sharepoint-onedrive-etc/94287)
at the RStudio Community Site points me to a library that can read and
write to Microsoft 365 resources, including OneDrive. Is this my
solution for reading Excel files online?

First I install the package (if necessary) and get a pointer to my
personal OneDrive.

``` r
library(tidyverse, quietly = TRUE)
if(!require("Microsoft365R")) install.packages("Microsoft365R")

od <- Microsoft365R::get_personal_onedrive()
```

The first time this is run, it will open a browser for you and ask for
your Microsoft 365 credentials.

``` r
od$list_items() %>% tail() %>% select(name, size, isdir)
```

    ##                         name       size isdir
    ## 28                    ubiome 8677237189  TRUE
    ## 29                      Work 4341464243  TRUE
    ## 30                  Work-del          0  TRUE
    ## 31                 .Rhistory       2435 FALSE
    ## 32 brain_data_only_valid.csv     980749 FALSE
    ## 33                   iOS.zip  268739095 FALSE

## Read an Excel file

I keep a copy of my health-related self-tracking in a complicated Excel
file. Let’s confirm that it’s there.

``` r
trackfilepath <- file.path("General/Health/Richard_Sprague_Tracking.xlsx")

trackfile_item_list <- od$get_item_properties(trackfilepath)
trackfile_item_list[["name"]]
```

    ## [1] "Richard_Sprague_Tracking.xlsx"

``` r
trackfile_item_list[["createdBy"]]
```

    ## $application
    ## $application$displayName
    ## [1] "MSOffice15"
    ## 
    ## $application$id
    ## [1] "480728c5"
    ## 
    ## 
    ## $user
    ## $user$displayName
    ## [1] "Richard Sprague"
    ## 
    ## $user$id
    ## [1] "8bc6084b92ffa451"

and now try to read it. It’s easy to open it into a browser.

``` r
if(interactive()) od$open_item(trackfilepath) else "(shows in browser)"
```

    ## [1] "(shows in browser)"

To read it into a dataframe requires some roundabout action. I can grab
the URL easily enough, but it appears I must then read the contents
using `curl`. Unfortunately that requires I make a separate, local copy
of the file.

``` r
trackfile_url <- trackfile_item_list[["@microsoft.graph.downloadUrl"]]

destfile <- "tempCopy.xlsx"
curl::curl_download(trackfile_url, destfile)
Richard_Sprague_Tracking <- readxl::read_xlsx(destfile)

head(Richard_Sprague_Tracking)[1:3]
```

    ## # A tibble: 6 × 3
    ##   Date                    Z Geo        
    ##   <dttm>              <dbl> <chr>      
    ## 1 2022-01-01 00:00:00  7.22 San Antonio
    ## 2 2022-01-02 00:00:00 NA    San Antonio
    ## 3 2022-01-03 00:00:00 NA    San Antonio
    ## 4 2022-01-04 00:00:00 NA    San Antonio
    ## 5 2022-01-05 00:00:00 NA    San Antonio
    ## 6 2022-01-06 00:00:00 NA    San Antonio

But it works! and unlikely my [previous
hack](https://richardsprague.com/post/2019/09/20/r-tude-read-onedrive-excel-files/)
this one may preserve the correct URL across sessions.
\#betterThanNothingIguess
