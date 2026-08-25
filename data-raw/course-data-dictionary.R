source("R/generate-course-data-dictionary.R")

course_data_dictionary <- .generate_course_data_dictionary()

dir.create("data", showWarnings = FALSE)
save(
  course_data_dictionary,
  file = "data/course_data_dictionary.rda",
  compress = "xz"
)
