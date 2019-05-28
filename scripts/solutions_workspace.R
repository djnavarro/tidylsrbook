#### create and save
dax <- "wug"
blicket <- "wug wug"

save(dax, blicket, file="solutions_workspace.Rdata")

### load

load("solutions_workspace.Rdata")
rm(dax)