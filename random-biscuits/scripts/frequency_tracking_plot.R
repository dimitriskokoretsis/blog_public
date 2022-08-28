biscuit.draws.chocolate.up <- biscuit.draws[up.side=="chocolate"]

biscuit.draws.chocolate.up[
  
  # We create 2 new fields to track observations up to each draw:
  # n.draws: the number of draws resulting in up-facing chocolate
  # cumulative.frequency: the requested frequency of the down side also being chocolate
  # The cumsum() function (cumulative sum) sums the cases of the down-facing side being
  # chocolate so far, which is then divided by the occurrences of up-facing chocolate.
  ,`:=`(n.draws=.I,
        cumulative.frequency=cumsum(down.side=="chocolate")/.I)]

library(ggplot2)
library(ggthemes)

frequency.plot <- magick::image_graph(width=160,height=400)

for(i in biscuit.draws.chocolate.up[,n.draws]) {
  temp <-
    ggplot(data=biscuit.draws.chocolate.up[i],
         mapping=aes(x="",y=cumulative.frequency)) +
    theme_classic() +
    theme(axis.line.x=element_blank(),
          axis.ticks.x=element_blank()) +
    ylab("Frequency") + xlab("") +
    ylim(0,1) +
    geom_col(colour="black",fill="grey")
  print(temp)
}
dev.off()

frequency.plot <- frequency.plot |>
  magick::image_border(color="black",geometry="1x1")

frequency.tracking.plot <- magick::image_graph(width=500,height=400)

for(i in biscuit.draws.chocolate.up[,n.draws]) {
  temp <-
    ggplot(data=biscuit.draws.chocolate.up[seq_len(i)],
           mapping=aes(x=n.draws,y=cumulative.frequency)) +
    theme_classic() +
    ylab("") + xlab("Number of draws") +
    ylim(0,1) + xlim(0,max(biscuit.draws.chocolate.up[,n.draws])) +
    geom_line(size=0.4) +
    geom_hline(yintercept=2/3,col="red",linetype="dashed")
  print(temp)
}
dev.off()

frequency.tracking.plot <- frequency.tracking.plot |>
  magick::image_border(color="black",geometry="1x1")


.mapply(
  FUN=function(freq,cumulative) {
    return(
      magick::image_append(c(freq,cumulative))
    )
  },
  dots=list(as.list(frequency.plot),
            as.list(frequency.tracking.plot)),
  MoreArgs=NULL) |>
  magick::image_join() |>
  magick::image_write_video(path="images/frequency_tracking_plot.mp4",framerate=30)

magick::image_destroy(frequency.plot)
magick::image_destroy(frequency.tracking.plot)