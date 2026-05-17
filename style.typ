#let target = dictionary(std).at("target", default: () => "paged")

// code font is also used in Typst; otherwise this is mainly for HTML output
#let body-font = "STIX Two Text"
#let code-font = "JetBrains Mono"

// Build Google Fonts URL: spaces in family names are encoded as '+'.
#let _gf-family(name, axes) = name.replace(" ", "+") + ":" + axes
#let fonts-url = (
  "https://fonts.googleapis.com/css2?family="
    + _gf-family(code-font, "wght@200;400;700")
    + "&family="
    + _gf-family(body-font, "ital,wght@0,400;0,700;1,400;1,700")
    + "&display=swap"
)

// Direct woff2 URLs for the latin subset of STIX Two Text, used for
// `<link rel=preload>` to parallelize font fetch with the CSS fetch.
// The path includes a Google-side version segment (`/v18/`) and content
// hash, so these may need refreshing if Google updates the font; a stale
// URL produces a wasted preload but no visual breakage. As of v18, each
// URL covers both 400 and 700 weight (regular+bold share one woff2,
// italic+bold-italic share another) — a Google packaging detail, not
// guaranteed across versions.
#let _stix-latin = "https://fonts.gstatic.com/s/stixtwotext/v18/YA9Vr02F12Xkf5whdwKf11l0p76Miw.woff2"
#let _stix-latin-italic = "https://fonts.gstatic.com/s/stixtwotext/v18/YA9Lr02F12Xkf5whdwKf11l0p7u8idfU.woff2"

// All `html.*` references below are wrapped in functions so they aren't
// evaluated when compiling to PDF (the `html` module only exists under
// `--features html`).

#let _preload-font(href) = html.elem("link", attrs: (
  rel: "preload",
  "as": "font",
  type: "font/woff2",
  href: href,
  crossorigin: "anonymous",
))

// Custom <head> to inject font-related stuff for earlier loading
// `document.title` is set via `#set document(title: ...)` in main.typ.
// `context` is required because `document.title` is contextual.
#let _html-head() = html.head(
  html.elem("meta", attrs: (charset: "utf-8"))
    + html.elem("meta", attrs: (
      name: "viewport",
      content: "width=device-width, initial-scale=1",
    ))
    + context html.elem("title", document.title)
      + html.elem("link", attrs: (
        rel: "preconnect",
        href: "https://fonts.gstatic.com",
        crossorigin: "",
      ))
      + _preload-font(_stix-latin)
      + _preload-font(_stix-latin-italic)
      + html.elem("link", attrs: (rel: "stylesheet", href: fonts-url))
      + html.elem(
        "style",
        ":root{--body-font:\"" + body-font + "\";--code-font:\"" + code-font + "\"}",
      )
      + html.elem("style", read("html-style.css")),
)

#let _html-toc() = html.elem("details", attrs: (class: "toc"))[
  #html.elem("summary")[Contents]
  #outline(title: none, depth: 4)
]

#let theme(body) = {
  // set text(
  //   font: "Latin Modern Roman 12",
  //   size: 11pt,
  // )

  // set page(fill: black)
  // set text(fill: rgb(234, 223, 200))
  // show link: set text(fill: rgb(150, 200, 237))

  // mimic HTML-like page-less format for PDF output
  set page(height: auto)

  set text(lang: "en")
  set par(linebreaks: "optimized", justify: true)

  set heading(numbering: "1.1.1.1  ")

  show title: set align(center)
  show title: set block(below: auto, above: auto)
  show title: set text(weight: "light", size: 22pt)

  show heading: set block(below: 10pt, above: auto)
  show heading.where(level: 1): set text(size: 14pt)
  show heading.where(level: 2): set text(size: 12pt)

  show raw: set text(
    font: code-font,
    weight: 200,
    size: 9.5pt,
  )

  show link: set text(fill: purple)

  set math.mat(delim: "[")
  set math.vec(delim: "[")

  show math.equation: it => context if target() == "html" {
    if it.block { html.frame(it) } else { box(html.frame(it)) }
  } else {
    it
  }

  // Wrap in html.html(...) so Typst suppresses its auto-generated
  // <head>/<body> and uses our custom head with font resources at the top.
  context if target() == "html" {
    html.html(_html-head() + html.body(_html-toc() + body))
  } else {
    body
  }
}


#let note-counter = counter("notes")
#let note-ref(label) = context {
  let n = note-counter.at(label).first()
  link(label)[#super[#text(fill: rgb(255, 155, 200))[#n]]]
}
#let note(label, body, number: false) = {
  note-counter.step()
  block([
    #if number {
      context note-counter.display()
    }
    #body
    #label
  ])
}


#let aside(body, fade: 50%) = context if target() == "html" {
  html.elem("blockquote", attrs: (class: "aside"))[#body]
} else {
  let fg = text.fill
  let bg = page.fill
  if bg == none or bg == auto { bg = white }
  let muted = color.mix((fg, 100% - fade), (bg, fade))
  pad(left: 2em, text(fill: muted, body))
}
