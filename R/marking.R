#' Convert a submitted hash code to a learnr document
#' for marking
#'
#' @param hash_code Character. hash code to convert
#' @param assignment_path Path to assignment .Rmd
#'
#' @return
#' @export
#'
#' @examples
convert_hash_code <- function(hash_code, assignment_path,
                              rmd_path = tempfile(fileext = ".Rmd"),
                              student = "Test student") {

  rmd_dat <- parsermd::parse_rmd(assignment_path, parse_yaml = TRUE) %>%
    as_tibble()

  ast_classes <- lapply(rmd_dat$ast, class)

  hash_dat <- learnrhash::decode_obj(hash_code)
  rmd_dat <- rmd_dat %>%
    left_join(hash_dat %>%
                select(label, type2 = type, answer)) %>%
    mutate(type2 = replace_na(type2, "")) %>%
    mutate(new_ast = map_if(transpose(list(ast, answer)),
                            type2 == "exercise",
                            ~ assign_in(.x[[1]], "code", .x[[2]]),
                            .else = ~ .x[[1]])) %>%
    mutate(ast = new_ast) %>%
    select(-type2:-new_ast)

  class(rmd_dat$ast) <- c("rmd_ast", "list")

  rmd_dat$ast[[1]]$title <- paste(rmd_dat$ast[[1]]$title,
                                  "by", student)

  write_lines(parsermd::as_document(rmd_dat),
             rmd_path)

  learnr::run_tutorial(rmd_path)

  list(file = rmd_path, answers = hash_dat %>%
         left_join(learnr::get_tutorial_info(assignment_path)$items %>%
                     select(label, order)) %>%
         arrange(order))

}
