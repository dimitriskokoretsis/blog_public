---
title: 'Drawing random biscuits: from probability to data'
author: Dimitris Kokoretsis
date: '2022-08-28'
slug: random-biscuits
categories: []
mathjax: true
tags:
  - probability
  - frequency
  - statistics
  - simulation
  - r-programming
---



I stumbled upon a probability exercise at a time when I had just built enough confidence using R, and I was eager for "toy problems" to play with. It was a simple brain teaser, barely more complicated than the well-known <a href="https://en.wikipedia.org/wiki/Coin_flipping" target="_blank">coin toss</a>. I could solve it with pen and paper, but I wanted to squeeze out of it as much as I could.

My central thesis in this post is that, if we formulate our assumptions well, we can turn questions about **probability** into questions about **data**.

## The problem

> You have three biscuits in a box. Each biscuit has two sides, and each side is covered in either white icing or chocolate. One biscuit has two chocolate sides. The second biscuit has one chocolate and one white icing side. The third biscuit has two white icing sides.
>
> You reach into the box, draw out a biscuit and place it flat on the table. A chocolate side is shown facing up, but you do not know the color of the side facing down. Prove that the probability that the other side is also chocolate is `\(\frac{2}{3}\)`.

Let's take it apart. The problem asks a question based on certain assumptions. These assumptions are what I'm going to call a **system** and a **process**.



#### The system

There are 3 biscuits in the box:

1.  Both sides covered in chocolate

2.  One side covered in chocolate and one covered in icing

3.  Both sides covered in icing

#### The process

One random biscuit is drawn out. We see that its up-facing side is covered in chocolate, but we don't see its down-facing side.

#### The task

Show that the probability of its down-facing side being also covered in chocolate is `\(\frac{2}{3}\)` (or 0.666...).



<div class="figure">
<img src="images/intro_illustration.gif" alt="Biscuit-drawing problem" width="75%" />
<p class="caption">Figure 1: Biscuit-drawing problem</p>
</div>

## How *not* to solve it

If we feel **really** confident, we can go along this line of thought:

-   The up-facing side of our drawn biscuit is covered in chocolate, so there are two possibilities:

    1.  Either it is the one whose both sides are covered in chocolate `\(\implies\)` its down-facing side also has chocolate,

    2.  or it is the mixed one `\(\implies\)` its down-facing side has icing.

-   This means that the probability of the down-facing side being chocolate is 50%, or `\(\frac{1}{2}\)`.

And we already know we're wrong, because our result is not `\(\frac{2}{3}\)`.

So... what went wrong? Well, it all started when we felt **really** confident and "solved" it in a matter of seconds. Because of this, we didn't formulate the assumptions correctly.

