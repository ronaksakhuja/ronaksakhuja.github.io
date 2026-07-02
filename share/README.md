# Share

Static HTML pages hosted at `https://ronaksakhuja.github.io/share/<name>.html`.

## Publish a new page

```bash
~/Projects/ronaksakhuja.github.io/share/publish.sh /path/to/local.html <slug>
```

Example:
```bash
~/Projects/ronaksakhuja.github.io/share/publish.sh /tmp/report.html quarterly_review
```

→ https://ronaksakhuja.github.io/share/quarterly_review.html (~30 sec after push)

Overwrites any existing page with the same slug.

## Why this bypasses Jekyll

This repo serves from `master` (the built branch, has `.nojekyll`). The
`publish.sh` script pushes directly to `master` so self-contained HTML is
served as-is — no Jekyll rebuild, no wait for the Actions workflow (which is
currently broken due to an expired `APP_TOKEN` and a Ruby version mismatch).

If the Jekyll source on `gh-pages` is ever needed for authoring, fix those
two issues first.
