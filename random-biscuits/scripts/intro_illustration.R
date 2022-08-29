# This script creates the file intro_illustration.gif

intro.illustration.1 <- magick::image_graph(width=500,height=400)

for(color in c("chocolate","white")) {
  for(radius in c(seq(from=0,to=biscuit.radius,length.out=30),
                  seq(from=biscuit.radius,to=0,length.out=30))) {
    for(i in radius) {
      par(pty="m",
          xaxt="n",yaxt="n",
          mar=c(0,0,0,0))
      plot(x=c(-3,3),y=c(-2.4,2.4),type="n")
      text(x=0,y=2.2,
           labels="System: three different biscuits in the box",
           adj=c(0.5,0.5),cex=2)
      plotrix::draw.ellipse(x=c(box.edges.x[1]+box.width/3,box.edges.x[2]-box.width/3,box.edges.x[2]-box.width/3),
                            y=c(mean(box.edges.y),box.edges.y[1]+box.height/4,box.edges.y[2]-box.height/4),
                            a=i,
                            b=biscuit.radius,
                            col=c(color,"white","chocolate"))
      rect(xleft=box.edges.x[1],
           xright=box.edges.x[2],
           ybottom=box.edges.y[1],
           ytop=box.edges.y[2],
           lwd=3,border="black",
           col=rgb(red=0.8,green=0.6,blue=0,alpha=0.3))
    }
  }
}

dev.off()

intro.illustration.1 <- intro.illustration.1 |>
  magick::image_border(color="black",geometry="1x1")

# Create animation of pulling biscuit out and flipping it
library(data.table)

iterations <-
  data.table::data.table(
    title=c(rep("Process: biscuit is drawn out of box.\nUp-side is chocolate.",times=60),
            rep("Probability that down-side is also chocolate?",times=90)),
    position=c(seq(from=box.edges.x[2]-biscuit.radius,to=2,length.out=30),
               rep(2,times=120)),
    radius=c(rep(biscuit.radius,times=60),
             seq(from=biscuit.radius,to=0,length.out=15),
             seq(from=0,to=biscuit.radius,length.out=15),
             rep(biscuit.radius,times=60)),
    text=c(rep("Up-\nside",times=60),
           rep("",times=30),
           rep("Down-\nside",times=60)))

intro.illustration.2 <-
  draw_biscuit(iteration.data=iterations,biscuit.color="chocolate") |>
  magick::image_border(color="black",geometry="1x1")

intro.illustration.1.5 <-
  magick::image_morph(
    c(intro.illustration.1[length(intro.illustration.1)],
      intro.illustration.2[1]),
    frames=15)

magick::image_write_gif(
  c(intro.illustration.1,
    intro.illustration.1.5,
    intro.illustration.2),
  path="images/intro_illustration.gif",
  delay=1/30)

magick::image_destroy(intro.illustration.1)
magick::image_destroy(intro.illustration.1.5)
magick::image_destroy(intro.illustration.2)