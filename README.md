# md2pdf

Turns a Markdown file into a clean, styled PDF proposal with cover page support and embedded typography.

## How it works

`md2pdf.sh` is a one-line wrapper around the
[`md-to-pdf`](https://github.com/simonhaenisch/md-to-pdf) npm package,
run via `npx` so nothing needs installing up front:

```bash
npx md-to-pdf input.md --stylesheet style.css
```

Under the hood it parses the Markdown with `marked` (a GFM-compliant
parser — same rules GitHub itself uses, so lists right after a
`**Label:**` line render correctly without any special flags) and
renders the HTML to PDF with a bundled headless Chromium (Puppeteer).
First run downloads that Chromium (~200MB, one-time, needs internet);
after that it's cached and works offline.

All the visual styling lives in `style.css` — colors, heading sizes,
table look, the cover page, and the **Lexend font embedded as base64**
so the PDF looks the same on any machine regardless of what's
installed locally.

*(An earlier version of this tool drove `pandoc` + a manually-launched
headless Chrome directly — same underlying idea, more moving parts to
maintain. This wrapper does the same thing with one dependency instead
of two, and no hardcoded Chrome path.)*

## Install

```bash
brew tap chavisnguyen/md2pdf https://github.com/chavisnguyen/md2pdf
brew install md2pdf
```

Or via [gear](https://github.com/chavisnguyen/gear):

```bash
gear add github:chavisnguyen/md2pdf
```

## Usage

```bash
md2pdf input.md
```

Writes `input.pdf` next to the input file.

Requires Node.js (`npx`). Nothing else to install — `npx` fetches
`md-to-pdf` on first run and caches it.

## Markdown conventions

Plain GitHub-flavored Markdown works as-is: headings, lists, tables,
bold/italic, links, code. Two extra conventions this stylesheet knows
about, both just raw HTML embedded directly in the `.md` file (Markdown
passes raw HTML through untouched, so this always works):

**Cover page.** Put a `# ...` title line, a `## ...` subtitle line, and
a `cover-meta` table right after them, then a `---`. The stylesheet
forces a page break immediately after the *first* `---` in the whole
document, so everything above it renders as a standalone cover page:

```markdown
# Project Proposal
## My Project Title

<table class="cover-meta">
<tr><td class="label">Prepared for:</td><td class="value">Client Co.</td></tr>
<tr><td class="label">Prepared by:</td><td class="value">Your Team</td></tr>
<tr><td class="label">Date:</td><td class="value">Aug 23, 2026</td></tr>
<tr><td class="label">Version:</td><td class="value">1.0</td></tr>
</table>

---

## 1. Executive Summary
...
```

**Highlights.** Wrap any paragraph or line in `<mark>...</mark>`, with
normal Markdown (bold, etc.) written inside it:

```markdown
<mark>**Investment:** ~$12,000 USD for development.</mark>
```

## Customizing the look

Everything visual lives in `style.css`: colors, heading sizes, table
styling, the `@page` margins/size. It's plain CSS — Chrome's print
engine supports most of the CSS Paged Media spec (`@page`,
`page-break-before/after/inside`, etc.), which is what makes the cover
page and table-row-splitting behavior possible.

To swap the font: replace the base64 string in the single `@font-face`
block at the top of `style.css`. Get a new one with:

```bash
curl -s "https://fonts.googleapis.com/css2?family=YOUR_FONT:wght@400;700&display=swap" \
  -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 Chrome/120.0 Safari/537.36" \
  | grep -o 'https://fonts.gstatic.com/[^)]*' | head -1
# then curl that URL to a .woff2 file and base64-encode it
```

(The User-Agent matters — without a modern browser UA, Google Fonts
serves old woff/ttf formats instead of a modern variable woff2.)
