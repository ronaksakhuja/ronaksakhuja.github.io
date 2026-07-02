# Share

Static HTML pages hosted at `https://ronaksakhuja.github.io/share/<name>.html`.

## Publish a new page

```bash
~/Projects/ronaksakhuja.github.io/share/publish.sh /path/to/local.html <slug>
```

Example:
```bash
~/Projects/ronaksakhuja.github.io/share/publish.sh /tmp/visualize/2026-07-02/bmw/index.html car_buy_vs_not
```

Publishes to `https://ronaksakhuja.github.io/share/car_buy_vs_not.html` (allow ~1 min for GitHub Pages to rebuild).

The slug becomes the filename. Existing pages with the same slug are overwritten.
