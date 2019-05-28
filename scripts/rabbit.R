library(stringr)
library(magrittr)
library(readr)
library(keypress)

# clear the console
clear_screen <- function(){
  if(has_keypress_support()) { # at console...
    system("clear")
  } else { # in rstudio...
    cat("\f") # form feed 
  }
}

# print method for the arena class
print.arena <- function(x,...) {
  
  clear_screen()
  
  # convert matrix to string
  str <- x %>% 
    apply(1,str_flatten) %>%
    str_flatten("\n")
  
  # substitute emojis for text & print
  str %>% 
    str_replace_all("w",emo::ji("black_large_square")) %>%
    str_replace_all(" ",emo::ji("white_large_square")) %>%
    str_replace_all("f",emo::ji("fire")) %>%
    str_replace_all("r",emo::ji("rabbit")) %>%
    str_replace_all("c",emo::ji("carrot")) %>%
    cat()
  
  cat("\n\n")
}

# print method for the uitext class
print.uitext <- function(x,...) {
  cat(x)
  if(has_keypress_support()) {
    key <- keypress()
  } else {
    key <- readline()
  }
  return(invisible(key))
}

# read csv as matrix and declare "arena" class
import_arena <- function(file) {
  arena <- suppressMessages(read_csv(file,col_names = FALSE)) 
  arena <- arena %>% as.matrix()
  arena[is.na(arena)] <- " "
  class(arena) <- "arena"
  return(arena)
}

# create ui text 
create_uitext <- function(msg) {
  class(msg) <- "uitext"
  return(msg)
}

# define an update method for the arena
update.arena <- function(arena, key) {
  
  # update based on user move
  if(key == "w") arena <- arena %>% move("r","up")
  if(key == "s") arena <- arena %>% move("r","down")
  if(key == "a") arena <- arena %>% move("r","left")
  if(key == "d") arena <- arena %>% move("r","right")
  
  # randomly move fires
  arena <- arena %>% fires()
  
  return(arena)
}

# update the locations of the fire devils
fires <- function(arena) {
  
  n_fires <- sum(arena == "f")
  mv <- sample(c("up","down","left","right"),size = n_fires,replace=TRUE)
  arena <- arena %>% move("f",mv)
  return(arena)
  
}

compare <- function(from, to) {
  if(to == " ") {
    return("okay")
  }
  if(to == "f" & from == "f") {
    return("okay")
  }
  if(to == "c" & from == "r") {
    return("win")
  }
  if(to == "r" & from == "f") {
    return("lose")
  }
  return("forbid")
}

# update the arena state based on a user action
move <- function(arena, unit, direction) {
  
  # get locations
  location <- which(arena==unit,TRUE) 
  nloc <- dim(location)[1]
  
  if(length(nloc) > 0) {
    for(ind in 1:nloc) {
      
      row <- location[ind,"row"]
      col <- location[ind,"col"]
      
      if(direction[ind] == "up") {
        try_row <- row-1
        try_col <- col
      }
      if(direction[ind] == "down") {
        try_row <- row+1
        try_col <- col
      }
      if(direction[ind] == "left") {
        try_row <- row
        try_col <- col-1
      }
      if(direction[ind] == "right") {
        try_row <- row
        try_col <- col+1
      }
      
      target_unit <- arena[try_row,try_col]
      outcome <- compare(unit,target_unit)
      
      if(outcome == "okay") {
        arena[try_row,try_col] <- unit
        arena[row,col] <- " "
      }
      if(outcome == "forbid"){
        # do nothing
      }
      if(outcome == "win"){
        arena[try_row,try_col] <- unit
        arena[row,col] <- " "
      }
      if(outcome == "lose"){
        arena[try_row,try_col] <- unit
        arena[row,col] <- " "
      }
    }
  }
  
  return(arena)
}

game_over <- function(arena) {
  if(sum(arena=="c") == 0) {
    cat("\nYou got the carrot!\n")
    return(TRUE)
  }
  if(sum(arena=="r") == 0) {
    cat("\nA fire devil got you :-(\n")
    return(TRUE)
  }
  return(FALSE)
}

"w,w,w,w,w,w,w,w,w,w
w,c, ,f,f,f, , , ,w
w, , ,f,f,f, , , ,w
w,f,f,f,f,f, , , ,w
w,f,f,f,f,f, , , ,w
w,f,f,f,f,f, , , ,w
w, , , , , , , , ,w
w, , , , , , , ,r,w
w,w,w,w,w,w,w,w,w,w" %>% import_arena() -> arena

ui_text <- create_uitext("options: [w/a/s/d/q] ")

key <- ""
actions <- ""
while(key != "q") {
  
  # update the user interface
  arena %>% print()
  key <- ui_text %>% print()

  # update arena based on user input
  arena <- arena %>% update(key)
  
  # record
  actions <- actions %>% str_c(key)
  
  # check to see if it's game over
  if(game_over(arena)) {
    key <- "q"
  }
}

cat("\n")
