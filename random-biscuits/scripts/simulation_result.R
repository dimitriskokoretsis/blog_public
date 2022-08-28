library(ggplot2)
library(ggthemes)

# Create barplot of upside results

simulation.result.upside <- magick::image_graph(width=160,height=400)

ggplot(data=biscuit.draws[,.(count=.N),by="up.side"],
       mapping=aes(x="",fill=up.side)) +
  theme_classic() +
  labs(x="",y="Draws") +
  theme(axis.line.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.title.y=element_text(size=20,margin=margin(r=0)),
        legend.position="none") +
  geom_col(mapping=aes(y=count),colour="black") +
  scale_fill_manual(values=c("chocolate","white")) +
  geom_text(mapping=aes(y=cumsum(count)-count/2,
                        label=paste0(rev(up.side),"\n",rev(count))),
            angle=0,size=6.5)

dev.off()


# Create barplot of down-side results
summed.data <- biscuit.draws[,.(count=.N),by=.(up.side,down.side)][order(up.side,down.side)]

simulation.result.downside <- magick::image_graph(width=160,height=400)

ggplot(data=summed.data,
       mapping=aes(x="",fill=paste(up.side,down.side))) +
  theme_classic() +
  labs(x="",y="Draws") +
  theme(axis.line.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.title.y=element_text(size=20,margin=margin(r=0)),
        legend.position="none") +
  geom_col(mapping=aes(y=count),colour="black") +
  scale_fill_manual(values=c("chocolate","white","chocolate","white")) +
  geom_text(mapping=aes(y=cumsum(count)-count/2,
                        label=paste0(rev(down.side),"\n",rev(count))),
            angle=0,size=6.5) +
  geom_rect(mapping=aes(xmin=0.5,xmax=1.5,ymin=0,ymax=total.draws-cumsum(count)[2]),
            colour=NA,fill=rgb(red=0.5,green=0.5,blue=0.5,alpha=0.3),size=0) +
  geom_rect(mapping=aes(xmin=0.5,xmax=1.5,ymin=total.draws-cumsum(count)[2],ymax=total.draws),
            colour="green",fill=NA,size=2)

dev.off()


simulation.result <-
  magick::image_morph(
    c(simulation.result.upside,
      simulation.result.upside,
      simulation.result.upside,
      simulation.result.downside,
      simulation.result.downside,
      simulation.result.downside),
    frames=29) |>
  magick::image_border(color="black",geometry="1x1")
simulation.result <- simulation.result[-1]

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

.mapply(
  FUN=function(animation,result) {
    return(
      magick::image_append(c(animation,result))
    )
  },
  dots=list(as.list(unknown.biscuit.pulled),
            as.list(simulation.result)),
  MoreArgs=NULL) |>
  magick::image_join() |>
  magick::image_write_gif(path="images/simulation_result.gif",delay=1/30)

magick::image_destroy(simulation.result.upside)
magick::image_destroy(simulation.result.downside)
magick::image_destroy(unknown.biscuit.pulled)
magick::image_destroy(simulation.result)