args <- commandArgs(trailingOnly = FALSE)
file_arg <- grep("^--file=", args, value = TRUE)
package_root <- if (length(file_arg) > 0) {
  normalizePath(file.path(dirname(sub("^--file=", "", file_arg[1])), ".."))
} else {
  normalizePath(getwd())
}

output_file <- file.path(package_root, "MEGSA-reference-manual.pdf")
r_bin <- file.path(R.home("bin"), if (.Platform$OS.type == "windows") "R.exe" else "R")
build_dir <- tempfile("Rd2pdf-")
dir.create(build_dir)
on.exit(unlink(build_dir, recursive = TRUE, force = TRUE), add = TRUE)

status <- system2(
  r_bin,
  c(
    "CMD", "Rd2pdf",
    "--force",
    "--no-preview",
    "--no-index",
    paste0("--build-dir=", build_dir),
    "--title=MEGSA",
    paste0("--output=", output_file),
    package_root
  )
)

if (!identical(status, 0L)) {
  stop("Failed to build reference manual.", call. = FALSE)
}

cat("Wrote ", output_file, "\n", sep = "")
