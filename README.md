# MEGSA

[![R-CMD-check](https://github.com/xhua84/MEGSA/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/xhua84/MEGSA/actions/workflows/R-CMD-check.yaml)

MEGSA is a framework for analyzing mutual exclusivity of tumor mutations. It was originally developed to identify mutually exclusive gene sets using a likelihood ratio test and model selection procedure, with support for de novo discovery, pathway-guided searches, and expansion of established gene sets.

This repository contains the formal R package version of MEGSA. The original public release was distributed as R scripts and example data through the National Cancer Institute Division of Cancer Epidemiology and Genetics (DCEG) website. The goal of this repository is to modernize that code into an installable, documented, tested R package.

## Development Status

The R package is under active development. The initial package release includes documented functions, regression tests based on the original LAML example data, and optional parallel simulation support.

## Installation

```r
install.packages("devtools")
devtools::install_github("xhua84/MEGSA")
```

## Quick Start

```r
library(MEGSA)

mutation_file <- system.file("extdata", "mutationMat_LAML.txt", package = "MEGSA")
max_simu_file <- system.file("extdata", "maxSSimu_LAML.txt", package = "MEGSA")

mutation_mat <- read_megsa_mutation_matrix(mutation_file)
max_simu <- read_megsa_max_simu(max_simu_file)

result <- megsa(mutation_mat, maxSSimu = max_simu, maxSize = 6)
result
as.data.frame(result)
```

## Original Software

The original MEGSA source-code bundle is available from the DCEG tool page:

https://dceg.cancer.gov/tools/analysis/megsa

## Reference

Hua X, Hyland PL, Huang J, Song L, Zhu B, Caporaso NE, Landi MT, Chatterjee N, Shi J. 2016. MEGSA: A powerful and flexible framework for analyzing mutual exclusivity of tumor mutations. *The American Journal of Human Genetics* 98(3):442-455. https://doi.org/10.1016/j.ajhg.2015.12.021
