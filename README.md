# Source code for [dimitris.netlify.app](https://dimitris.netlify.app) blog posts

Here you can find the source code used for my blog posts on [dimitris.netlify.app](https://dimitris.netlify.app).

Each post has its own zip file, named according to the post's URL. For example, the source code for the post [dimitris.netlify.app/posts/random-biscuits/](https://dimitris.netlify.app/posts/random-biscuits/) is in the zip file "random-biscuits.zip".

## Prerequisites

-   The R language and the RStudio integrated development environment (IDE) must be installed. Download the appropriate installer for R [here](https://cran.r-project.org/), and for the desktop version of RStudio [here](https://www.rstudio.com/products/rstudio/download/).

-   R packages `knitr` and `rmarkdown` must be installed. Install them by running `install.packages(c("knitr","rmarkdown"))` in the R console.

## Description

Each zipped folder contains a file named "index.Rmd". This contains the main text and code chunks needed to recreate the full HTML document. Other contents may be:

-   A subfolder named "scripts". This contains scripts with code used during HTML rendering of "index.Rmd". Code chunks in "index.Rmd" run code from scripts in this folder.

-   Other possible files and folders, used for the HTML document.

The "index.Rmd" file and "scripts" folder contain **all** the text and code needed to recreate the HTML document. Exceptions to this are noted.

## Instructions

1.  Download the zip file and unzip its contents into a folder.

2.  Open the file "index.Rmd" with RStudio. This is an RMarkdown file, combining R code with Markdown-formatted text.

3.  Install R packages that are necessary for the code to run. These are noted in 1st code chunk. Run `install.packages(c("package.1","package.2",...))` in the R console (substituting `"package.1", "package.2",...` with the actual package names). Do not forget to add quote marks.

4.  **Play around**: Try your own modifications to the code chunks of "index.Rmd" or to the linked scripts. When finished, select *File \> Knit Document* to render the RMarkdown document into HTML.

    **Note:** I try to optimize the code for minimal repetition of computationally-intensive processes during re-rendering to HTML. This means that, once such a process is finished (e.g. to create a data set, image, or animation), its result is stored in a file for future reading. If such a file already exists during rendering, it is read and not created anew. **If you want to create new such files, you need to delete or rename the original ones, so they are not detected during rendering.**

5.  The resulting document named "index.html" should be created. View it with any HTML browser.
