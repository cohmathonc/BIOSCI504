build_biosci504_site <- function(
  pkg = ".",
  dest_dir = file.path(pkg, "docs"),
  install = FALSE,
  new_process = FALSE
) {
  pkgdown::build_site_github_pages(
    pkg = pkg,
    dest_dir = dest_dir,
    install = install,
    new_process = new_process
  )

  internal_pages <- c("CONTRIBUTING.html", "ROADMAP.html")
  unlink(file.path(dest_dir, internal_pages))

  sitemap_path <- file.path(dest_dir, "sitemap.xml")
  if (file.exists(sitemap_path)) {
    sitemap <- xml2::read_xml(sitemap_path)
    locations <- xml2::xml_find_all(sitemap, ".//*[local-name()='loc']")
    internal <- basename(xml2::xml_text(locations)) %in% internal_pages
    xml2::xml_remove(xml2::xml_parent(locations[internal]))
    xml2::write_xml(sitemap, sitemap_path)
  }

  invisible(dest_dir)
}
