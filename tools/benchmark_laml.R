args <- commandArgs(trailingOnly = FALSE)
file_arg <- grep("^--file=", args, value = TRUE)
package_root <- if (length(file_arg) > 0) {
  normalizePath(file.path(dirname(sub("^--file=", "", file_arg[1])), ".."))
} else {
  normalizePath(getwd())
}

source(file.path(package_root, "R", "megsa.R"))

mutation_file <- file.path(package_root, "inst", "extdata", "mutationMat_LAML.txt")
max_simu_file <- file.path(package_root, "inst", "extdata", "maxSSimu_LAML.txt")
mutationMat <- read_megsa_mutation_matrix(mutation_file)
maxSSimu <- read_megsa_max_simu(max_simu_file)

time_it <- function(label, expr, n = 3) {
  expr <- substitute(expr)
  times <- numeric(n)
  for (i in seq_len(n)) {
    gc(FALSE)
    times[i] <- system.time(eval(expr, parent.frame()))[["elapsed"]]
  }
  cat(
    label,
    " median=", round(stats::median(times), 3),
    " min=", round(min(times), 3),
    " max=", round(max(times), 3),
    " all=", paste(round(times, 3), collapse = ","),
    "\n",
    sep = ""
  )
  invisible(times)
}

cat("MEGSA LAML benchmark\n")
cat("R: ", R.version.string, "\n", sep = "")
cat("Samples: ", nrow(mutationMat), "; genes: ", ncol(mutationMat), "\n", sep = "")

time_it(
  "funGlobalTest precomputed null",
  funGlobalTest(mutationMat, maxSSimu = maxSSimu, detail = FALSE)
)

time_it(
  "funMaxS screened search",
  funMaxS(mutationMat, nPairStart = 10, maxSize = 6, detail = FALSE)
)

time_it(
  "funEstimate FLT3+TP53 x100",
  for (i in seq_len(100)) funEstimate(mutationMat[, c("FLT3", "TP53"), drop = FALSE]),
  n = 5
)

time_it(
  "funEstimate six genes x100",
  for (i in seq_len(100)) funEstimate(mutationMat[, seq_len(6), drop = FALSE]),
  n = 5
)
