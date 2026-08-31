test_that("input readers load bundled LAML fixtures", {
  mutation_file <- system.file("extdata", "mutationMat_LAML.txt", package = "MEGSA")
  simu_file <- system.file("extdata", "maxSSimu_LAML.txt", package = "MEGSA")

  mutationMat <- read_megsa_mutation_matrix(mutation_file)
  maxSSimu <- read_megsa_max_simu(simu_file)

  expect_equal(dim(mutationMat), c(196L, 26L))
  expect_equal(dim(maxSSimu), c(10000L, 5L))
  expect_true(is.logical(mutationMat))
})

test_that("likelihood estimation is stable under strict partial-match warnings", {
  mutation_file <- system.file("extdata", "mutationMat_LAML.txt", package = "MEGSA")
  mutationMat <- read_megsa_mutation_matrix(mutation_file)
  old <- options(warnPartialMatchArgs = TRUE, warnPartialMatchDollar = TRUE)
  on.exit(options(old), add = TRUE)

  expect_warning(
    estimate <- funEstimate(mutationMat[, c("FLT3", "TP53")]),
    NA
  )
  expect_equal(unname(estimate$gamma), 0.3791151, tolerance = 1e-5)
  expect_equal(estimate$S, 10.34514, tolerance = 1e-5)
})

test_that("global test reproduces LAML v2 search regression values", {
  mutation_file <- system.file("extdata", "mutationMat_LAML.txt", package = "MEGSA")
  simu_file <- system.file("extdata", "maxSSimu_LAML.txt", package = "MEGSA")
  mutationMat <- read_megsa_mutation_matrix(mutation_file)
  maxSSimu <- read_megsa_max_simu(simu_file)

  test <- funGlobalTest(mutationMat, maxSSimu = maxSSimu, detail = FALSE)

  expect_equal(test$p, 0)
  expect_equal(
    unname(test$maxSReal),
    c(11.149342, 25.088810, 29.036572, 31.595480, 32.902240),
    tolerance = 1e-5
  )
})

test_that("simulation path works when maxSSimu is not supplied", {
  set.seed(1)
  mutationMat <- simulate_mutation_matrix(40, 5, list(pi = 0.08), "H0")
  mutationMat[1:15, 1] <- TRUE
  mutationMat[16:30, 2] <- TRUE

  expect_no_error(
    result <- funSelect(
      mutationMat,
      maxSSimu = NULL,
      nSimu = 5,
      nPairStart = 2,
      maxSize = 3,
      level = 1,
      detail = FALSE,
      seed = 2
    )
  )
  expect_named(result, c("p", "MEGSList"))
})

test_that("parallel simulations return the expected shape", {
  set.seed(3)
  mutationMat <- simulate_mutation_matrix(20, 4, list(pi = 0.1), "H0")

  maxSSimu <- funMaxSSimu(
    mutationMat,
    nSimu = 2,
    nPairStart = 2,
    maxSize = 3,
    detail = FALSE,
    ncores = 2,
    seed = 4
  )

  expect_equal(dim(maxSSimu), c(2L, 2L))
})

test_that("empty MEGS results can be formatted and plotted", {
  mutationMat <- matrix(
    FALSE,
    4,
    2,
    dimnames = list(paste0("P", 1:4), paste0("G", 1:2))
  )

  out <- funPrintMEGS(list())
  expect_equal(nrow(out), 0L)
  expect_named(out, c("gene", "coverage", "LRT", "pNominal", "pCorrected"))

  files <- funPlotMEGS(list(), mutationMat, outputDir = tempdir(), type = "pdf")
  expect_equal(files, character())
})
