# MEGSA 1.0.0.9000

## Development

- Started development toward MEGSA 1.0.1.
- Optimized likelihood setup in `funEstimate()` by reusing per-gene-set
  quantities during optimizer calls.
- Reused the screened-search correlation matrix within `funMaxS()`.
- Added `tools/benchmark_laml.R` for repeatable local timing checks with the
  bundled LAML example data.
- Added the parallel simulation interface for MEGSA 1.0.1 through the `ncores`
  argument.
- Made seeded null-distribution simulations reproducible across worker counts.

# MEGSA 1.0.0

- Released the first formal R package version of MEGSA.
- Added package metadata, GPL-3 licensing, namespace exports, roxygen
  documentation, and citation metadata.
- Added regression tests based on the original LAML example data.
- Added bundled example data under `inst/extdata`.
- Added GitHub Actions continuous integration for `R CMD check`.
