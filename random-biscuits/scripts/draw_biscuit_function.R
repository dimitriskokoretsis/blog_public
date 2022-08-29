# The function in this script creates an animated biscuit being drawn out of the box.
# Text on the animation and biscuit color are input arguments.
# I made it a function to reduce code, as different animations of the same type needed to be made.

draw_biscuit <- function(iteration.data,biscuit.color) {
  library(data.table)
  
  box.edges.x <- c(-2.4,-0.1)
  box.edges.y <- c(-1.9,1.4)
  box.width <- box.edges.x[2] - box.edges.x[1]
  box.height <- box.edges.y[2] - box.edges.y[1]
  biscuit.radius <- max(iteration.data[,radius])
  
  biscuit.drawing.illustration <- magick::image_graph(width=500,height=400)
  
  for(i in seq_len(nrow(iteration.data))) {
    par(pty="m",
        xaxt="n",yaxt="n",
        mar=c(0,0,0,0))
    plot(x=c(-3,3),y=c(-2.4,2.4),type="n")
    text(x=0,y=2.2,
         labels=iteration.data[i,title],
         adj=c(0.5,0.5),cex=2)
    plotrix::draw.ellipse(x=iteration.data[i,position],y=0,
                          a=iteration.data[i,radius],b=biscuit.radius,
                          col=biscuit.color)
    plotrix::textbox(x=c(iteration.data[i,position-radius*0.8],iteration.data[i,position+radius*0.8]),
                     y=0,textlist=iteration.data[i,text],
                     cex=2,justify="c",box=FALSE,adj=c(0,-0.5))
    rect(xleft=box.edges.x[1],
         xright=box.edges.x[2],
         ybottom=box.edges.y[1],
         ytop=box.edges.y[2],
         lwd=3,border="black",
         col=rgb(red=0.8,green=0.6,blue=0,alpha=1))
  }
  
  dev.off()
  
  return(biscuit.drawing.illustration)
}

