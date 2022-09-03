# Rtude: convert a series of Joplin markdown files.
# Find embedded markdown links
# convert paths in the link to a local path

library(tidyverse)

joplin_dir_path <- file.path("/path/to/dir")

# just the markdown filenames without the full path
# tools::list_files_with_exts(joplin_dir_path, exts = "md", full.names = FALSE)

list.files(joplin_dir_path)

md_files <- Sys.glob(file.path(joplin_dir_path,"*.md"))

## full path to all the markdown files in joplin_dir_path
md_files

## handy functions (not used this time)
# tools::file_path_sans_ext(list.files(joplin_dir_path))
# tools::list_files_with_exts(list.files(joplin_dir_path),".md")

## for each file in md_files, look inside to find references to the _resources directory
## pull out the full filename (without the directory) and return all the file names
image_files_only <- md_files %>% purrr::map(read_file) %>% stringr::str_extract("_resources/.*\\)") %>%
  stringr::str_replace("\\)","") %>%
  stringr::str_replace_all("_resources/","")  %>% na.omit() %>% as.character()

## just the files (probably jpegs) in the _resources directory
image_files_only


### trying the regular expression library to see if I can simply building regexes
# https://github.com/kevinushey/rex
library(rex)

rex( "_resources", anything, capture(quotes))
# md_files %>% purrr::map(read_file) %>% stringr::str_extract("_resources/.*\\)")

md_files %>% purrr::map(read_file) %>% stringr::str_extract("_resources/[a-z|0-9]*")

quotes_or_paren <- "_resources/\([a-z|0-9])*\.[a-z]*(\"|\))"

image_files_only <- md_files %>% purrr::map(read_file) %>% stringr::str_extract(rex("_resources/",
                                                                capture(

                                                                    any_alnums,
                                                                    or(".jpeg", ".png", ".jpg", quotes)

                                                                ))) %>%
  stringr::str_replace_all("_resources/","")  %>% na.omit() %>% as.character()

image_files_only
# copy all matching image files to the desktop
file.copy(file.path(joplin_dir_path,"..","..","_resources", image_files_only), file.path("~/Desktop"))

### end trying out rex                                                                                                            )

# all files in the _resources directory
# list.files(file.path(joplin_dir_path,"..","..","_resources"))

# double-check that the image files exist in this directory
file.exists(file.path(joplin_dir_path,"..","..","_resources", image_files_only))

# copy all matching image files to the desktop
#file.copy(file.path(joplin_dir_path,"..","..","_resources", image_files_only), file.path("~/Desktop"))

### Next: for all files in joplin_dir_path, replace the markdown that points to the image_files_only
# e.g. ![something](\_resources\imagefilename.jpg) -> ![something](imagefilename.jpg)

###

html_or_md_image_pattern <- "_resources\\/([a-z|0-9])*\\.[a-z]*"
md_image_pattern <- "!\\[.*\\]\\(.*\\)"

## given a file fname, replace any joplin references to a markdown link to the _resources directory with
## replace to the same link name, only in the current directory
## e.g. ![image.jpg](../_resources/image.jpg) becomes  ![image.jpg](image.jpg)

read_file_and_replace_string <- function(fname, pattern = "_resources/.*\\)" , replacement) {

  s <- readr::read_file(fname)

 img_name <- s %>% stringr::str_extract(pattern) %>%
   stringr::str_extract("_resources/.*\\)") %>%
   str_replace_all("_resources/","") %>%
   stringr::str_replace_all("\\)","")



  s %>% stringr::str_replace(pattern,paste0("![",img_name,"](",img_name,")"))
}

read_file_and_replace_string(md_files[8], pattern = html_or_md_image_pattern)

## go through joplin_dir_path and print all file names
for (fname in tools::list_files_with_exts(joplin_dir_path, exts = "md", full.names = FALSE)) {
  cat(fname)
}

replace_markdown_links_from_dir <- function(dir_path) {
  for (fname in list.files(dir_path, full.names = TRUE)) {
    original_file <- fname
    new_name <- file.path("~/Desktop", basename(original_file))

    read_file_and_replace_string(original_file, pattern = md_image_pattern) %>%
      readr::write_file(file = new_name)

  }
}

