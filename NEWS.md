# MEGSA 1.0.2

- Added a package vignette as a practical user guide for input files, global
  testing, null-distribution simulation, and result export.
- Added a helper script for generating the PDF function reference manual from
  the package Rd documentation.
- Added a README workflow section with links to the published paper figures and
  package-generated LAML example output plots.
- Updated GitHub Actions to build and check package vignettes.

# MEGSA 1.0.1

- Added GitHub Actions continuous integration for `R CMD check`.
- Optimized likelihood setup in `funEstimate()` by reusing per-gene-set
  quantities during optimizer calls.
- Reused the screened-search correlation matrix within `funMaxS()`.
- Added `tools/benchmark_laml.R` for repeatable local timing checks with the
  bundled LAML example data.
- Documented and stabilized the parallel simulation interface through the
  `ncores` argument.
- Made seeded null-distribution simulations reproducible across worker counts
  and preserved the caller RNG stream when `seed` is supplied.

# MEGSA 1.0.0

- Released the first formal R package version of MEGSA.
- Added package metadata, GPL-3 licensing, namespace exports, roxygen
  documentation, and citation metadata.
- Added regression tests based on the original LAML example data.
- Added bundled example data under `inst/extdata`.
