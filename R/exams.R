#' Access an exam with a password
#'
#' @param exam_name Name of the exam you want to access (this will be given
#' in class, along with the password)
#'
#' @return
#' @export
#'
#' @examples
#' access_exam("practice_1")
access_exam <- function(exam_name) {
  passwd <- rstudioapi::askForPassword()
  key <- cyphr::key_sodium(sodium::hash(charToRaw(passwd)))

  exam_file <- get_exam_file(exam_name)

  cyphr::decrypt_file(exam_file, key, exam_file)

}

encrypt_exam <- function(exam_name, passwd) {

  key <- cyphr::key_sodium(sodium::hash(charToRaw(passwd)))
  exam_file <- get_exam_file(exam_name)

  cyphr::encrypt_file(exam_file, key, exam_file)

}

get_exam_file <- function(exam_name) {
  exam_file <- switch(exam_name,
                      practice_1 = system.file("tutorials", "exam_1_practice", "exam_1_practice.Rmd", package = "fofpack"),
                      practice_1_solutions = system.file("tutorials", "exam_1_practice", "exam_1_practice_solutions.Rmd", package = "fofpack"),
                      exam_1 = system.file("tutorials", "exam_1", "exam_1.Rmd", package = "fofpack"),
                      "Exam not found")
  exam_file
}

#' Check if an exam is available in the `fofpack` package
#'
#' @param exam_name Name of the exam to check for, e.g. `"exam_1"`
#'
#' @return TRUE invisibly if the exam is available, or FALSE otherwise
#' @export
#'
#' @examples
#' check_exam("exam_1")
check_exam_avail <- function(exam_name) {
  exam_file <- get_exam_file(exam_name)
  if(exam_file != "" && file.exists(exam_file)) {
    message("Exam ", exam_name, "is available in fofpack")
    return(invisible(TRUE))
  } else {
    warning("Exam ", exam_name, " is not currently available in fofpack")
    return(invisible(FALSE))
  }
}

