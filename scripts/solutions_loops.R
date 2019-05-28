###### Solution to the "for loop" exercise

library(TurtleGraphics)
turtle_init()
sides <- 4 # for square (set to 3 for triangle)

for(i in 1:sides) {
  turtle_forward(distance = 10)  # move 
  turtle_left(angle = 360/sides) # turn left
}

###### Solution to the "while loop" exercise

telegram <- c("All","is","well","here","STOP","This","is","fine")
word <- ""
ind <- 0

while(word != "STOP") {
  ind <- ind + 1
  word <- telegram[ind]
  print(word)
}

