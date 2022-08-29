# blog_public
Source code for blog posts on https://dimitris.netlify.app

Here you can find the source code used in my blog posts on <https://dimitris.netlify.app>. Each post has its own zip file, named according to the post's URL.

For example, the source code for the post <https://dimitris.netlify.app/posts/random-biscuits/> is in the zip file "random-biscuits.zip".

## Prerequisites:

- R and RStudio installed in your system.

- R packages knitr and rmarkdown (install them by running `install.packages(c("knitr","rmarkdown")` in the R environment).

## Instructions:

1. Download and unzip the directory.

2. Open the file "index.Rmd" with RStudio.

3. Install necessary packages noted in 1st code chunk.

4. Make changes and press the knit button.

Considerations:

- The "index.Rmd" file contains the main text and code chunks with **all** the scripting needed to recreate the blog post.
Exceptions to this are noted.

- Often, code chunks in "index.Rmd" link to external scripts, contained in a "scripts" subfolder. These are also necessary to recreate the post.

- I try to optimize the code for minimal repetition of long procedures during re-rendering.
This means that, once a long process is finished, its result is stored in a file for future reading.
If the file already exists during rendering, it is read and not created anew.
If you want to create new such files, you need to delete or rename the original files so they are not detected during rendering.
