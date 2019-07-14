--- 
title: "Learning statistics with R"
author: "Danielle Navarro"
date: "14 July 2019"
url: 'https\://djnavarro.github.io/tidylsrbook'
github-repo: "djnavarro/tidylsrbook"
site: bookdown::bookdown_site
documentclass: book
bibliography: [book.bib, packages.bib]
biblio-style: apalike
link-citations: yes
description: "A gentle introduction to statistics and R using the tidyverse"
output: 
  bookdown::gitbook:
    config:
      toc:
        collapse: subsection
        scroll_highlight: yes
        before: null
        after: null
      download: ["pdf"]
    includes:
      in_header: my_header.html
  bookdown::pdf_book:
    includes:
      in_header: preamble.tex
    latex_engine: xelatex
    citation_package: natbib
    keep_tex: yes
---

# Preface {-}

This is a book. It contains things. Lots of exciting things.





