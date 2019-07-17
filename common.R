
# variables for plotting figures
emphCol <- rgb(0,0,1)
emphColLight <- rgb(.5,.5,1)
emphGrey <- grey(.5)
eps <- TRUE
colour <- TRUE
width <- 12
height <- 8

# returns a list of expressions
capture_dots <- function(...) {
  as.list(substitute(list(...)))[-1L]
}

# code for flavour text
flavour_quote <- function(..., auth) {
  dots <- capture_dots(...)
  dots <- lapply(dots, function(x){ 
    paste0("&nbsp;&nbsp;&nbsp;&nbsp;", x)
  })
  cat('*')
  cat(unlist(dots), sep="<br>\\newline")
  cat("*<br>\\newline")
  cat(paste0(
    "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--- ", 
    auth, 
    "<br>\\newline"
  ))
}
