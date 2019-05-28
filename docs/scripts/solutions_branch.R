seasons <- c("summer","autumn","winter","spring")

for(s in seasons) {
  
  if(s == "summer") {
    print("blegh - too hot!")
  } else if(s == "winter") {
    print("blegh - too cold!") 
  } else if(s == "autumn") {
    print("blegh - too many leaves")
  } else if(s == "spring") {
    print("blegh - too much pollen")
  } else {
    print("is that even a season?")
  }
  
}
