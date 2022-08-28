# We specify how many biscuit draws we will simulate
total.draws <- 2000

# This initiates a seed for (pseudo)random number generation. Any integer number will do,
# but the same number will reproduce the *exact* same results.
set.seed(1)

# Load the data.table library, which we will use to store and analyze our data.
library(data.table)

# The simulated process happens right below.
# "lapply" maps each number from 1 to 2000 to a random draw.
biscuit.draws <- lapply(
  X=seq_len(total.draws),
  FUN=function(i,box) {
    # i takes values from 1 to 2000
    # box is the list we previously made and remains the same in all iterations
    
    # The following steps simulate each biscuit draw from the box:
    draw <- box |>
      
      # "sample(size=1)" simulates the drawing of 1 random element (biscuit) from the list.
      # The result is a list of size 1, so we use unlist() to take this 1 element out of it.
      sample(size=1) |> unlist() |>
      
      # The next "sample(size=2,replace=FALSE)" function call simulates random placement
      # of the drawn biscuit on the table.
      # "size=2" means that we pick both elements (sides) in random order.
      # "replace=FALSE" means there is no replacement of the 1st side after it is picked.
      # It makes sense to do this. If the biscuit is placed with its one side facing up,
      # its other side is definitely facing down.
      # "sample(size=2,replace=FALSE)" essentially shuffles the 2 sides of the biscuit
      # in random order, just like a coin flip.
      sample(size=2,replace=FALSE)
    
    return(
      
      # The results of the draw and placement are returned in a named list.
      # The 1st element is designated the up-facing side,
      # and the 2nd element is the down-facing side.
      list(up.side=draw[1],
           down.side=draw[2]))
    
    # This is where the "box" list is passed inside the "lapply" function
  }, box=box) |>
  
  # "rbindlist()" binds the 2000 returned lists together in a data.table
  rbindlist()