The correct pen-and-paper way to solve it is [shown](#analytical-solution) at the end of this post, but for now, let's see how we can make the computer solve it for us.

## Solution

The task concerns *probability*, which is about predicting future outcomes. Now, computers are not very good fortune-tellers but they are good at processing data.

To take advantage of this, we can turn the task into a statistical one:

> "Of the times a chocolate side was placed facing up, show that the *frequency* of its down-facing side being also chocolate is `\(\frac{2}{3}\)`."

### Simulate and collect data

First, we **define the system**: 3 biscuits and the box containing them.


```r
# Biscuits with 2 sides are defined (vectors with 2 elements)
biscuit.1 <- c("chocolate","chocolate")
biscuit.2 <- c("chocolate","icing")
biscuit.3 <- c("icing","icing")

# and placed in a list named "box".
box <- list(biscuit.1,biscuit.2,biscuit.3)
```

Next, we **simulate the process** of biscuit drawing repeatedly, and collect the data. Any large number of repetitions will do. The code below performs this 2000 times and collects the results in a `data.table` named `biscuit.draws` for further analysis.

I use the <a href="https://rdatatable.gitlab.io/data.table/" target="_blank">`data.table`</a> package for filtering and summarizing data (to experienced R users: no disrespect to the Tidyverse, I just avoid it as much as I can).


```r
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
```



### Results

Let's take a quick peek at our data:




```r
biscuit.draws
```

```
##         up.side down.side
##    1: chocolate chocolate
##    2: chocolate chocolate
##    3:     icing     icing
##    4: chocolate     icing
##    5: chocolate chocolate
##   ---                    
## 1996: chocolate chocolate
## 1997: chocolate chocolate
## 1998: chocolate chocolate
## 1999: chocolate chocolate
## 2000:     icing chocolate
```

Indeed, there are 2000 rows and each row shows the results of one drawing process. Let's count how many times each different type of side was placed facing up:


```r
# Count occurrences of each different type of up.side
# ".N" is a special symbol in data.table, which gives the number of rows
biscuit.draws[,.(count=.N),by=up.side]
```

```
##      up.side count
## 1: chocolate  1013
## 2:     icing   987
```

Chocolate and icing were drawn as up-facing sides about half of the times each (1013 and 987, out of 2000 total draws). Now let's count how many times each **combination** of sides was drawn:


```r
# Count occurrences of up.side and down.side combinations
biscuit.draws[,.(count=.N),by=.(up.side,down.side)]
```

```
##      up.side down.side count
## 1: chocolate chocolate   667
## 2:     icing     icing   656
## 3: chocolate     icing   346
## 4:     icing chocolate   331
```

So, from the 1013 times the up-facing side was chocolate, the down-facing side was also chocolate 667 times - **suspiciously** close to `\(\frac{2}{3}\)` of 1013.





<div class="figure">
<img src="images/simulation_result.gif" alt="Left: illustration of random biscuit drawing; right: results after 2000 biscuit draws. Green frame on right side: considered cases." width="100%" />
<p class="caption">Figure 2: Left: illustration of random biscuit drawing; right: results after 2000 biscuit draws. Green frame on right side: considered cases.</p>
</div>

Let's calculate the exact frequency:


```r
# Of the draws that resulted in chocolate up-side,
# count the ones that also had chocolate down-side
# and divide them by the total draws with chocolate up-side.
biscuit.draws[up.side=="chocolate",
              sum(down.side=="chocolate")/.N]
```

```
## [1] 0.6584403
```

This number is incredibly close to the desired `\(\frac{2}{3}\)`, or 0.666.

#### Significance testing

We could stop here, declare victory, and it would be fine. In the interest of thoroughness, we can perform a *chi-squared* goodness-of-fit test to formally check if the observations deviate significantly from our expectations.

As in any significance test, there is a *null hypothesis* that the observations comply with our expected frequencies. If the resulting p-value is *less than 0.05*, then we can conclude that the observed frequencies deviate significantly from our expectation. Otherwise, we cannot reject the null hypothesis.

**Note:** The p-value threshold needs to be specified before performing the test and is arbitrary. The 0.05 threshold we chose is solely based on common practice. We could make it more stringent (e.g. 0.01) or more relaxed (e.g. 0.1). The p-value answers the (admittedly complicated) question: "What is the probability of these observations to come up if the null hypothesis is true?". More information on p-values <a href="https://www.statisticshowto.com/probability-and-statistics/statistics-definitions/p-value/" target="_blank">here</a>.


```r
# How many draws resulted in both sides chocolate
both.sides.chocolate <- biscuit.draws[up.side=="chocolate" & down.side=="chocolate", .N]

# How many draws resulted in only up-facing side chocolate
upside.only.chocolate <- biscuit.draws[up.side=="chocolate" & down.side=="icing", .N]

# Chi-squared test for goodness of fit
# x is the numbers of observed events
# p is the expected probabilities corresponding to the events
chisq.test(x=c(both.sides.chocolate,upside.only.chocolate),
           p=c(2/3,1/3))
```

```
## 
## 	Chi-squared test for given probabilities
## 
## data:  c(both.sides.chocolate, upside.only.chocolate)
## X-squared = 0.30849, df = 1, p-value = 0.5786
```

The resulting p-value is **way** higher than 0.05, which formalizes a bit more our initial conclusion: the probability in question is indeed `\(\frac{2}{3}\)`.

#### Progression of frequency

So far, we've examined the end-point results **after** 2000 biscuit draws: the resulting frequency is about `\(\frac{2}{3}\)`, which is perfectly sufficient for our question.

The benefit of data-driven analysis is, we can look at the data in any way we want. Consider the following question:

> During the 2000 biscuit draws, how did the frequency progress until reaching `\(\frac{2}{3}\)`?

Let's see what the data says, on the following video:



<video width="664" height="402" controls>

<source src="images/frequency_tracking_plot.mp4" type="video/mp4">

</video>

Video 1: Progression of frequency throughout simulations. Red dashed line at `\(\frac{2}{3}\)`.

During the first few draws the frequency fluctuates, then it sits a bit higher than `\(\frac{2}{3}\)`, before settling at `\(\frac{2}{3}\)` after around 300 simulated draws. This makes sense: each biscuit draw is random individually, so the first few draws show no pattern. But the more data we gather, the more the frequency **approaches** the true probability.

### Analytical solution

The "traditional" way to approach this problem is to lay down and count all possible outcomes to find the **true** probabilities. This is also called the *counting* method.

There are 3 biscuits, i.e. 6 up-facing sides available to draw from:

-   3 chocolate sides:

    1.  One side of biscuit with both sides covered in chocolate `\(\implies\)` down-facing side: chocolate

    2.  Other side of biscuit with both sides covered in chocolate `\(\implies\)` down-facing side: chocolate

    3.  Chocolate side of mixed biscuit `\(\implies\)` down-facing side: icing

-   3 icing sides (we don't care about these cases):

    1.  One side of biscuit with both sides covered in icing `\(\implies\)` down-facing side: icing

    2.  Other side of biscuit with both sides covered in icing `\(\implies\)` down-facing side: icing

    3.  Icing side of mixed biscuit `\(\implies\)` down-facing side: chocolate

Let's depict these outcomes in the *sample space*, which includes all possible outcomes of the biscuit drawing process:



<div class="figure">
<img src="images/probability_result.gif" alt="Left: illustration of random biscuit drawing; right: sample space including all possible outcomes of the process. Green frame on right side: considered outcomes." width="100%" />
<p class="caption">Figure 3: Left: illustration of random biscuit drawing; right: sample space including all possible outcomes of the process. Green frame on right side: considered outcomes.</p>
</div>

It's obvious from the outcome listing and from figure 3 that the real probability of a down-facing chocolate side after a chocolate-covered up-facing side actually is `\(\frac{2}{3}\)`.

## What's the point

The biscuit-drawing problem gives a random process, and asks a question about probability. The [analytical method](#analytical-solution) is to count all possible outcomes to derive the *true probabilities*. On the other hand, our [simulation method](#solution) was to repeat the process 2000 times and look at *frequencies* of events as a read-out of their probabilities.

The two methods arrive to the same conclusion from different angles. The **analytical method** is *deductive*. It relies on intuition to consider all outcomes of the random process and gives definitive answers. It's a *top-down* approach to the answer. On the contrary, our **simulation method** is *inductive*. It is agnostic to the possible outcomes of the random process and only requires its accurate formulation, with the result emerging as a pattern from performing it. It's a *bottom-up* approach.

|  | Analytical method | Simulation method |
| - | ------------------ | ------------------ |
Reasoning: | Deductive | Inductive |
Requires: | Understanding of process and outcomes | Understanding of process, multiple iterations |
Provides: | True probabilities | Close approximations |

By now, it's fair to wonder: what's the point? Why go through the trouble to simulate hundreds or thousands of iterations and analyze data (and learn coding to do all that), when you can just use the counting method? It requires extra effort and, after all, simulations only give *approximate* probabilities.

Simulation approaches are not meant to substitute analytical ones but to complement them, adding value in (at least) the following ways:

-   As they don't rely on intuition, they can point towards the right conclusions, even if they are counter-intuitive (as in the <a href="https://en.wikipedia.org/wiki/Monty_Hall_problem" target ="_blank">Monty Hall problem</a>).

-   They can provide leads for analytical research.

-   Educational value:
    
    -   They enable a more *interactive* pedagogical approach: recreating a process and analyzing tangible data allows the learner to reach the conclusions on their own.
    
    -   They help the learner bridge the mental gap between probability theory and statistics.

(*Full source code for post on <a href="https://github.com/dimitriskokoretsis/blog_public/tree/main/random-biscuits" target="_blank">GitHub</a>*)
