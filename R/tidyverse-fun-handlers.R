# tidyverse_execute ------------------------------------------------------------

# tidyverse_execute() executes any dplyr/tidyr/purrr function
# on a tbl_time object, in the process retaining
# time based classes and attributes that would normally be stripped
tidyverse_execute <- function(.x, fun, ...) {
  UseMethod("tidyverse_execute")
}

tidyverse_execute.default <- function(.x, fun, ...) {
  stop("`tidyverse_execute()` should only be called on a `tbl_time` object")
}

tidyverse_execute.tbl_time <- function(.x, fun, ...) {

  # Classes and attributes to keep
  time_classes <- stringr::str_subset(class(.x), "tbl_time")
  time_attrs <- list(
    index     = attr(.x, "index"),
    time_zone = attr(.x, "time_zone")
  )

  # Remove, execute dplyr fun, add back
  .x %>%
    detime(time_classes, time_attrs) %>%
    fun(...) %>%
    retime(time_classes, time_attrs)
}

# retime -----------------------------------------------------------------------

# retime() adds time based classes and attributes after a tidyverse manipulation
retime <- function(x, time_classes, time_attrs, ...) {
  UseMethod("retime")
}

retime.default <- function(x, time_classes, time_attrs, ...) {

  # Only retime if index still exists
  if(!check_for_index(x, time_attrs)) {
    message("Note: `index` has been removed. Removing `tbl_time` class.")
    return(x)
  }

  class(x) <- c(time_classes, class(x))
  attributes(x) <- c(attributes(x), time_attrs)

  x
}

# detime -----------------------------------------------------------------------

# detime() strips time based classes and attributes
# before a tidyverse manipulation
detime <- function(x, time_classes, time_attrs, ...) {
  UseMethod("detime")
}

detime.default <- function(x, time_classes, time_attrs, ...) {
  class(x) <- base::setdiff(class(x), time_classes)

  nontime_attrs <- setdiff(rlang::names2(attributes(x)),
                           rlang::names2(time_attrs))
  attributes(x) <- attributes(x)[nontime_attrs]

  x
}

# Utils ------------------------------------------------------------------------

check_for_index <- function(x, time_attrs) {
  rlang::quo_name(time_attrs[["index"]]) %in% colnames(x)
}

