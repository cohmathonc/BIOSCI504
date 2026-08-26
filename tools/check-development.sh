#!/bin/sh

set -eu

repo_root=$(git rev-parse --show-toplevel)
cd "$repo_root"

echo "Checking R formatting..."
if command -v uvx >/dev/null 2>&1; then
  uvx --from air-formatter==0.9.0 air format . --check
elif command -v air >/dev/null 2>&1 && air --version | grep -Eq '(^|[[:space:]])0\.9\.0$'; then
  air format . --check
else
  echo "Install uvx or Air 0.9.0 before pushing." >&2
  exit 1
fi

echo "Checking generated package documentation..."
Rscript -e '
if (!requireNamespace("roxygen2", quietly = TRUE)) {
  stop("Install roxygen2 7.3.3 before pushing.", call. = FALSE)
}
installed_version <- as.character(utils::packageVersion("roxygen2"))
if (installed_version != "7.3.3") {
  stop(
    "Install roxygen2 7.3.3 before pushing; found ",
    installed_version,
    ".",
    call. = FALSE
  )
}
roxygen2::roxygenise()
'

untracked_docs=$(git ls-files --others --exclude-standard -- man)

if ! git diff --quiet -- DESCRIPTION NAMESPACE man || [ -n "$untracked_docs" ]; then
  echo "Package documentation is out of date; commit the generated changes." >&2
  git diff -- DESCRIPTION NAMESPACE man
  if [ -n "$untracked_docs" ]; then
    echo "$untracked_docs"
  fi
  exit 1
fi
