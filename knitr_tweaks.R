if(FALSE) {
  
  #############
  
  # default figure size
  knitr::opts_chunk$set(
    fig.width=4.75, 
    fig.height=4.75,
    fig.align = "center"
  )
  
  #############
  
  # Limit the output from a chunk
  #
  # Original Author: Michael Friendly
  # https://stat.ethz.ch/pipermail/r-help/2014-October/422286.html
  #
  # Mildly modified to:
  #   - hide the hook_output variable in the lsr_env environment so
  #     that it doesn't show up when the markdown document displays
  #     the contents of the workspace
  #   - uses "BLAH BLAH BLAH" rather than "[...]" because hey, that
  #     was the style of the LSR book and it was fun so lets stick
  #     with it
  
  # if there's already an lsr_env, remove it from the scope chain
  if("lsr_env" %in% search()){
    detach("lsr_env")
  }
  
  # do the assignment in the an environment that will be hidden
  # when the book outputs the workspace
  lsr_env <- new.env()
  assign("hook_output", knitr::knit_hooks$get("output"), envir = lsr_env)
  
  # now do the output limit...
  knitr::knit_hooks$set(output = function(x, options) {
    lines <- options$output.lines
    if (is.null(lines)) {
      return(hook_output(x, options))  # pass to default hook
    }
    x <- unlist(strsplit(x, "\n"))
    more <- "BLAH BLAH BLAH"
    if (length(lines)==1) {        # first n lines
      if (length(x) > lines) {
        # truncate the output, but add ....
        x <- c(head(x, lines), more)
      }
    } else {
      x <- c(if (abs(lines[1])>1 | lines[1]<0) more else NULL,
             x[lines],
             if (length(x)>lines[abs(length(lines))]) more else NULL
      )
    }
    # paste these lines together
    x <- paste(c(x, ""), collapse = "\n")
    hook_output(x, options)
  })
  
  ##### hide a shorthand conversion operator
  
  assign(
    x = "%f%",
    value = function(x,f) {
      if(f=="int") {
        return(as.integer(x))
      } else if(f=="char") { 
        return(as.character(x))
      } else {
        stop("unknown format f")
      }
    },
    envir = lsr_env
  )
  
  
  attach(lsr_env)
  rm(lsr_env)
  
}