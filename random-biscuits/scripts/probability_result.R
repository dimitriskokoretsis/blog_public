prob.frame.1 <- magick::image_graph(width=240,height=400)
par(pty="m",
    xaxt="n",yaxt="n",
    mar=c(0,0,0,0))
plot(x=c(-3,3),y=c(-5,5),type="n")
rect(xleft=-2.5,xright=2.5,ybottom=-4,ytop=4,lwd=3,col="grey")
text(x=0,y=0,
     labels="6 biscuit sides",
     adj=c(0.5,0.5),
     cex=2)
dev.off()

prob.frame.2 <- magick::image_graph(width=240,height=400)
par(pty="m",
    xaxt="n",yaxt="n",
    mar=c(0,0,0,0))
plot(x=c(-3,3),y=c(-5,5),type="n")
rect(xleft=-2.5,xright=2.5,ybottom=0,ytop=4,lwd=3,col="chocolate")
text(x=0,y=2,
     labels="3 chocolate\nsides (up)",
     adj=c(0.5,0.5),
     cex=2)
rect(xleft=-2.5,xright=2.5,ybottom=-4,ytop=0,lwd=3,col="white")
text(x=0,y=-2,
     labels="3 icing\nsides (up)",
     adj=c(0.5,0.5),
     cex=2)
dev.off()

prob.frame.3 <- magick::image_graph(width=240,height=400)
par(pty="m",
    xaxt="n",yaxt="n",
    mar=c(0,0,0,0))
plot(x=c(-3,3),y=c(-5,5),type="n")
rect(xleft=-2.5,xright=2.5,ybottom=4/3*2,ytop=4,lwd=3,col="chocolate")
text(x=0,y=10/3,
     labels="1 chocolate\nside (down)",
     adj=c(0.5,0.5),
     cex=1.5)
rect(xleft=-2.5,xright=2.5,ybottom=4/3,ytop=4/3*2,lwd=3,col="chocolate")
text(x=0,y=2,
     labels="1 chocolate\nside (down)",
     adj=c(0.5,0.5),
     cex=1.5)
rect(xleft=-2.5,xright=2.5,ybottom=0,ytop=4/3,lwd=3,col="white")
text(x=0,y=2/3,
     labels="1 icing\nside (down)",
     adj=c(0.5,0.5),
     cex=1.5)
rect(xleft=-2.5,xright=2.5,ybottom=-4/3,ytop=0,lwd=3,col="chocolate")
text(x=0,y=-2/3,
     labels="1 chocolate\nside (down)",
     adj=c(0.5,0.5),
     cex=1.5)
rect(xleft=-2.5,xright=2.5,ybottom=-4/3*2,ytop=-4/3,lwd=3,col="white")
text(x=0,y=-2,
     labels="1 icing\nside (down)",
     adj=c(0.5,0.5),
     cex=1.5)
rect(xleft=-2.5,xright=2.5,ybottom=-4,ytop=-4/3*2,lwd=3,col="white")
text(x=0,y=-10/3,
     labels="1 icing\nside (down)",
     adj=c(0.5,0.5),
     cex=1.5)
rect(xleft=-2.5,xright=2.5,ybottom=-4,ytop=0,
     col=rgb(red=0.5,green=0.5,blue=0.5,alpha=0.5))
rect(xleft=-2.6,xright=2.6,ybottom=-0.1,ytop=4.1,border="green",lwd=7)
dev.off()

probability.result <-
  magick::image_morph(
    c(prob.frame.1,
      prob.frame.1,
      prob.frame.2,
      prob.frame.2,
      prob.frame.3,
      prob.frame.3,
      prob.frame.3),
    frames=29) |>
  magick::image_border(color="black",geometry="1x1")
probability.result <- probability.result[-1]

iterations <-
  data.table::data.table(
    title=c(rep("Biscuit is drawn out of box",times=60),
            rep("Down-facing side is revealed",times=90)),
    position=c(seq(from=box.edges.x[2]-biscuit.radius,to=2,length.out=30),
               rep(2,times=120)),
    radius=c(rep(biscuit.radius,times=60),
             seq(from=biscuit.radius,to=0,length.out=15),
             seq(from=0,to=biscuit.radius,length.out=15),
             rep(biscuit.radius,times=60)),
    text=c(rep("Up-\nside",times=60),
           rep("",times=30),
           rep("Down-\nside",times=60))) 

unknown.biscuit.pulled <- draw_biscuit(iteration.data=iterations,biscuit.color="grey") |>
  magick::image_border(color="black",geometry="1x1")

unknown.biscuit.pulled <- c(
  rep(unknown.biscuit.pulled[1],times=30),
  unknown.biscuit.pulled
)

.mapply(
  FUN=function(animation,result) {
    return(
      magick::image_append(c(animation,result))
    )
  },
  dots=list(as.list(unknown.biscuit.pulled),
            as.list(probability.result)),
  MoreArgs=NULL) |>
  magick::image_join() |>
  magick::image_write_gif(path="images/probability_result.gif",delay=1/30)

magick::image_destroy(prob.frame.1)
magick::image_destroy(prob.frame.2)
magick::image_destroy(prob.frame.3)
magick::image_destroy(unknown.biscuit.pulled)
magick::image_destroy(probability.result)
