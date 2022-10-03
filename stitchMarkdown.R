# stichmarkdown.md Stitch a directory Markdown files together with their filenames



#' @title Return all markdown files from `dir`
#' @param dir char of directory
md_files <- function(dir = getwd()) {
  list.files(path = dir, pattern = "\\.md", full.names = TRUE)
}

md_files()

#' @title convert notes-formatted fname to date string
#' @description e.g. Notes 220901 Monday -> "Monday, September 2"
#' @param nname standard notes name for a date entry
notes_date <- function(nname) {
  s <- stringr::str_split(nname, pattern = " ")
  if(length(s[[1]])==3) {
    d <- s[[1]][2]
    my_date <- lubridate::as_date(d)
  } else stop("bad name",nname)
  my_date
}

#' @title same as `notes_date()` but with pretty formatting
#' @description e.g. try this: format_notes_date("Notes 220901 Monday")
format_notes_date <- function(nname) {
  d <- notes_date(nname)
  format(d,"%A, %B %d")


}

#' @title Append a bunch of files but put the filename on the first line.
#' @param before_str char string to put in front of the file contents
#' @param after_str char string to put after the file name
#' @param fname char vector of filenames
concat_files <- function(fname,
                         before_str = "\n_",
                         after_str = "_\n"){
  s <- sapply(fname, function(x) {
    fcontents <- read_file(x)
    stringr::str_c(before_str, format_notes_date(fs::path_ext_remove(basename(x))),after_str,fcontents, collapse = "\n")
  })
  stringr::str_c(s, collapse ="\n")
}

notes_dir <- "/Users/sprague/Library/CloudStorage/OneDrive-Personal/Sprague 2022/Notes Q3/Personal/Notes/Notes 2022Q3"

all <- concat_files(md_files(notes_dir))
write_file(all, "all.md")


